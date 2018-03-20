//
//  RandomStrings+CoreDataProperties.swift
//  TableViewSwiftExample
//
//  Created by Kirti Parghi on 3/20/18.
//  Copyright © 2018 Kirti Parghi. All rights reserved.
//
//

import Foundation
import CoreData

extension RandomStrings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RandomStrings> {
        return NSFetchRequest<RandomStrings>(entityName: "RandomStrings")
    }

    @NSManaged public var content: String?

}
