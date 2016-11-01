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
    var hideBar = true
    
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
        SFGeneralManager.SFLoginSignupManager.onBtnFacebookClicked(isLogin:true, viewController: self) { (error) in
            if error != nil {
                SFAlertMessage.alertCancel(title: SFConstants.Strings.Error.Login.authenticationTitle, message: error, cancelTitle: "Ok", viewController: self)
            } else {
                self.goToNextPage()
            }
        }
    }
    
    //MARK: - Login Buttons - Linkedin
    @IBAction func onLinkedinBtnClicked(_ sender: AnyObject) {
        SFGeneralManager.SFLoginSignupManager.onLinkedinBtnClicked(isLogin: true, completion: { (error) in
            if error != nil {
                SFAlertMessage.alertCancel(title: SFConstants.Strings.Error.Login.authenticationTitle, message: error, cancelTitle: "Ok", viewController: self)
            } else {
                self.goToNextPage()
            }
        })
    }
    
    //MARK: - Login Buttons - Google
    @IBAction func onGooglePlusBtnClicked(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Swift.Error!) {
        SFGeneralManager.SFLoginSignupManager.sign(isLogin:true, signIn, didSignInFor: user, withError: error) { (error) in
            if error != nil {
                SFAlertMessage.alertCancel(title: SFConstants.Strings.Error.Login.authenticationTitle, message: error, cancelTitle: "Ok", viewController: self)
            } else {
                self.goToNextPage()
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Swift.Error!) {
         // Perform any operations when the user disconnects from app here.
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
                SFGeneralManager.SFLoginSignupManager.performLogin(email: emailTyped, password: pswTyped, completion: { (error) in
                    if error != nil {
                        SFAlertMessage.alertCancel(title: SFConstants.Strings.Error.Login.authenticationTitle, message: error, cancelTitle: "Ok", viewController: self)
                    } else {
                        self.goToNextPage()
                    }
                })
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
        return hideBar
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

















