//
//  ViewController.swift
//  FickrImages
//
//  Created by Alexandr on 8/5/19.
//  Copyright © 2019 Alex Kolinko. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var selectPhoto: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    let realmManager = RealmManager.sharedInstance
    var name: String?
    var rating: Int?
    var photoObject = Title()
    var selectedImage: String? {
        didSet {updateUI()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = title
        self.ratingControl.rating = rating!
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        try? self.realmManager.realm.write {
            photoObject.rating = ratingControl.rating
            print(ratingControl.rating)
        }
    }
    
    private func updateUI() {
        if let url = URL(string: selectedImage!) {
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, let image = UIImage(data: imageData) {
                        if let i = self.selectPhoto {
                            i.image = image
                        } else {
                            print("Not have image")
                        }
                    }
                }
            }
        }
    }
}
