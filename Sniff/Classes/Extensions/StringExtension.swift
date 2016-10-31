//
//  StringExtension.swift
//  Sniff
//
//  Created by Andrea Ferrando on 29/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

extension String {

    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "YES","1":
            return true
        case "False", "false", "no", "NO", "0":
            return false
        default:
            return false
        }
    }
    
    func toDate(format : String) -> NSDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if dateFormatter.date(from: self) != nil {
            return dateFormatter.date(from: self) as NSDate?
        } else if format == "yyyy-mm-dd hh:mm"{
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            return dateFormatter.date(from: self) as NSDate?
        }
        return nil
    }
    
    var isEmailValid: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    func isPasswordValid() -> Bool {
        return self.characters.count > 6
    }
    
    
    func toURL() -> NSURL {
        return NSURL(string:self)!
    }
    
    
    func toNumber() -> NSNumber {
        return NSNumber(value:Int(self)!)
    }
    
    
    static func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
}

