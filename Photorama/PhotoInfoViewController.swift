//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Colick on 2017/11/22.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchImage(for: photo) {
            result in
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
}
