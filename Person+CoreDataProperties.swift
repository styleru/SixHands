//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Владимир Марков on 15.01.17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var last_name: String?
    @NSManaged public var first_name: String?
    @NSManaged public var vk_id: Int32
    @NSManaged public var fb_id: Int32
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var avatar_url: String?

}
