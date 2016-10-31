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
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var topBarView: UIView!
    
    var numberOfCollectionsRow: Int = 2
    var numberOfCatgeories: Int = 1
    
    var searchActive : Bool = false
    var filtered:[String] = []
    var searchHasResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuSlide()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SFConstants.Values.statusBarHidden = false
        SFAnalytics.addScreenTracking(screenName:"Home")
        setSearchTableView(hidden: true)
    }
    
    @IBAction func onBtnSettingsClicked(_ sender: AnyObject) {
        if SFRealmManager.userIsLoggedIn() == false {
            presentViewController(storyboardName: "Main", storyboardID: "", prepare: nil)
        } else {
            present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    //        self.setNeedsStatusBarAppearanceUpdate()
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    @IBAction func onBtnWishListClicked(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBtnSearchClicked(_ sender: AnyObject) {
        setSearchTableView(hidden: false)
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
        if tableView == searchTableView {
            if filtered.count > 0 {
                return filtered.count
            }
            return 1
        }
        if section == 0 {
            return numberOfCollectionsRow
        }
        return numberOfCatgeories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            if searchActive == true && searchBar.text != nil && searchBar.text! != "" {
                if filtered.count == 0 {
                    tableView.isScrollEnabled = false
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "noResultsCell") else { return UITableViewCell() }
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchItemTableViewCell") as? SearchItemTableViewCell else {
                        return UITableViewCell()
                    }
                    if filtered.count > indexPath.row {
                        cell.setup(title: filtered[indexPath.row], subTitle: filtered[indexPath.row])
                    }
                    cell.setNeedsUpdateConstraints()
                    return cell
                }
            } else if searchActive == true && searchBar.text != nil && searchBar.text! == "" {
                tableView.isScrollEnabled = false
                guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "noResultsCell") else { return UITableViewCell() }
                return cell
            }
        }
        
        
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
        if tableView == searchTableView {
            return 50
        }
        if indexPath.section == 0 {
            return 200
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == searchTableView {
            return 0
        }
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
        searchTableView.frame.origin = CGPoint(x: 0, y: view.frame.height)
        searchTableView.isHidden = true
        searchBar.showsCancelButton = true
    }
    
    func setSearchTableView(hidden: Bool) {
        if hidden == true {
            searchTableView.isHidden = true
            searchBar.isHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                if SFReachability.isReachable() == false {
                    let noConnectionPad = SFConstants.Values.heightNoConnectionView/2
                    self.searchTableView.frame = CGRect(x: 0, y: self.view.frame.height - noConnectionPad, width: self.view.frame.width, height: self.view.frame.height + noConnectionPad)
                } else {
                    self.searchTableView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
                }
            })
        } else {
            searchTableView.isHidden = false
            searchBar.isHidden = false
            searchBarTextDidBeginEditing(searchBar)
            UIView.animate(withDuration: 0.3, animations: {
                if SFReachability.isReachable() == false {
                    let noConnectionPad = SFConstants.Values.heightNoConnectionView/2
                    self.searchTableView.frame = CGRect(x: 0, y: self.topBarView.frame.height - noConnectionPad, width: self.view.frame.width, height: self.view.frame.height - self.topBarView.frame.height + noConnectionPad)
                } else {
                    self.searchTableView.frame = CGRect(x: CGFloat(0), y: self.topBarView.frame.height, width: self.view.frame.width, height: self.view.frame.height - self.topBarView.frame.height)
                }
            })
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setSearchTableView(hidden:false)
        searchHasResults = true
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchHasResults = false
        if searchBar.text == "" {
            setSearchTableView(hidden:true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchHasResults = false
        searchActive = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        setSearchTableView(hidden:true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var listOfItemNames: [String] = []
        listOfItemNames = ["iPhone charger","Bed","Lamp"]
        filtered = listOfItemNames.filter({ (displayName) -> Bool in
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





































