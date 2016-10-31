//
//  RoundMask.swift
//  Sniff
//
//  Created by Andrea Ferrando on 12/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func roundMask(width: CGFloat, height: CGFloat) -> CAShapeLayer {
        let circle : CAShapeLayer = CAShapeLayer()
        let circularPath : UIBezierPath = UIBezierPath(roundedRect: CGRect(x:0, y:0, width:width, height:height).integral, cornerRadius: max(width,height))
        circle.path = circularPath.cgPath
        circle.fillColor = UIColor.black.cgColor
        circle.strokeColor = UIColor.black.cgColor
        circle.lineWidth = 0
        return circle
    }
    
    
}
    
