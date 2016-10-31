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
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? HomeMenuTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

