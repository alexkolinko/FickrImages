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

    
    var selectedImage: URL? {
        didSet {updateUI()}
    }
    
    
    private func updateUI() {
        if let url = selectedImage {
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self.selectedImage, let image = UIImage(data: imageData) {
                        self.photoView.image = image
                    }
                }
            }
        }
    }
}
