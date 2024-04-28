//
//  MyMovie+CoreDataProperties.swift
//  MegaStruct
//
//  Created by 신지연 on 2024/04/28.
//
//

import Foundation
import CoreData


extension MyMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyMovie> {
        return NSFetchRequest<MyMovie>(entityName: "MyMovie")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var price: String?
    @NSManaged public var showDate: Date?
    @NSManaged public var showTime: Date?
    @NSManaged public var title: String?

}

extension MyMovie : Identifiable {

}
