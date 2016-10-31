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
    
    class Login {
        
        class func parsePostLogin(value: Any) -> SFUser? {
            if let JSON = value as? NSDictionary {
//                if JSON["bookingDate"] != nil {
//                    if JSON is [String:AnyObject] {
//                        let itinerary = MBWKManagerParseJson.parseItinerary(JSON as! [String : AnyObject])
//                        try! mbwkRealm.write() {
//                            mbwkRealm.add(itinerary, update:true)
//                        }
//                        return itinerary
//                    }
//                }
            }
            return nil
        }
    }
    
    class SignUp {
        
        class func parsePostNewUser(value: Any) -> SFUser? {
            if let JSON = value as? NSDictionary {
//                if JSON["bookingDate"] != nil {
//                    if JSON is [String:AnyObject] {
//                        let itinerary = MBWKManagerParseJson.parseItinerary(JSON as! [String : AnyObject])
//                        try! mbwkRealm.write() {
//                            mbwkRealm.add(itinerary, update:true)
//                        }
//                        return itinerary
//                    }
//                }
            }
            return nil
        }


        
    }
    
}
