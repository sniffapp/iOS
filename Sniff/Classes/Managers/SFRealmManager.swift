//
//  SFRealmManager.swift
//  Sniff
//
//  Created by Andrea Ferrando on 26/09/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftFetchedResultsController

class SFRealmManager {
    
//    public static let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "Test"))
    public static let realm = try! Realm()
    
    public class func saveRealmObjectAndUpdate(object: Object) {
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    public class func deleteRealmObject(object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    public class func getLoggedUser() -> SFUser? {
        guard let token = SFUserDefaults.getActiveUserToken() else { return nil }
        return getUser(token: token)
    }
    
    public class func getUsers() -> [SFUser] {
        return Array(realm.allObjects(ofType: SFUser.self))
    }
    
    public class func getUser(token: String) -> SFUser? {
        return Array(realm.allObjects(ofType: SFUser.self).filter(using:NSPredicate(format:"token == %@",token))).first
    }
    
    public class func userIsLoggedIn() -> Bool {
        return getLoggedUser() != nil
    }
    
    public class func logout() {
        if let loggedUser = getLoggedUser() {
            deleteRealmObject(object: loggedUser)
            SFUserDefaults.setActiveUserToken(nil)
        }
    }
    
    //MARK: - FetchResults
    public class FetchResults {
        
//        public class func getTags() -> FetchedResultsController<SFTag> {
//            
//            let predicate = NSPredicate(format: "displayName != %@","")
//            let fetchRequest = FetchRequest<SFTag>(realm: realm, predicate: predicate)
//            let sortDescriptor = SortDescriptor(property: "score", ascending: true)
//            fetchRequest.sortDescriptors = [sortDescriptor]
//            
//            return FetchedResultsController<SFTag>(fetchRequest: fetchRequest, sectionNameKeyPath: nil, cacheName: nil)
//        }
    }
}



