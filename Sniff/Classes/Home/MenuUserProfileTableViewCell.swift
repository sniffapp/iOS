//
//  HomeMenuUserProfileTableViewCell.swift
//  Sniff
//
//  Created by Andrea Ferrando on 31/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class HomeMenuUserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    let placeholderImage = UIImage(named:"category_placeholder")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(name: String, email: String, imageURL:String?) {
        lbName.text = name
        lbEmail.text = email
////        let size = imv.frame.size
//        if let imageURL = imageURL {
//            imv.af_setImage(
//                withURL: URL(string:imageURL)!,
//                placeholderImage: placeholderImage,
//                filter: nil,
//                imageTransition: .crossDissolve(0.2)
//            )
//        } else {
//            imv.image = placeholderImage
//        }
        imv.image = placeholderImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imv.af_cancelImageRequest()
        imv.layer.removeAllAnimations()
        imv.image = nil
        lbName.text = nil
        lbEmail.text = nil
    }

    
}
