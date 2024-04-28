//
//  Search+CoreDataProperties.swift
//  MegaStruct
//
//  Created by 신지연 on 2024/04/28.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var keyword: String?

}

extension Search : Identifiable {

}
