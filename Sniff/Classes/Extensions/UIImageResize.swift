//
//  UIImageResize.swift
//  Sniff
//
//  Created by Andrea Ferrando on 28/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func resize(scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
