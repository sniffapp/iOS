//
//  Theme&Style.swift
//  EyeTuner-life
//
//  Created by Andrea Ferrando on 04/05/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import UIKit

public class SFTheme {
    public class func setup() {
        UISearchBar.appearance().setImage(UIImage(named: "ic_search_icon"), for: UISearchBarIcon.search, state: UIControlState.normal)
    }
}

struct SFColor {
    static let lightGray: UIColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
    static let lightBlue: UIColor = UIColor(red: 234/255.0, green: 240/255.0, blue: 254/255.0, alpha: 1.0)
    static let greenColor: UIColor = UIColor(red: 158/255.0, green: 212/255.0, blue: 57/255.0, alpha: 1.0)
    static let black: UIColor = UIColor(red: 67/255.0, green: 72/255.0, blue: 72/255.0, alpha: 1.0)
    static let red: UIColor = UIColor(red: 255/255.0, green: 81/255.0, blue: 63/255.0, alpha: 1.0)
    static let lightBlueMessages: UIColor = UIColor(red: 227/255.0, green: 245/255.0, blue: 255/255.0, alpha: 1.0)
    static let orange : UIColor = UIColor(red: 255/255.0, green: 101/255.0, blue: 0/255.0, alpha: 1.0)
    static let orangeLight : UIColor = UIColor(red: 11/255.0, green: 34/255.0, blue: 66/255.0, alpha: 1.0)
    static let orangeDark : UIColor = UIColor(red: 38/255.0, green: 105/255.0, blue: 122/255.0, alpha: 1.0)
}


