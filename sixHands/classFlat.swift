//
//  classFlat.swift
//  sixHands
//
//  Created by Илья on 29.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Flat{
    
    var imageOfFlat = [String]()
    var avatarImage: String = ""
    var numberOfRoomsInFlat:String = ""
    var flatMutualFriends:String = ""
    var flatPrice:String = ""
    var views: String = ""
    var newView: String = ""
    var address: String = ""
    var addressDetailedInfo : String = ""
    var flat_id = String()
    var square = String()
    var conditioning = String()
    var tv = String()
    var fridge = String()
    var internet = String()
    var parking = String()
    var comments = String()
    var stiralka = String()
    var posudomoyka = String()
    var animals = String()
    var longitude = String()
    var latitude = String()
    var update_date = String()
    var time = String()
    var time_to_subway = String()
    var floor = String()
    var floors = String()
    var subwayId = String()
    
}

class Station: Object{
    dynamic var id = 10
    var stationId:String = ""
    var name:String = ""
    var id_underground_line:String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Line: Object
{
    dynamic var id = 11
    var lineId:String = ""
    var name:String = ""
    var color:String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Subway:Object{
    dynamic var id = 2
    let subwayLines = List<Line>()
    let subwayStations = List<Station>()
    override static func primaryKey() -> String? {
        return "id"
    }
    class func getStation(id:String)->(station:String,color:UIColor){
       var sub = try! Realm().objects(Subway)
       
        print()
        
        return ("",UIColor.black)
    }
    
}






