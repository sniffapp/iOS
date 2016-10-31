
//
//  EquatableExtensions.swift
//  Sniff
//
//  Created by Andrea Ferrando on 27/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import RealmSwift

extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

public func ==(lhs: SFUser, rhs: SFUser) -> Bool {
    return lhs.token == rhs.token
}
