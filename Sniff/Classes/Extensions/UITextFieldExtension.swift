//
//  UITextFieldExtension.swift
//  Sniff
//
//  Created by Andrea Ferrando on 27/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
