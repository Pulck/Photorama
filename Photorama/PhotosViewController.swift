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
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoStore.fetchInterestingPhotos {
            photosResult in
            switch photosResult {
            case .success(let photos):
                print("Successful found \(photos.count)")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case .failure(let error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateImageView(for photo: Photo) {
        photoStore.fetchImage(for: photo) {
            imageResult in
            switch imageResult {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
    }
}

