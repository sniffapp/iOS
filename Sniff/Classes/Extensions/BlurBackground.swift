//
//  blurBackground.swift
//  Sniff
//
//  Created by Andrea Ferrando on 01/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class BlurBackground: UIImageView {
    
    func blurImage() {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            var blurEffect: UIBlurEffect!
            if #available(iOS 10.0, *) {
                blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            } else {
                blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            }
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        }
//        guard let image = image else { return }
//        self.image = image.af_imageFiltered(
//            withCoreImageFilter: "CIGuassianBlur",
//            parameters: ["inputRadius": 50]
//        )
    }

    
}
