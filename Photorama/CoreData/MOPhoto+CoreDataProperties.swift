//
//  MOPhoto+CoreDataProperties.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/25/19.
//  Copyright © 2019 Vinso. All rights reserved.
//
//

import Foundation
import CoreData


extension MOPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOPhoto> {
        return NSFetchRequest<MOPhoto>(entityName: "MOPhoto")
    }

    @NSManaged public var viewCount: Int64
    @NSManaged public var dateTaken: NSDate?
    @NSManaged public var photoID: String?
    @NSManaged public var remoteURL: NSURL?
    @NSManaged public var title: String?

}
