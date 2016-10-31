//
//  DataViewController.swift
//  Sniff
//
//  Created by Andrea Ferrando on 12/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var lbTutorial: UILabel!
    var stTutorial: String? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let stTutorial = stTutorial else {
            return
        }
        lbTutorial.text = stTutorial
    }


}

