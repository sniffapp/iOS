//
//  SFNetworkManager.swift
//  Sniff
//
//  Created by Andrea Ferrando on 26/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import Alamofire

class SFNetworkManager {
    
    static let baseAPI = "http://sniff.us-west-2.elasticbeanstalk.com/api/"
    
    class Login: NSObject {
        /**
         * POST request to 'login/' -> Login user
         * - Parameters:
         *   - email: user email
         *   - password: user password
         *   - fb_token: if logging in via Facebook
         *   - google_token: if logging in via Google
         *   - linkedin_token: if logging in via Linkedin
         *   - completion: error(if exists) and value(response object: -> SFUser)
         */
        class func post(email: String, password: String?, fb_token: String? = nil, google_token: String? = nil, linkedin_token: String? = nil, completion: @escaping(_ error:String?, _ user:SFUser?) ->()) {
            let parameters: [String:String]!
            if let password = password {
                parameters = ["email":email,"password":password]
            } else if let fb_token = fb_token {
                parameters = ["email":email,"fb_token":fb_token]
            } else if let google_token = google_token {
                parameters = ["email":email,"google_token":google_token]
            } else if let linkedin_token = linkedin_token {
                parameters = ["email":email,"linkedin_token":linkedin_token]
            } else {
                completion(SFConstants.Strings.Error.Login.authenticationMessage, nil)
                return
            }
            let headers = ["Content-Type":"application/json"]
            let url = URL(string:SFNetworkManager.baseAPI+"login/")!
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                if response.response != nil && response.response!.statusCode == 200 {
                    if let value = response.result.value {
                        if let user = SFParseNetworkResponse.Login.parsePostLogin(value: value) {
                            SFRealmManager.saveRealmObjectAndUpdate(object: user)
                            SFUserDefaults.setActiveUserToken(user.token)
                            completion(response.result.error as? String, user)
                        }
                        completion(response.result.error as? String, nil)
                    }
                    completion(SFConstants.Strings.Error.Login.authenticationMessage, nil)
                } else {
                    completion(SFConstants.Strings.Error.Login.authenticationMessage, nil)
                }
                
            }
        }
    }
    
    class SignUp: NSObject {
        /**
         * POST request to 'users/' -> Create a new User
         * - Parameters:
         *   - email: user email
         *   - password: user password
         *   - fb_token: if logging in via Facebook
         *   - google_token: if logging in via Google
         *   - linkedin_token: if logging in via Linkedin
         *   - completion: error(if exists) and value(response object: -> SFUser)
         */
        class func post(email: String, password: String?, fb_token: String? = nil, google_token: String? = nil, linkedin_token: String? = nil, completion: @escaping(_ error:String?, _ user:SFUser?) ->()) {
            let parameters: Parameters!
            if let password = password {
                parameters = ["email":email,"password":password]
            } else if let fb_token = fb_token {
                parameters = ["email":email,"fb_token":fb_token]
            } else if let google_token = google_token {
                parameters = ["email":email,"google_token":google_token]
            } else if let linkedin_token = linkedin_token {
                parameters = ["email":email,"linkedin_token":linkedin_token]
            } else {
                completion(SFConstants.Strings.Error.Login.authenticationMessage, nil)
                return
            }
            
            let url = URL(string:SFNetworkManager.baseAPI+"users/")!
            let headers: HTTPHeaders = ["Content-Type":"application/json"]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                if response.response != nil && response.response!.statusCode == 200 {
                    if let value = response.result.value {
                        if let user = SFParseNetworkResponse.SignUp.parsePostNewUser(value: value) {
                            SFRealmManager.saveRealmObjectAndUpdate(object: user)
                            SFUserDefaults.setActiveUserToken(user.token)
                            completion(response.result.error as? String, user)
                        }
                        completion(response.result.error as? String, nil)
                    }
                    completion(SFConstants.Strings.Error.SignUp.genericMessage, nil)
                } else {
                    if let errorString = response.result.error?.localizedDescription {
                        completion(errorString, nil)
                    } else {
                        //                        let jsonSwifty = JSON(response.result.value)
                        if let value = response.result.value as? NSDictionary {
                            if let emailArray = value["email"] as? NSArray {
                                if let emailError = emailArray.firstObject as? String {
                                    if emailError == "user with this Email already exists." {
                                        completion(emailError, nil)
                                    }
                                }
                            }
                        }
                        completion(SFConstants.Strings.Error.SignUp.genericMessage, nil)
                    }
                }
            }
        }
    }
    
    
}










