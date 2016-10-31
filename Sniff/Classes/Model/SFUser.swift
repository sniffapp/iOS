//
//  SFUser.swift
//  Sniff
//
//  Created by Andrea Ferrando on 13/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import RealmSwift

public class SFUser: Object {
    
    public dynamic var token: String = ""
    public dynamic var userId: String = ""
    public dynamic var email: String = ""
    public dynamic var password: String = ""
    
    public override static func primaryKey() -> String {
        return "userId"
    }
    
    public override static func indexedProperties() -> [String] {
        return ["displayName"]
    }
    
}
