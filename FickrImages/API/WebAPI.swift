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
    
    let realmManager = RealmManager.sharedInstance
    var photos: Results<Title>!
    static let sharedInstance = WebAPI()
    private init() {}
    
    func getAPI(url: String, completed:@escaping (_ currencys: Results<Title>)->Void){
        guard let testUrl = URL(string: url) else {return}
        AF.request(testUrl).validate().responseData { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.data else {return}
                do{
                    guard let myResponse = try? JSONDecoder().decode(Items.self, from: data) else {return}
                    self.realmManager.delete()
                    self.realmManager.save(objects: myResponse.items)
                    self.photos = self.realmManager.realm.objects(Title.self)
                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                    completed(self.photos)
                }
            case .failure(_):
                print("Error")
            }
        }
    }
}
