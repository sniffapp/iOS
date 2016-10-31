//
//  ExtensionUIButton.swift
//  Sniff
//
//  Created by Andrea Ferrando on 12/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//
import UIKit

class BigButton : UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds : CGRect = self.bounds
        let widthDelta : CGFloat = 70 - bounds.size.width
        let heightDelta : CGFloat = 70 - bounds.size.height
        // Enlarge the effective bounds to be 60 x 60 pt (smaller is 44 x 44 pt)
        bounds = bounds.insetBy(dx: -0.5 * widthDelta, dy:  -0.5 * heightDelta)
        return bounds.contains(point);
    }
}
