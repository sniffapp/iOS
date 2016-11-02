//
//  SFParseNetworkResponse.swift
//  Sniff
//
//  Created by Andrea Ferrando on 26/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import Alamofire

class SFParseNetworkResponse {
    
    class SignUp {
        class func parsePostNewUser(value: Any) -> SFUser? {
            if let json = value as? NSDictionary {
                let user = SFUser()
//                if json["fb_token"] != nil && json["fb_token"]! is String && json["fb_token"]! as! String != "" {
//                    user.token = json["fb_token"] as! String
//                } else if json["google_token"] != nil && json["google_token"]! is String && json["google_token"]! as! String != "" {
//                    user.token = json["google_token"] as! String
//                } else if json["linkedin_token"] != nil && json["linkedin_token"]! is String && json["linkedin_token"]! as! String != "" {
//                    user.token = json["linkedin_token"] as! String
//                } else
                if json["token"] != nil && json["token"]! is String && json["token"]! as! String != "" {
                    user.token = json["token"] as! String
                }
                if let password = json["password"] as? String {
                    user.password = password
                }
                if let email = json["email"] as? String {
                    user.email = email
                }
                if let displayname = json["displayname"] as? String {
                    user.displayName = displayname
                }
                if let last_name = json["last_name"] as? String {
                    user.lastName = last_name
                }
                if let user_id = json["user_id"] as? Int {
                    user.userId = String(user_id)
                }
                if let created_at = json["created_at"] as? String {
                    user.createdAt = created_at
                    //                    if let date = created_at.toDate(format: "2016-11-01T15:25:40.129866Z") {
                }
                if !user.userId.isEmpty && !user.token.isEmpty && !user.email.isEmpty {
                    return user
                }
            }
            return nil
        }
        
    }
    
    class Login {
        class func parsePostLogin(value: Any) -> SFUser? {
            return SFParseNetworkResponse.SignUp.parsePostNewUser(value: value)
        }
    }
    
}
