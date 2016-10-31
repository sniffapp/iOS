//
//  HomeMenuTableViewCell.swift
//  Sniff
//
//  Created by Andrea Ferrando on 27/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

class HomeMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    func set(title: String, imageName:String) {
        imv.image = UIImage(named: imageName)
        lbTitle.text = title
    }
    
}
