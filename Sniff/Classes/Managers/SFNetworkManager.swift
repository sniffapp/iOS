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

    static let baseAPI = "http://127.0.0.1:8000/api/"
    
    class Login: NSObject {
        /**
         * POST request to 'login/' -> Login user
         * - Parameters:
         *   - email: user email
         *   - password: user password
         *   - fb_token: if logging in via Facebook
         *   - google_token: if logging in via Google
         *   - linkedin_token: if logging in via Linkedin
         *   - completion: succeed, error and value(response object: -> SFUser)
         */
        class func post(email: String, password: String?, fb_token: String? = nil, google_token: String? = nil, linkedin_token: String? = nil, completion: @escaping(_ error:String?, _ value:AnyObject?) ->()) {
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
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                if let value = response.result.value {
                    if let value = SFParseNetworkResponse.Login.parsePostLogin(value: value) {
                        completion(response.result.error as? String, value)
                    }
                    completion(response.result.error as? String, nil)
                }
                completion(SFConstants.Strings.Error.Login.authenticationMessage, nil)
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
         *   - completion: succeed, error and value(response object: -> SFUser)
         */
        class func post(email: String, password: String?, fb_token: String? = nil, google_token: String? = nil, linkedin_token: String? = nil, completion: @escaping(_ error:String?, _ value:AnyObject?) ->()) {
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
            let url = URL(string:SFNetworkManager.baseAPI+"users/")!
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                if let value = response.result.value {
                    if let value = SFParseNetworkResponse.SignUp.parsePostNewUser(value: value) {
                        completion(response.result.error as? String, value)
                    }
                    completion(response.result.error as? String, nil)
                }
                completion(SFConstants.Strings.Error.Login.authenticationMessage, nil)
            }
            
        }
    }
    


}










