//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Colick on 2017/11/20.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import Foundation

struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
        }()
//    static var interestingPhotosURL: URL {
//        return flickrURL(method: .interestingPhotos,
//                         parameters: ["extras" : "url_h,date_taken"])
//    }
    
    static func generateURLUse(method: Method) -> URL {
        return flickrURL(method: method,
                         parameters: ["extras" : "url_h,date_taken"])
    }
    
    private static func photo(from json: [String : Any]) -> Photo? {
        guard let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else{
                return nil
        }
        return Photo(title: title, photoID: photoID,
                     remoteURL: url, dateTaken: dateTaken)
    }
    
    private static func flickrURL(method: Method,
                                  parameters: [String : String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let paraBase = [
            "method" : method.rawValue,
            "format" : "json",
            "nojsoncallback" : "1",
            "api_key" : apiKey
        ]
        for (key, value) in paraBase {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additonalParams = parameters {
            for (key, value) in additonalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static func photos(fromJSON data: Data) -> PhotosResult {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonData as? [String : Any],
            let photos = jsonDictionary["photos"] as? [String : Any],
                let photosArray = photos["photo"] as? [[String : Any]] else {
                    return .failure(FlickrError.invaildJSONData)
            }
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photo(from: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                return .failure(FlickrError.invaildJSONData)
            }
            return .success(finalPhotos)
        } catch {
            return .failure(error)
        }
    }
}

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.interestingness.getRecent"
}

enum FlickrError: Error {
    case invaildJSONData
}
