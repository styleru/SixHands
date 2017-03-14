//
//  person.swift
//  sixHands
//
//  Created by Илья on 12.03.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import Foundation
import RealmSwift

class person: Object {
    dynamic var id = 0
    dynamic var last_name = ""
    dynamic var first_name = ""
    dynamic var vk_id = ""
    dynamic var fb_id = ""
    dynamic var email = ""
    dynamic var phone = ""
    dynamic var avatar_url = ""
    dynamic var token = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}
