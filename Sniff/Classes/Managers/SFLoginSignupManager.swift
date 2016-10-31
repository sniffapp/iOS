//
//  SFLoginSignupManager.swift
//  Sniff
//
//  Created by Andrea Ferrando on 31/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Google

class SFLoginSignupManager {
    
    //MARK: - Facebook
    class func onBtnFacebookClicked(isLogin:Bool, viewController: UIViewController, completion:@escaping (_ error:String?)->()) {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["email"], from: viewController) { (result, error) in
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
                    if isLogin == true {
                        performLogin(email: email, fb_token: token, google_token: nil, linkedin_token: nil, password: nil, completion: { (error) in
                            completion(error)
                        })
                    } else {
                        performSignUp(email: email, fb_token: token, google_token: nil, linkedin_token: nil, password: nil, completion: { (error) in
                            completion(error)
                        })
                    }
                })
            }
        }
    }

    //MARK: - Linkedin
    class func onLinkedinBtnClicked(isLogin login:Bool, completion:@escaping (_ error:String?)->()) {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
            guard let session = LISDKSessionManager.sharedInstance().session else { return }
            SFHud.showLoading()
            let token = session.accessToken.accessTokenValue
            if login == true {
                performLogin(email: nil, fb_token: nil, google_token: nil, linkedin_token: token, password: nil, completion: { (error) in
                    completion(error)
                })
            } else {
                performSignUp(email: nil, fb_token: nil, google_token: nil, linkedin_token: token, password: nil, completion: { (error) in
                    completion(error)
                })
            }
            
        }) { (error) -> Void in }
    }
    
    //MARK: - Google
    class func sign(isLogin login:Bool, _ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Swift.Error!, completion:@escaping (_ error:String?)->()) {
        if error != nil { return }
        SFHud.showLoading()
        let token = user.authentication.idToken, email = user.profile.email
        if login == true {
            performLogin(email: email, fb_token: nil, google_token: token, linkedin_token: nil, password: nil, completion: { (error) in
                completion(error)
            })
        } else {
            performSignUp(email: email, fb_token: nil, google_token: token, linkedin_token: nil, password: nil, completion: { (error) in
                completion(error)
            })
        }
        
    }
    
    //MARK: - Perform Login
    class func performLogin(email:String?, fb_token: String? = nil, google_token: String? = nil, linkedin_token: String? = nil, password: String?, completion:@escaping (_ error:String?)->()) {
        if email != nil && (password != nil || fb_token != nil || google_token != nil || linkedin_token != nil) {
            SFNetworkManager.Login.post(email: email!, password: password, fb_token: fb_token, google_token: google_token, linkedin_token: linkedin_token, completion: { (error, value) in
                SFHud.dismissLoading()
                guard error == nil else {
                    completion(error)
                    return
                }
                if let dict = value as? [String: Any] {
                    SFRealmManager.loginUser(dict:dict)
                    completion(nil)
                } else {
                    completion(SFConstants.Strings.Error.Login.authenticationMessage)
                }
            })
        } else {
            SFHud.dismissLoading()
            completion(SFConstants.Strings.Error.Login.authenticationMessage)
            }
    }
    
    //MARK: - Perform SignUp
    class func performSignUp(email:String?, fb_token: String? = nil, google_token: String? = nil, linkedin_token: String? = nil, password: String?, completion:@escaping (_ error:String?)->()) {
        if email != nil && (password != nil || fb_token != nil || google_token != nil || linkedin_token != nil) {
            SFNetworkManager.SignUp.post(email: email!, password: password, fb_token: fb_token, google_token: google_token, linkedin_token: linkedin_token, completion: { (error, value) in
                SFHud.dismissLoading()
                guard error == nil else {
                    completion(error)
                    return
                }
                if let dict = value as? [String: Any] {
                    SFRealmManager.loginUser(dict:dict)
                    completion(nil)
                } else {
                    completion(SFConstants.Strings.Error.SignUp.genericMessage)
                }
            })
        } else {
            SFHud.dismissLoading()
            completion(SFConstants.Strings.Error.SignUp.mandatoryFieldsMessage)
        }
    }
    
}
