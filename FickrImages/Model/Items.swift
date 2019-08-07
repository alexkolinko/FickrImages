//
//  Items.swift
//  FickrImages
//
//  Created by Alexandr on 8/4/19.
//  Copyright © 2019 Alex Kolinko. All rights reserved.
//

import Foundation
import RealmSwift

struct Items: Codable {
    let items:[Title]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}

class Title: Object, Codable {
    
    @objc dynamic var title: String = ""
    @objc dynamic var media: M? = nil
    @objc dynamic var rating: Int = 0
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case media = "media"
    }
}

class M: Object, Codable {
    @objc dynamic var m: String = ""
    
    enum CodingKeys: String, CodingKey {
        case m = "m"
        
    }
}
