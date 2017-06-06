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
    var buttonOwner : (_ fullName:String,_ number:String)->(NSMutableAttributedString) = {fullName,number in
        let seafoamBlue = UIColor(red: 85.0/255.0, green: 197.0/255.0, blue: 183.0/255.0, alpha: 1.0)
        let firstText = "Хозяин "
        let name = fullName + "\n\(number) "
        let secondText = "общих друзей ❯"
        let attrText1 = NSMutableAttributedString(string: firstText)
        attrText1.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0,attrText1.length))
        
        let attrText2 = NSMutableAttributedString(string: name)
        attrText2.addAttribute(NSForegroundColorAttributeName, value: seafoamBlue, range: NSMakeRange(0,attrText2.length))
        let attrText3 = NSMutableAttributedString(string: secondText)
        attrText3.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0,attrText3.length))
        let attributedText = NSMutableAttributedString()
        attributedText.append(attrText1)
        attributedText.append(attrText2)
        attributedText.append(attrText3)
        return attributedText
    }
    var ownerName = String()
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
    var options = [String]()
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

/*class Station: Object{
    var stationId:String = ""
    var name:String = ""
    var id_underground_line:String = ""
   }

class Line: Object
{
    var lineId:String = ""
    var name:String = ""
    var color:String = ""
}

class Subway:Object{
    dynamic var id = 2
    let subwayLines = List<Line>()
    let subwayStations = List<Station>()
    override static func primaryKey() -> String? {
        return "id"
    }
    class func getStation(id:String)->(station:String,color:UIColor){
       var sub = try! Realm().objects(Subway.self)
       
        print()
        
        return ("",UIColor.black)
    }
    
}





*/
