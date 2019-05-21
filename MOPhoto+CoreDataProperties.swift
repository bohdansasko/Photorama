//
//  MOPhoto+CoreDataProperties.swift
//  Photorama
//
//  Created by Bogdan Sasko on 5/21/19.
//  Copyright © 2019 Vinso. All rights reserved.
//
//

import Foundation
import CoreData


extension MOPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOPhoto> {
        return NSFetchRequest<MOPhoto>(entityName: "MOPhoto")
    }

    @NSManaged public var title: String?
    @NSManaged public var remoteURL: NSURL?
    @NSManaged public var photoID: String?
    @NSManaged public var dateTaken: NSDate?

}
