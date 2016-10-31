
//
//  CollectionCollectionViewCell.swift
//  Sniff
//
//  Created by Andrea Ferrando on 31/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

class HomeCollectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var btn: UIButton!
    
    let placeholderImage = UIImage(named:"category_placeholder")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(title: String, imageURL:String?) {
        lbTitle.text = title
////        let size = backgroundImageView.frame.size
//        if let imageURL = imageURL {
//            backgroundImageView.af_setImage(
//                withURL: URL(string:imageURL)!,
//                placeholderImage: placeholderImage,
//                filter: nil,
//                imageTransition: .crossDissolve(0.2)
//            )
//        } else {
//            backgroundImageView.image = placeholderImage
//        }
        backgroundImageView.image = placeholderImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.af_cancelImageRequest()
        backgroundImageView.layer.removeAllAnimations()
        backgroundImageView.image = nil
        lbTitle.text = nil
    }
    
}
