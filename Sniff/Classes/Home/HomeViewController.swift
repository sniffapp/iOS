//
//  HomeViewController.swift
//  Sniff
//
//  Created by Andrea Ferrando on 26/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import SideMenu

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuSlide()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SFConstants.Values.statusBarHidden = false
        SFAnalytics.addScreenTracking(screenName:"Home")
    }
    
    
    @IBAction func onBtnSettingsClicked(_ sender: AnyObject) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func onBtnWishListClicked(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @IBAction func onBtnSearchClicked(_ sender: AnyObject) {
        
    }
    
    func setupMenuSlide() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = sb.instantiateViewController(withIdentifier: "HomeMenuTableViewController")
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuVC)
        menuLeftNavigationController.leftSide = true
        menuLeftNavigationController.setNavigationBarHidden(true, animated: false)
        
        
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
