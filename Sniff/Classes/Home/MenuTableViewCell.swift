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
    let placeholderImage = UIImage(named:"category_placeholder")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(title: String, imageName:String) {
        lbTitle.text = title
        if let image = UIImage(named:imageName) {
            imv.image = image
        } else {
            imv.image = placeholderImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imv.image = nil
        lbTitle.text = nil
    }
    
}
