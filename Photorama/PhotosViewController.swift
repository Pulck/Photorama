//
//  ViewController.swift
//  Photorama
//
//  Created by Colick on 2017/11/20.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    var photoStore: PhotoStore!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        photoStore.fetchInterestingPhotos {
            photosResult in
            switch photosResult {
            case .success(let photos):
                print("Successful found \(photos.count)")
                self.photoDataSource.photos = photos
            case .failure(let error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        photoStore.fetchImage(for: photo) {
            result in
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
            
        }
    }
}
