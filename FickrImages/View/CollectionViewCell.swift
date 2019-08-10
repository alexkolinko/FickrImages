//
//  CollectionViewCell.swift
//  FickrImages
//
//  Created by Alexandr on 8/4/19.
//  Copyright © 2019 Alex Kolinko. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    
    var selectedImage: String? {
        didSet {updateUI()}
    }
    
    private func updateUI() {
        if let url = URL(string: selectedImage!) {
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, let image = UIImage(data: imageData) {
                        self.photoView.image = image
                    }
                }
            }
        }
    }
}
