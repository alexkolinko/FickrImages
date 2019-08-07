//
//  CollectionViewController.swift
//  FickrImages
//
//  Created by Alexandr on 8/4/19.
//  Copyright © 2019 Alex Kolinko. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    let api = WebAPI.sharedInstance
    let url = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=dogs&nojsoncallback=1#"
    let realmManager = RealmManager()
    var photos: Results<Title>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        collectionView.dragInteractionEnabled = true
        //        collectionView.dragDelegate = self
        //        collectionView.dropDelegate = self
        
        self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.api.getAPI(url: url)
        self.photos = realmManager.realm.objects(Title.self)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showForm"
        {
            let indexPath = sender as! IndexPath
            let photo = photos[indexPath.item]
            let imageURL = convertToURL(string: photo.media!.m)
            let title = photo.title
            let vc = segue.destination as! ViewController
            vc.selectedImage = imageURL
            vc.titleee = title
            vc.photoObject = photo
            vc.rating = photo.rating
        }
        
    }
    
    
    func convertToURL(string: String) -> URL? {
        return URL(string: string)
    }
    
    //    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    //    {
    //        let items = coordinator.items
    //        var photosList: List<Title>!
    //        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
    //        {
    //            var dIndexPath = destinationIndexPath
    //            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
    //            {
    //                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
    //            }
    //            collectionView.performBatchUpdates({
    //                photosList.remove(at: sourceIndexPath.item)
    //                photosList.insert(item.dragItem.localObject as! Title, at: dIndexPath.item)
    ////                self.photos.remove(at: sourceIndexPath.item)
    ////                self.photos.insert(item.dragItem.localObject as! Title, at: dIndexPath.item)
    //                collectionView.deleteItems(at: [sourceIndexPath])
    //                collectionView.insertItems(at: [dIndexPath])
    //            })
    //            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
    //        }
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard photos.count != 0 else {return 0}
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)  as! CollectionViewCell
        
        // Configure the cell
        let photo = photos[indexPath.item]
        
        cell.selectedImage = convertToURL(string: photo.media!.m)
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showForm", sender: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}


//extension CollectionViewController: UICollectionViewDragDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = convertToURL(string: self.photos[indexPath.item].media!.m)
//        let itemProvider = NSItemProvider(contentsOf: item)
//        let dragItem = UIDragItem(itemProvider: itemProvider!)
//        dragItem.localObject = item
//        return [dragItem]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]
//    {
//        let item = convertToURL(string: self.photos[indexPath.item].media!.m)
//
//        let itemProvider = NSItemProvider(contentsOf: item)
//        let dragItem = UIDragItem(itemProvider: itemProvider!)
//        dragItem.localObject = item
//        return [dragItem]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters?
//    {
//
//        let previewParameters = UIDragPreviewParameters()
//        previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 25, y: 25, width: 120, height: 120))
//        return previewParameters
//
//    }
//}

//extension CollectionViewController : UICollectionViewDropDelegate
//{
//    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
//    {
//        return session.canLoadObjects(ofClass: NSString.self)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
//    {
//        if collectionView === self.collectionView
//        {
//            if collectionView.hasActiveDrag
//            {
//                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//            }
//            else
//            {
//                return UICollectionViewDropProposal(operation: .forbidden)
//            }
//        }
//        else
//        {
//            if collectionView.hasActiveDrag
//            {
//                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//            }
//            else
//            {
//                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
//    {
//        let destinationIndexPath: IndexPath
//        if let indexPath = coordinator.destinationIndexPath
//        {
//            destinationIndexPath = indexPath
//        }
//        else
//        {
//            // Get last index path of table view.
//            let section = collectionView.numberOfSections - 1
//            let row = collectionView.numberOfItems(inSection: section)
//            destinationIndexPath = IndexPath(row: row, section: section)
//        }
//
//        switch coordinator.proposal.operation
//        {
//        case .move:
//            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
//            break
//        default:
//            return
//        }
//    }
//}
