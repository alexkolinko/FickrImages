//
//  WebAPI.swift
//  FickrImages
//
//  Created by Alexandr on 8/4/19.
//  Copyright © 2019 Alex Kolinko. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class WebAPI {
    
    let realmManafer = RealmManager()
    
    
    static let sharedInstance = WebAPI()
    private init() {}
    
    //    let queue = DispatchQueue(label: "My queue", qos: .background, attributes: .concurrent)
    
    func getAPI(url: String){
        
        guard let testUrl = URL(string: url) else {return}
        AF.request(testUrl).validate().responseData { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.data else {return}
                do{
                    guard let myResponse = try? JSONDecoder().decode(Items.self, from: data) else {return}
                    self.realmManafer.delete()
                    self.realmManafer.save(objects: myResponse.items)
                    //                    completed(myResponse)
                }
            case .failure(_):
                print("Error")
            }
        }
    }
}
