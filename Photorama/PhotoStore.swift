//
//  PhotoStore.swift
//  Photorama
//
//  Created by Colick on 2017/11/20.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import Foundation
import UIKit

class PhotoStore {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    var fetchExpect: Method = .interestingPhotos
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = FlickrAPI.generateURLUse(method: fetchExpect)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let httpURLResponse = response as? HTTPURLResponse {
                print("status code: \(httpURLResponse.statusCode)")
                for (key, value) in httpURLResponse.allHeaderFields {
                    print("key: \(key) value: \(value)")
                }
            }
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (Imageresult) -> Void) {
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            let result = self.proceessImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func proceessImageRequest(data: Data?, error: Error?) -> Imageresult {
        guard let imageData = data,
            let image = UIImage(data: imageData) else {
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
         return .success(image)
    }
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

enum Imageresult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}
