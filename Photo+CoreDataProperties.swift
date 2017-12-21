//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Colick on 2017/12/21.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoID: String?
    @NSManaged public var title: String?
    @NSManaged public var dataTaken: NSDate?
    @NSManaged public var remoteURL: NSURL?

}
