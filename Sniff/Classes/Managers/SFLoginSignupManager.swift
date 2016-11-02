//
//  SFGeneralManager.swift
//  Sniff
//
//  Created by Andrea Ferrando on 31/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Google
import SwiftyJSON

class SFGeneralManager {
    
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
                        if let result = result as? NSDictionary {
                            if let emailAddress = result["email"] as? String {
                                if let fb_userId = result["id"] as? String {
                                    if isLogin == true {
                                        performLogin(email: emailAddress, fb_userId:fb_userId, fb_token: token, google_userId:nil, google_token: nil, linkedin_token: nil, password: nil, completion: { (error) in
                                            completion(error)
                                        })
                                    } else {
                                        performSignUp(email: emailAddress, fb_userId: fb_userId, google_userId: nil, linkedin_token: nil, password: nil, completion: { (error) in
                                            completion(error)
                                        })
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }

        //MARK: - Linkedin
        class func onLinkedinBtnClicked(isLogin login:Bool, completion:@escaping (_ error:String?)->()) {
            LISDKSessionManager.createSession(withAuth: [LISDK_EMAILADDRESS_PERMISSION as AnyObject], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
                guard let session = LISDKSessionManager.sharedInstance().session else { return }
                SFHud.showLoading()
                let token = session.accessToken.accessTokenValue
                
                let url = NSString(string:"https://api.linkedin.com/v1/people/~:(id,industry,firstName,lastName,emailAddress,headline,summary,publicProfileUrl,specialties,positions:(id,title,summary,start-date,end-date,is-current,company:(id,name,type,size,industry,ticker)),pictureUrls::(original),location:(name))?format=json")
                if LISDKSessionManager.hasValidSession() {
                    LISDKAPIHelper.sharedInstance().getRequest(url as String, success: {
                        response in
                        DispatchQueue.main.async {
                            if let dataFromString = response?.data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                                let result = JSON(data: dataFromString)
                                LISDKSessionManager.clearSession()
                                let email = result["emailAddress"].description
                                if login == true {
                                    performLogin(email: email, fb_userId:nil, fb_token: nil, google_userId:nil, google_token: nil, linkedin_token: token, password: nil, completion: { (error) in
                                        completion(error)
                                    })
                                } else {
                                    performSignUp(email: nil, fb_userId:nil, google_userId: nil, linkedin_token: token, password: nil, completion: { (error) in
                                        completion(error)
                                    })
                                }
                            }
                        }
                    }, error: {
                        error in
                        
                        LISDKAPIHelper.sharedInstance().cancelCalls()
                        LISDKSessionManager.clearSession()
                        completion(error?.localizedDescription)
                        //Do something with the error
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
                performLogin(email: email, fb_userId:nil, fb_token: nil, google_userId:user.userID, google_token: token, linkedin_token: nil, password: nil, completion: { (error) in
                    completion(error)
                })
            } else {
                performSignUp(email: email, fb_userId:nil, google_userId: user.userID, linkedin_token: nil, password: nil, completion: { (error) in
                    completion(error)
                })
            }
            
        }
        
        //MARK: - Perform Login
        class func performLogin(email:String?, fb_userId: String? = nil, fb_token: String? = nil, google_userId: String? = nil, google_token: String? = nil, linkedin_token: String? = nil, password: String?, completion:@escaping (_ error:String?)->()) {
            if email != nil && (password != nil || (fb_userId != nil && fb_token != nil) || (google_userId != nil && google_token != nil) || linkedin_token != nil) {
                SFNetworkManager.Login.post(email: email!, password: password, fb_userId: fb_userId, fb_token: fb_token, google_userId: google_userId, google_token: google_token, linkedin_token: linkedin_token, completion: { (error, user) in
                    SFHud.dismissLoading()
                    guard error == nil else {
                        completion(error)
                        return
                    }
                    if let loggedUser = user {
                        SFRealmManager.saveRealmObjectAndUpdate(object: loggedUser)
                        SFUserDefaults.setActiveUserToken(loggedUser.token)
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
        class func performSignUp(email:String?, fb_userId: String? = nil, google_userId: String? = nil, linkedin_token: String? = nil, password: String?, completion:@escaping (_ error:String?)->()) {
            if email != nil && (password != nil || fb_userId != nil || google_userId != nil || linkedin_token != nil) {
                SFNetworkManager.SignUp.post(email: email!, password: password, fb_userId: fb_userId, google_userId: google_userId, linkedin_token: linkedin_token, completion: { (error, user) in
                    SFHud.dismissLoading()
                    guard error == nil else {
                        completion(error)
                        return
                    }
                    if let newUser = user {
                        SFRealmManager.saveRealmObjectAndUpdate(object: newUser)
                        SFUserDefaults.setActiveUserToken(newUser.token)
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
    
}
