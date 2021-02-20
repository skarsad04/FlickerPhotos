//
//  Photos+CoreDataProperties.swift
//  
//
//  Created by Alam, Sk on 21/02/2021.
//
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos")
    }

    @NSManaged public var username: String?
    @NSManaged public var pages: String?
    @NSManaged public var photos: String?

}
