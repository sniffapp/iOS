//
//  UIViewControllerExtension.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func pushStaticViewController(storyboardName: String, storyboardID:String, prepare:((UIViewController) -> Void)? ) {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let targetVC = sb.instantiateViewController(withIdentifier: storyboardID)
        prepare?(targetVC)
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    func presentViewController(storyboardName: String, storyboardID:String, prepare:((UIViewController) -> Void)? ) {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let targetVC = sb.instantiateViewController(withIdentifier: storyboardID)
        prepare?(targetVC)
        presentViewController(storyboardName: storyboardName, storyboardID: storyboardID, prepare: nil)
    }

    func getViewFromXib<T>(nibName: String, viewPosition:Int) -> T? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[viewPosition] as? T
    }
}
