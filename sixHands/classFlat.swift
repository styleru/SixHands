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
    
    var buttonOwner : (_ fullName:String)->(NSMutableAttributedString) = {fullName in
        let seafoamBlue = UIColor(red: 85.0/255.0, green: 197.0/255.0, blue: 183.0/255.0, alpha: 1.0)
        let firstText = "Хозяин "
        let name = fullName
        
        let attrText1 = NSMutableAttributedString(string: firstText)
        attrText1.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0,attrText1.length))
        
        let attrText2 = NSMutableAttributedString(string: name)
        attrText2.addAttribute(NSForegroundColorAttributeName, value: seafoamBlue, range: NSMakeRange(0,attrText2.length))
       
        let attributedText = NSMutableAttributedString()
        attributedText.append(attrText1)
        attributedText.append(attrText2)
        return attributedText
    }
    var isFavourite = String()
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
    var photos = [Data]()
    var owner_id = String()
    
}

class Station: Object{
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
        let realm = try! Realm()
        let sub = realm.object(ofType: Subway.self, forPrimaryKey: 2)
        let station = sub?.subwayStations[Int(id)!-1]
        let name = station?["name"]
        let idLine:String = station?["id_underground_line"] as! String
        let line = sub?.subwayLines[Int(idLine)!-1]
        let colorString = line?["color"] as! String
        let color = UIColor.init(hexString: colorString+"ff")
        
        return (name as! String,color!)
    }
    
}
class Option:Object{
    var id:String?
    var image:NSData?
    var name:String?
}
class Options:Object{
dynamic var id = 3
let options = List<Option>()
    
    class func getOption(optionId:String)->(name:String?,icon:UIImage?){
        let realm = try! Realm()
        let option = realm.objects(Option.self).filter("id=='\(optionId)'").first
        let image = UIImage(data: option?["image"] as! Data)
        let name = option?["name"]
        return (name as! String,image)
    }

    class func getAll() -> (Options) {
        let realm = try! Realm()
        let options = realm.objects(Options.self).first
        return (options)!
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
