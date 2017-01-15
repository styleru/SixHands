//
//  User+CoreDataProperties.swift
//  sixHands
//
//  Created by Владимир Марков on 13.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import Foundation
import CoreData


extension ApplicationUser {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ApplicationUser> {
        return NSFetchRequest<ApplicationUser>(entityName: "User");
    }
    
    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    
    
}
