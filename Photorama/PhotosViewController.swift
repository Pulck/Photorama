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
            case .failure(let error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

