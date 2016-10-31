//
//  Dimmable.swift
//  Sniff
//
//  Created by Andrea Ferrando on 15/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import UIKit

enum Direction { case In, Out }

protocol Dimmable { }

extension Dimmable where Self: UIViewController {
    
    func dim(direction: Direction, color: UIColor = UIColor.black, alpha: CGFloat = 0.0, speed: Double = 0.0) {
        
        switch direction {
        case .In:
            
            // Create and add a dim view
            let dimView = UIView(frame: view.frame)
            dimView.backgroundColor = color
            dimView.alpha = 0.0
            dimView.tag = 111
            view.addSubview(dimView)
            
            // Deal with Auto Layout
            dimView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            
            // Animate alpha (the actual "dimming" effect)
            UIView.animate(withDuration: speed) { () -> Void in
                dimView.alpha = alpha
            }
            
        case .Out:
            for v in self.view.subviews {
                if v.tag == 111 {
                    UIView.animate(withDuration: speed, animations: { () -> Void in
                        v.alpha = alpha
                        }, completion: { (complete) -> Void in
                            v.removeFromSuperview()
                    })
                }
            }
        }
    }
}
