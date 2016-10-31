//
//  AppDelegate.swift
//  Sniff
//
//  Created by Andrea Ferrando on 12/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import FBSDKCoreKit
import UserNotifications
import RealmSwift
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var localNotificationReviewApp: UILocalNotification?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setAnalytics()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        setInitialPage()
        
        SFReachability.setReachability()
        
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
       
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Set Initial Page
    func setInitialPage() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var targetVC: UIViewController!

        SFRealmManager.userIsLoggedIn() == true ? (targetVC = sb.instantiateViewController(withIdentifier: "HomeViewController")) : (targetVC = sb.instantiateViewController(withIdentifier: "RootViewController"))
//        SFRealmManager.userIsLoggedIn() == true ? (targetVC = sb.instantiateViewController(withIdentifier: "SignUpViewController")) : (targetVC = sb.instantiateViewController(withIdentifier: "RootViewController"))
        
        let navC : UINavigationController = UINavigationController(rootViewController: targetVC)
        navC.isNavigationBarHidden = true
        
        window.rootViewController = navC
        window.makeKeyAndVisible()
        self.window = window
    }
    
    //MARK: - Application callback
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var GOOGLE_SCHEME = "com.googleusercontent.apps.506586701904-5ndfiutu8ro05lkuvm0pqiv0feuv40iv"
        var FACEBOOK_SCHEME = "fb676580649156001"
        var LINKEDIN_SCHEME = "li4578373"
        #if RELEASE
            GOOGLE_SCHEME = "com.googleusercontent.apps.672735175799-07jpi7dr11iq8ehlh7ps8i3131c4dtnm"
            FACEBOOK_SCHEME = "fb284344261951594"
            LINKEDIN_SCHEME = "li4578373"
        #endif
        
        if url.scheme == GOOGLE_SCHEME {
            return GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
        }
        if url.scheme == FACEBOOK_SCHEME {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        if url.scheme == LINKEDIN_SCHEME {
            if LISDKCallbackHandler.shouldHandle(url) == true {
                return LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            }
        }
        return false
    }
    
    //MARK: - Analytics
    func setAnalytics() {
        var filePath: String!
        #if RELEASE
            Fabric.with([Crashlytics.self, Answers.self])
            filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        #else
            filePath = Bundle.main.path(forResource: "GoogleService-Info-beta", ofType: "plist")!
        #endif
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
    }

    private func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication.rawValue] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation.rawValue])
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        _: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey.rawValue: sourceApplication as AnyObject,
//                                            UIApplicationOpenURLOptionsAnnotationKey.rawValue: annotation!]
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
}




//MARK: - Notifications
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
        
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        //Handle data of notification
        //        //Print message ID.
        //        print("Message ID: \(userInfo["gcm.message_id"]!)")
        //
        //        // Print full message.
        //        print("%@", userInfo)
    }
    
    @objc(application:handleActionWithIdentifier:forLocalNotification:completionHandler:) func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
    }
    
    @objc(application:didReceiveLocalNotification:) func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if notification.userInfo != nil {
            if notification.userInfo!.keys.contains("reviewTheApp") {
                if SFUserDefaults.reviewTheAppDidShow() == false || SFUserDefaults.reviewTheAppReminderDidShow() == false {
                    fireReviewNotification()
                }
            } else if notification.userInfo!.keys.contains("appNotUsed") {
                fireAppNotUsedNotification()
            }
        }
    }
    
    func setLocalNotifications() {
        if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0 {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types:[.alert, .badge, .sound], categories: nil))
        }
        setNotificationReviewApp()
        sendNotificationAppNotUsed()
    }
    
    //MARK: Notif Review the app
    
    func setNotificationReviewApp() {
        if SFUserDefaults.reviewTheAppDidShow() == false {
            SFUserDefaults.setReviewTheAppDidShow(true)
            localNotificationReviewApp = UILocalNotification()
            let nowPlus = Date().addingTimeInterval(60*60*24)
            sendNotificationReviewApp(nowPlus)
        }
    }
    
    func sendNotificationReviewApp(_ nowPlus: Date) {
        guard let localNotificationReviewApp = localNotificationReviewApp else {
            return
        }
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = Date()
        var dateComponentsFire = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.weekOfMonth, NSCalendar.Unit.month,NSCalendar.Unit.year,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second], from:date)
        let dateComponentsNowPlus = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.weekOfMonth, NSCalendar.Unit.month,NSCalendar.Unit.year,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second], from:nowPlus)
        dateComponentsFire.year = dateComponentsNowPlus.year
        dateComponentsFire.month = dateComponentsNowPlus.month
        dateComponentsFire.day = dateComponentsNowPlus.day
        dateComponentsFire.hour = dateComponentsNowPlus.hour
        dateComponentsFire.minute = dateComponentsNowPlus.minute
        dateComponentsFire.second = dateComponentsNowPlus.second
        
        localNotificationReviewApp.timeZone = TimeZone.current
        localNotificationReviewApp.fireDate = calendar.date(from: dateComponentsFire)
        localNotificationReviewApp.alertBody = SFConstants.Strings.Notifications.local_reviewAppAlertBody
        localNotificationReviewApp.alertAction = SFConstants.Strings.appName
        localNotificationReviewApp.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        localNotificationReviewApp.userInfo = ["reviewTheApp":"reviewTheApp"]
        UIApplication.shared.scheduleLocalNotification(localNotificationReviewApp)
    }
    
    func setSendNotificationReviewAppReminder(_ nowPlus: Date) {
        if SFUserDefaults.reviewTheAppReminderDidShow() == false {
            let arrayOfLocalNotifications = UIApplication.shared.scheduledLocalNotifications
            guard arrayOfLocalNotifications != nil else {
                return
            }
            for notification in arrayOfLocalNotifications! {
                if notification.alertBody == SFConstants.Strings.Notifications.local_reviewAppAlertBody {
                    UIApplication.shared.cancelLocalNotification(notification)
                }
            }
            if localNotificationReviewApp != nil {
                let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                let date = Date()
                var dateComponentsFire = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.weekOfMonth, NSCalendar.Unit.month,NSCalendar.Unit.year,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second], from:date)
                let dateComponentsNowPlus = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.weekOfMonth, NSCalendar.Unit.month,NSCalendar.Unit.year,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second], from:nowPlus)
                dateComponentsFire.year = dateComponentsNowPlus.year
                dateComponentsFire.month = dateComponentsNowPlus.month
                dateComponentsFire.day = dateComponentsNowPlus.day
                dateComponentsFire.hour = dateComponentsNowPlus.hour
                dateComponentsFire.minute = dateComponentsNowPlus.minute
                dateComponentsFire.second = dateComponentsNowPlus.second
                localNotificationReviewApp!.fireDate = calendar.date(from: dateComponentsFire)
                UIApplication.shared.scheduleLocalNotification(localNotificationReviewApp!)
            }
        }
    }
    
    func fireReviewNotification() {
        let alert = UIAlertController(title: "Enjoying \(SFConstants.Strings.appName)?", message: "If you enjoy using \(SFConstants.Strings.appName), would you mind taking a moment to rate it?\nIt won't take more than a minute.\nThanks for your support!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Review", style: .default, handler: { (action) in
            UIApplication.shared.openURL(URL(string : "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(SFConstants.Strings.appId)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")!)
            SFUserDefaults.setReviewTheAppReminderDidShow(true)
        }) )
        alert.addAction(UIAlertAction(title: "Remind me later", style: .default, handler: { (action) in
            if SFUserDefaults.reviewTheAppReminderDidShow() == false {
                let nowPlus = Date().addingTimeInterval(60*60*24*2)
                self.setSendNotificationReviewAppReminder(nowPlus)
            } else {
                SFUserDefaults.setReviewTheAppReminderDidShow(true)
            }
        }) )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
        
        if let wd = self.window {
            var vc = wd.rootViewController
            if vc is UINavigationController {
                vc = (vc as! UINavigationController).visibleViewController
                vc?.present(alert, animated: true, completion: nil)
            } else if vc != nil {
                vc!.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    //MARK: Notif AppNotUsed
    func sendNotificationAppNotUsed() {
        let arrayOfLocalNotifications = UIApplication.shared.scheduledLocalNotifications
        guard arrayOfLocalNotifications != nil else {
            return
        }
        for notification in arrayOfLocalNotifications! {
            if ((notification.userInfo?.keys.contains("appNotUsed")) != nil) {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
        let nowPlus = Date().addingTimeInterval(60*60*24*6)
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = Date()
        var dateComponentsFire = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.weekOfMonth, NSCalendar.Unit.month,NSCalendar.Unit.year,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second], from:date)
        let dateComponentsNowPlus = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.weekOfMonth, NSCalendar.Unit.month,NSCalendar.Unit.year,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second], from:nowPlus)
        dateComponentsFire.year = dateComponentsNowPlus.year
        dateComponentsFire.month = dateComponentsNowPlus.month
        dateComponentsFire.day = dateComponentsNowPlus.day
        dateComponentsFire.hour = dateComponentsNowPlus.hour
        dateComponentsFire.minute = dateComponentsNowPlus.minute
        dateComponentsFire.second = dateComponentsNowPlus.second
        let localNotification = UILocalNotification()
        localNotification.fireDate = calendar.date(from: dateComponentsFire)
        localNotification.timeZone = TimeZone.current
        localNotification.alertAction = SFConstants.Strings.appName
        localNotification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        localNotification.userInfo = ["appNotUsed":"appNotUsed"]
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    func fireAppNotUsedNotification() {
        let alert = UIAlertController(title: SFConstants.Strings.appName, message: SFConstants.Strings.Notifications.local_appNotUsed, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        
        if let wd = self.window {
            var vc = wd.rootViewController
            if vc is UINavigationController {
                vc = (vc as! UINavigationController).visibleViewController
                vc?.present(alert, animated: true, completion: nil)
            } else if vc != nil {
                vc!.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
}


