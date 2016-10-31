//
//  HomeMenuViewController.swift
//  Sniff
//
//  Created by Andrea Ferrando on 27/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import UIKit
import MessageUI


class HomeMenuTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SFAnalytics.addScreenTracking(screenName:"Menu")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeMenuUserProfileTableViewCell", for: indexPath) as? HomeMenuUserProfileTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            cell.setup(name: "Andrea Ferrando", email: "andrea@me.com", imageURL:nil)
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeMenuTableViewCell", for: indexPath) as? HomeMenuTableViewCell else { return UITableViewCell() }
            switch indexPath.row {
            case 0:
                cell.setup(title: "My purchases", imageName: "")
            case 1:
                cell.setup(title: "Account", imageName: "")
            case 2:
                cell.setup(title: "Gift card", imageName: "")
            default:
                break
            }
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "homeMenuLogoutTableViewCell", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

