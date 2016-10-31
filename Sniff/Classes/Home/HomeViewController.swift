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
    
    @IBOutlet weak var searchBar: UISearchBar!
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

//MARK: - TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
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
            return 200
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 15
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }
        let hv = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 15))
        hv.backgroundColor = UIColor.clear
        return hv
    }
    
}

//MARK: - CollectionView inside TableViewCell
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
            cell.btn.addTarget(self, action: #selector(cellShopAddressClicked), for: .touchUpInside)
        } else {
            cell.setup(title: "Stack of paper (A4)", imageURL: nil)
            cell.btn.addTarget(self, action: #selector(cellShopNameClicked), for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionCollectionViewCell else { return }
        
    }
    
    func cellShopAddressClicked(_ sender: UIButton) {
        
    }

    func cellShopNameClicked(_ sender: UIButton) {
        
    }
    
}

//MARK: - SearchBar
extension HomeViewController: UISearchBarDelegate {
    
    func initSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.layer.cornerRadius = 10
        searchTableViewStartOrigin = searchTableView.frame.origin
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "noResultsCell")
        searchTableView.isHidden = true
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchHasResults = true
        searchActive = true
        searchTableView.isHidden = false
        if searchBar.text == "" {
            tapGesture.isEnabled = true
        }
        UIView.animate(withDuration: 0.2) {
            if SFReachability.isReachable() == false {
                let noConnectionPad = SFConstantValue.heightNoConnectionView/2
                self.searchTableView.frame = CGRect(x: 0, y: self.topView.frame.origin.y + self.topView.frame.height - self.bottomHeightPad - noConnectionPad, width: self.searchTableView.frame.width, height: self.searchTableView.frame.height + self.bottomHeightPad + noConnectionPad)
            } else {
                self.searchTableView.frame = CGRect(x: 0, y: self.topView.frame.origin.y + self.topView.frame.height, width: self.searchTableView.frame.width, height: self.searchTableView.frame.height + SFConstantValue.heightNoConnectionView)
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchHasResults = false
        tapGesture.isEnabled = false
        if searchBar.text == "" {
            dismissSearchTableView()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchHasResults = false
        searchActive = false
        tapGesture.isEnabled = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        dismissSearchTableView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        searchHasResults = false
        //        searchActive = false
        searchBar.resignFirstResponder()
        //        dismissSearchTableView()
    }
    
    func dismissSearchTableView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchTableView.frame.origin = CGPoint(x:0,y:self.view.frame.height)
        }) { (finished) in
            self.searchTableView.isHidden = true
            self.searchTableView.frame.origin = self.searchTableViewStartOrigin
        }
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchText == "" ? (tapGesture.isEnabled = true) : (tapGesture.isEnabled = false)
        var listOfTagsNames: [String] = []
        for tag in SFRealmManager.getTags() {
            listOfTagsNames.append(tag.displayName)
        }
        filtered = listOfTagsNames.filter({ (displayName) -> Bool in
            let tmp: NSString = displayName as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        searchActive = true
        if(searchText == ""){
            searchHasResults = false;
        } else {
            searchHasResults = true;
        }
        searchTableView.reloadData()
    }
    
}





































