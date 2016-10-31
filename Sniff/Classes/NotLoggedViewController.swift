//
//  NotLoggedViewController.swift
//  Sniff
//
//  Created by Andrea Ferrando on 31/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

class NotLoggedViewController: UIViewController {
    
    enum notLoggedVCEnum: String {
        case menu
    }
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var type: notLoggedVCEnum!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        if type == .menu {
            titleLabel.text = "Join for buying items and create your shopping list"
            imv.image = UIImage(named:"banner_messages")
        }
    }
    
    @IBAction func onBackBtnClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueVC = segue.destination as? SignUpViewController {
            segueVC.hideBar = false
        }
        if let segueVC = segue.destination as? LoginViewController {
            segueVC.hideBar = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
