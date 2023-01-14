//
//  PlayListStorage+CoreDataProperties.swift
//  PhonePeTest
//
//  Created by Babul Raj on 13/11/22.
//
//

import Foundation
import CoreData


extension PlayListStorage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayListStorage> {
        return NSFetchRequest<PlayListStorage>(entityName: "PlayListStorage")
    }

    @NSManaged public var name: String?
    @NSManaged public var list: NSSet?

}

// MARK: Generated accessors for list
extension PlayListStorage {

    @objc(addListObject:)
    @NSManaged public func addToList(_ value: StringHolder)

    @objc(removeListObject:)
    @NSManaged public func removeFromList(_ value: StringHolder)

    @objc(addList:)
    @NSManaged public func addToList(_ values: NSSet)

    @objc(removeList:)
    @NSManaged public func removeFromList(_ values: NSSet)

}

extension PlayListStorage : Identifiable {

}
