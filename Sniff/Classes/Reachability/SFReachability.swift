//
//  SFReachability.swift
//  Sniff
//
//  Created by Andrea Ferrando on 17/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

class SFReachability {
    
    private static var reachable = true
    
    public class func setReachability() {
         NotificationCenter.default.addObserver(self, selector:#selector(SFReachability.reachabilityChanged(notification:)), name: NSNotification.Name(rawValue: SFConstants.Strings.Notifications.reachabilityChanged), object: nil)
        
        let internetReachability : ReachabilityLineUp = ReachabilityLineUp.reachabilityForInternetConnection()
        internetReachability.startNotifier()
        updateInterfaceWithReachability(reachability: internetReachability)
        
        let wifiReachability : ReachabilityLineUp = ReachabilityLineUp.reachabilityForLocalWiFi()
        wifiReachability.startNotifier()
        updateInterfaceWithReachability(reachability: wifiReachability)
    }
    
    @objc public class func reachabilityChanged(notification : NSNotification) {
        if notification.object != nil && (notification.object! as AnyObject) is ReachabilityLineUp {
            let currentReachability : ReachabilityLineUp = notification.object as! ReachabilityLineUp
            updateInterfaceWithReachability(reachability: currentReachability)
        }
    }
    
     public class func updateInterfaceWithReachability(reachability : ReachabilityLineUp) {
        guard let appDelegate = UIApplication.shared.delegate, let mainWindow = (appDelegate as? AppDelegate)?.window else {
            return
        }
        if reachability.isReachable() == true {
            reachable = true
            for subview in mainWindow.subviews {
                if subview is NoConnectionView {
                    subview.removeFromSuperview()
                    return
                }
            }
        } else {
            reachable = false
            let viewNoConnection = NoConnectionView(frame:CGRect(x: 0, y: 0, width: Int(mainWindow.frame.width), height: Int(SFConstants.Values.heightNoConnectionView)))
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                viewNoConnection.label.alpha = 0
                }, completion: { (Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        viewNoConnection.label.alpha = 1
                        viewNoConnection.label.text = SFConstants.Strings.Notifications.reachabilityNoConnectionText1
                    })
            })
            mainWindow.addSubview(viewNoConnection)
        }
    }
    
    public class func isReachable() -> Bool {
        return reachable
    }
}
