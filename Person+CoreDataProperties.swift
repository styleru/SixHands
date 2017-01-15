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

}
