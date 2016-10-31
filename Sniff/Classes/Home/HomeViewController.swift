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
    
    @IBOutlet weak var btnLocationText: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var numberOfCollectionsRow: Int = 2
    var numberOfCatgeories: Int = 1
    
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
//        self.setNeedsStatusBarAppearanceUpdate()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func onBtnWishListClicked(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @IBAction func onBtnSearchClicked(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBtnLocationLabelClicked(_ sender: AnyObject) {
    
    }
    
    @IBAction func onBtnLocationImageClicked(_ sender: AnyObject) {
        
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


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return numberOfCollectionsRow
        }
        return numberOfCatgeories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCollectionTableViewCell") as? HomeCollectionTableViewCell else { return UITableViewCell() }
            if indexPath.row == 0 {
                cell.setup(title: "Shops", collectionViewTag:indexPath.row)
            } else {
                cell.setup(title: "Special Offers", collectionViewTag:indexPath.row)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCategoryTableViewCell") as? HomeCategoryTableViewCell else { return UITableViewCell() }
            cell.setup(title: "Gardening", imageURL: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let hv = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
            hv.backgroundColor = UIColor.white
            return hv
        } else {
            let hv = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
            hv.backgroundColor = UIColor.white
            return hv
        }
    }
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionCollectionViewCell", for: indexPath) as? HomeCollectionCollectionViewCell else { return UICollectionViewCell() }
        if collectionView.tag == 0 {
            cell.setup(title: "WHSmith", imageURL: nil)
        } else {
            cell.setup(title: "Stack of paper (A4)", imageURL: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionCollectionViewCell else { return }
        
    }

    
}




































