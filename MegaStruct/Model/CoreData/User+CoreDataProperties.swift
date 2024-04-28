//
//  User+CoreDataProperties.swift
//  MegaStruct
//
//  Created by 신지연 on 2024/04/28.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var birthDate: Int32
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var nickName: String?
    @NSManaged public var pwd: String?

}

extension User : Identifiable {

}
