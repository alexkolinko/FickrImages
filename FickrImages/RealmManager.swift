//
//  RealmManager.swift
//  FickrImages
//
//  Created by Alexandr on 8/4/19.
//  Copyright © 2019 Alex Kolinko. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let sharedInstance = RealmManager()
    private init() {}
    
    let realm = try! Realm()
    
    func save<T:Object>(objects: [T]){
        do{
            try realm.write {
                realm.add(objects)
            }
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func delete() {
        try? realm.write {
            realm.deleteAll()
        }
    }
}
