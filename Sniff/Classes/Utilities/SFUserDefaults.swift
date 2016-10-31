//
//  SFUserDefaults.swift
//  Sniff
//
//  Created by Andrea Ferrando on 18/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

class SFUserDefaults: NSObject {
    
    static let activeUserToken = "activeUserToken"
    static let appReviewed = "appReviewed"
    static let appReviewedReminder = "appReviewedReminder"
    
    class func getActiveUserToken() -> String? {
        return UserDefaults.standard.string(forKey: activeUserToken)
    }
    
    class func setActiveUserToken(_ currentToken: String?) {
        UserDefaults.standard.set(currentToken, forKey: activeUserToken)
        UserDefaults.standard.synchronize()
    }
    
    class func reviewTheAppDidShow() -> Bool {
        return UserDefaults.standard.bool(forKey: appReviewed)
    }
    
    class func setReviewTheAppDidShow(_ reviewTheAppDidShow: Bool) {
        UserDefaults.standard.set(reviewTheAppDidShow, forKey: appReviewed)
        UserDefaults.standard.synchronize()
    }
    
    class func reviewTheAppReminderDidShow() -> Bool {
        return UserDefaults.standard.bool(forKey: appReviewedReminder)
    }
    
    class func setReviewTheAppReminderDidShow(_ reviewTheAppReminderDidShow: Bool) {
        UserDefaults.standard.set(reviewTheAppReminderDidShow, forKey: appReviewedReminder)
        UserDefaults.standard.synchronize()
    }
    
    
}
