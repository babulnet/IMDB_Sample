//
//  StringHolder+CoreDataProperties.swift
//  PhonePeTest
//
//  Created by Babul Raj on 13/11/22.
//
//

import Foundation
import CoreData


extension StringHolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StringHolder> {
        return NSFetchRequest<StringHolder>(entityName: "StringHolder")
    }

    @NSManaged public var string: String?

}

extension StringHolder : Identifiable {

}
