//
//  SFAnalytics.swift
//  Sniff
//
//  Created by Andrea Ferrando on 12/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import Google
import Fabric
import Crashlytics

class SFAnalytics {
    
    class func addScreenTracking(screenName: String) {
        #if RELEASE
            googleAddScreenTracking(screenName: screenName)
            fabricAddScreenTracking(screenName: screenName)
        #endif
    }

    private class func googleAddScreenTracking(screenName: String) {
//        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
//            kFIRParameterContentType:screenName as NSObject
//            ])

        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: screenName)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    private class func fabricAddScreenTracking(screenName: String) {
//        Answers.logCustomEventWithName(screenName, customAttributes:[])
        Answers.logContentView(withName: screenName, contentType: "",contentId: "",customAttributes: nil)
    }
    
    class func signInTracking(userID: String) {
        #if RELEASE
            googleSignInWithUser(userID: userID)
            fabricSignInWithUser(userID: userID)
        #endif
    }
    
    private func googleSignInWithUser(userID: String) {
//        FIRAnalytics.logEvent(withName: "User sign in", parameters: [
//            "userID": userID as NSObject,
//            "Date": Date().formatDateAndTime() as NSObject ])
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIUserId, value: userID)
//         [NSObject : AnyObject])
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: "UX", action: "User sign in", label: Date().formatDateAndTime(), value: nil).build() as [NSObject : AnyObject])
    }
    
    private func fabricSignInWithUser(userID: String){
        Answers.logSignUp(withMethod:userID,success: true,customAttributes: nil)
    }
}
