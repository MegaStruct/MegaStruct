//
//  User+CoreDataProperties.swift
//  MegaStruct
//
//  Created by A Hyeon on 4/26/24.
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
