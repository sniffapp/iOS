//
//  Utilities.swift
//  Sniff
//
//  Created by Andrea Ferrando on 15/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

class SFHud {
    
    class func showLoading() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.window != nil {
            let imv : UIImageView = UIImageView(image: UIImage.gifWithName(name: "hudAnimation"))
            let v : UIView = UIView()
            v.frame.size = CGSize(width:140,height:140)
            v.center = appDelegate.window!.center
            imv.frame = CGRect(x:0,y:0,width:v.frame.width,height:v.frame.height)
            v.layer.cornerRadius = 45
            imv.layer.cornerRadius = 45
            //REMOVE THIS LINE
            v.layer.cornerRadius = 45
            //
            v.tag = 111
            v.addSubview(imv)
            let overlayView : UIView = UIView(frame: appDelegate.window!.frame)
            overlayView.backgroundColor = UIColor.black
            overlayView.alpha = 0
            overlayView.tag = 112
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                overlayView.alpha = 0.3
            })
            var inside : Bool = false
            for v in appDelegate.window!.subviews {
                if v.tag == 12 || v.tag == 11{
                    inside = true
                }
            }
            if inside == false {
                appDelegate.window!.addSubview(overlayView)
                appDelegate.window!.bringSubview(toFront: overlayView)
                appDelegate.window!.addSubview(v)
                appDelegate.window!.bringSubview(toFront: v)
            }
        }
//        if #available(iOS 10.0, *) {
//            Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { (timer) in
//                dismissLoading()
//            })
//        } else {
//            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(SFHud.dismissLoading), userInfo: nil, repeats: false)
//        }
    }
    
    @objc class func dismissLoading() {
        GiFHUD.dismiss()
        if UIApplication.shared.delegate != nil && UIApplication.shared.delegate!.window != nil
            && UIApplication.shared.delegate!.window! != nil {
            for v in UIApplication.shared.delegate!.window!!.subviews {
                if v.tag == 111 || v.tag == 112 {
                    v.removeFromSuperview()
                }
            }
        }
    }
    
}

class SFConstants {

    class Strings {
        static let appName = "Sniff"
        static let appId = " "
        
        class Notifications {
            //keep this name if using reachibility.h
            static let reachabilityChanged = "kReachabilityChangedNotification"
            static let reachabilityNoConnectionText1 = "Sniff is offline"
            static let reachabilityNoConnectionText2 = "Please connect to a WIFI network or mobile internet."
            static let local_appNotUsed = "There's a world of people around you, sniff your match!"
            static let local_reviewAppAlertBody = "If you enjoy using \(appName), would you mind taking a moment to rate it?"
        }
        
        class Error {
            
            static let emailNotSentTitle = "Could Not Send Email"
            static let emailNotSentMessage = "Your device could not send e-mail. Please check e-mail configuration and try again"
            
            class Login {
                static let genericTitle = "Error"
                static let authenticationTitle = "Authentication Error"
                static let authenticationMessage = "Login attempt failed. Please try again"
                static let emailAlreadyExistsMessage = "Login attempt failed. You already have an account registered with this email address.\nTry to log in with another service."
                static let emailNotCorrectMessage = "Email address not valid"
                static let pswNotCorrectMessage = "Password must have at least 6 characters"
            }
            
            class SignUp {
                static let genericTitle = "Error"
                static let genericMessage = "Sign up failed. Please try again or select another way to register an account"
                static let mandatoryFieldsTitle = "Minimum number of fields"
                static let mandatoryFieldsMessage = "Insert a valid email, email confirmation and password"
                static let emailNotCorrectMessage = "Email address not valid"
                static let emailsDoNotMatchMessage = "Email confirmation and Email are different"
                static let pswNotCorrectMessage = "Password must have at least 6 characters"
            }
        }
    }
    
    class Values {
        static var statusBarHidden = true
        static let keyboardHeight: CGFloat = 270
        static let heightNoConnectionView: CGFloat = 20
        static let heightTabBar: CGFloat = 60
        static let homeTagCellHeight: CGFloat = 90
        static let userProfileCategoryCellHeightNotSelected: CGFloat = 100
    }
    
}


struct SFAlertMessage {
    
    static func alertCancel(title : String!, message : String!, cancelTitle : String?, viewController : UIViewController!) {
        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if cancelTitle != nil {
            let cancelAction : UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action) -> Void in  })
            alert.addAction(cancelAction)
        }
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

struct SFNotificationCentre {
    
    static func postNotification(name: String, object:Any? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    static func addObserverNotification(controller: Any, selector: Selector, name: String, object:Any?) {
        NotificationCenter.default.addObserver(controller, selector:selector, name: NSNotification.Name(rawValue: name), object: object);
    }
    
    static func removeObserver(observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
}



