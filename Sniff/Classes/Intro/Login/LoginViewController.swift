//
//  LoginViewController.swift
//  Sniff
//
//  Created by Andrea Ferrando on 26/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import SwiftFetchedResultsController
import RealmSwift
import FBSDKCoreKit
import FBSDKLoginKit
import Google
import SABlurImageView

class LoginViewController: UIViewController, GIDSignInUIDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var backgroundImageView: SABlurImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        var filePath: String?
        #if RELEASE
            filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        #else
            filePath = Bundle.main.path(forResource: "GoogleService-Info-beta", ofType: "plist")
        #endif
        if let path = filePath {
            if let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                if let clientID = dict["CLIENT_ID"] as? String {
                    GIDSignIn.sharedInstance().clientID = clientID
                }
            }
        }
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        
//        DispatchQueue.main.async {
//            self.backgroundImageView.addBlurEffect(80)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SFAnalytics.addScreenTracking(screenName:"Login")
    }
    
    
    //MARK: - Login Buttons - Facebook
    @IBAction func onBtnFacebookClicked(_ sender: AnyObject) {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error == nil && result != nil && result!.isCancelled == false {
                guard let current = FBSDKAccessToken.current() else { return }
                guard let token = current.tokenString else { return }
                SFHud.showLoading()
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email"])
                graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                    var email: String? = nil
                    if let result = result as? NSDictionary {
                        if let emailAddress = result["email"] as? String {
                            email = emailAddress
                        }
                    }
                    self.performLogin(email: email, fb_token: token, google_token: nil, linkedin_token: nil, password: nil)
                })
            }
        }
    }
    
    //MARK: - Login Buttons - Linkedin
    @IBAction func onLinkedinBtnClicked(_ sender: AnyObject) {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
            guard let session = LISDKSessionManager.sharedInstance().session else { return }
            SFHud.showLoading()
            let token = session.accessToken.accessTokenValue
            self.performLogin(email: nil, fb_token: nil, google_token: nil, linkedin_token: token, password: nil)
        }) { (error) -> Void in }
    }
    
    //MARK: - Login Buttons - Google
    @IBAction func onGooglePlusBtnClicked(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Swift.Error!) {
        if error != nil { return }
        SFHud.showLoading()
        let token = user.authentication.idToken, email = user.profile.email
        performLogin(email: email, fb_token: nil, google_token: token, linkedin_token: nil, password: nil)
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Swift.Error!) {
         // Perform any operations when the user disconnects from app here.
    }
    
    //MARK: - Perform Login
    func performLogin(email:String?, fb_token: String? = nil, google_token: String? = nil, linkedin_token: String? = nil, password: String?) {
        if email != nil && (password != nil || fb_token != nil || google_token != nil || linkedin_token != nil) {
           SFNetworkManager.Login.post(email: email!, password: password, fb_token: fb_token, google_token: google_token, linkedin_token: linkedin_token, completion: { (error, value) in
                SFHud.dismissLoading()
                guard error == nil else {
                    SFAlertMessage.alertCancel(title: SFConstants.Strings.Error.Login.authenticationTitle, message: error, cancelTitle: "Ok", viewController: self)
                    return
                }
                if let dict = value as? [String: Any] {
                    SFRealmManager.loginUser(dict:dict)
                    self.goToNextPage()
                } else {
                    SFAlertMessage.alertCancel(title: SFConstants.Strings.Error.Login.authenticationTitle, message: SFConstants.Strings.Error.Login.authenticationMessage, cancelTitle: "Ok", viewController: self)
                }
           })
        } else {
            SFHud.dismissLoading()
            SFAlertMessage.alertCancel(title: SFConstants.Strings.Error.Login.authenticationTitle, message: SFConstants.Strings.Error.Login.authenticationMessage, cancelTitle: "Ok", viewController: self)
        }
    }
    
    func goToNextPage() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let targetVC: UIViewController = sb.instantiateViewController(withIdentifier: "HomeViewController")
        dismiss(animated: false) {
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(targetVC, animated: true)
            }
        }
    }
    
    
    @IBAction func onBtnLoginClicked(_ sender: AnyObject) {
        guard let emailTyped = tfEmail.text, let pswTyped = tfPassword.text else { return }
        
        if emailTyped != "" && emailTyped != " " && emailTyped.isEmailValid {
            if pswTyped != "" && pswTyped != " " && pswTyped.isPasswordValid() {
                self.performLogin(email: emailTyped, password: pswTyped)
            } else {
                SFAlertMessage.alertCancel(title: SFConstants.Strings.Error.SignUp.genericTitle, message: SFConstants.Strings.Error.SignUp.pswNotCorrectMessage, cancelTitle: "Ok", viewController: self)
            }
        } else {
            SFAlertMessage.alertCancel(title: SFConstants.Strings.Error.Login.genericTitle, message: SFConstants.Strings.Error.Login.emailNotCorrectMessage, cancelTitle: "Ok", viewController: self)
        }
    }
    
    @IBAction func onBtnForgotPswClicked(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBtnBackClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

















