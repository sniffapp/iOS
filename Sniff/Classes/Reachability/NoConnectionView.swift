//
//  NoConnectionView.swift
//  Sniff
//
//  Created by Andrea Ferrando on 17/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

class NoConnectionView : UIView {
    
    
    let text : String = SFConstants.Strings.Notifications.reachabilityNoConnectionText1
    let label : UILabel = UILabel()
    var didSetupContraints : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        backgroundColor = UIColor.clear
        let backgroundV = UIView(frame:self.frame)
        backgroundV.backgroundColor = UIColor.red
        backgroundV.alpha = 1
        addSubview(backgroundV)
        
        label.frame = frame
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
        label.textColor = UIColor.white
        label.center = center
        label.textAlignment = .center
        addSubview(label)
    }
    
    
}
