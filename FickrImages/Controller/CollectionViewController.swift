//
//  CollectionViewController.swift
//  FickrImages
//
//  Created by Alexandr on 8/4/19.
//  Copyright © 2019 Alex Kolinko. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    let identifier = "Cell"
    let api = WebAPI.sharedInstance
    let url = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=dogs&nojsoncallback=1#"
    var photoObjects = [Title]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dragInteractionEnabled = true
        self.collectionView.dragDelegate = self
        self.collectionView.dropDelegate = self
        self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        self.api.getAPI(url: url) { (results) in
            for result in results {
                self.photoObjects.append(result)
            }
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showForm"
        {
            let indexPath = sender as! IndexPath
            let photoObject = photoObjects[indexPath.item]
            let imageURL = photoObject.media!.m
            let title = photoObject.title
            let vc = segue.destination as! ViewController
            vc.selectedImage = imageURL
            vc.titleee = title
            vc.photoObject = photoObject
            vc.rating = photoObject.rating
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard photoObjects.count != 0 else {return 0}
        return photoObjects.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)  as! CollectionViewCell
        let photo = photoObjects[indexPath.item]
        cell.selectedImage = photo.media?.m
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showForm", sender: indexPath)
    }
}

extension CollectionViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        
        let previewParameters = UIDragPreviewParameters()
        previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 25, y: 25, width: 120, height: 120))
        return previewParameters
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let itemCell = collectionView?.cellForItem(at: indexPath)
            as? CollectionViewCell,
            let image = itemCell.photoView.image {
            let dragItem =
                UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = indexPath
            return [dragItem]
        }   else {
            return []
        }
    }
}

extension CollectionViewController : UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isSelf = (session.localDragSession?.localContext as?
            UICollectionView) == collectionView
        if isSelf {
            return session.canLoadObjects(ofClass: UIImage.self)
        } else {
            return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ??
            IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    let imageInfo = self.photoObjects.remove(at: sourceIndexPath.item)
                    self.photoObjects.insert(imageInfo, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
}
