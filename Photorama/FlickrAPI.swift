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
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos,
                         parameters: ["extras" : "url_h,date_taken"])
    }
}

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
}
