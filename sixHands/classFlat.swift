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

class Flat{
    
    var imageOfFlat = [String]()
    var avatarImage: String = ""
    var idSubway:String = ""
    var subway_color:String = ""
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
    
}

class station{
    var id:String = ""
    var name:String = ""
    var id_underground_line:String = ""
    //GET STATION
   class func get_station(id:String, completionHandler: @escaping (_ Station:String,_ id:String)->Void){
    
    
            let station = ""
            let id = ""
            completionHandler(station, id)
    
    }

}

class line{
    var id:String = ""
    var name:String = ""
    var color:String = ""
   
    //GET LINE AND COLOR
   class func get_color_of_station(id:String, completionHandler: @escaping (_ color:UIColor)->Void){
        
        
            let color = "jj"
            let full_color = UIColor(hexString:color+"ff")
            completionHandler(full_color!)
        
    }

    
}







