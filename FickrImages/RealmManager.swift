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
    
    
    
    func saveObjects<T:Object>(objs: T) {
        do{
            try realm.write {
                realm.add(objs)
            }
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func deleteObject(objs : Object) {
        do {
            try? realm.write {
                realm.delete(objs)
            }
        }
    }
    
    func delete() {
        try? realm.write {
            realm.deleteAll()
        }
    }
}
