//
//  APIfunctions.swift
//  sixHands
//
//  Created by Илья on 01.02.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class API{
    
    var headers:HTTPHeaders = HTTPHeaders()
    
    
    
       
    //FLATS FILTER
    
    func flatsFilter(offset:Int,amount:Int, parameters: String, completionHandler: @escaping ([Flat])->Void){
        let realm = try! Realm()
        let per = realm.object(ofType: person.self, forPrimaryKey: 1)
        headers = ["Token":(per?.token)!]
        let fullRequest = domain + "/flats/filter?select=all&offset=\(offset)&amount=\(amount)&parameters=\(parameters)"
        
        Alamofire.request(fullRequest, headers : headers).responseJSON { response in
            var flats = [Flat]()
            let jsondata = JSON(data:response.data!)
            let array = jsondata["flats"].array
            if (array?.count) != nil {
                for i in 0..<array!.count{
                    let flat = Flat()
                    flat.avatarImage = jsondata["flats"][i]["owner"]["avatar"].string!
                    flat.flatPrice = jsondata["flats"][i]["price"].string!
                    //flat.idSubway = "Пока нема"
                    let number_of_friends = (jsondata["flats"][i]["mutual_friends"].array?.count)!
                    flat.flatMutualFriends = "\(number_of_friends) общих друзей"
                    flat.flat_id = jsondata["flats"][i]["id"].string!
                    flat.imageOfFlat.append(jsondata["flats"][i]["photos"][0]["url"].string!)
                    flat.numberOfRoomsInFlat = jsondata["flats"][i]["rooms"].string!
                    flats.append(flat)
                }
            }
            completionHandler(flats)
            
        }
    }
    
    
    func underground(id:String,completionHandler:@escaping (_ js:Any) ->()){
        let fullRequest = domain + "/underground?id_city=\(id)"
        Alamofire.request(fullRequest).responseJSON { response in
            let jsondata = JSON(data:response.data!)
            completionHandler(jsondata)
        }
    }
    
    
    
    //UNDERGROUND
  /*  func update_subway(){
        let fullRequest = domain + "/underground"
        let realm = try! Realm()
        let realm1 = try! Realm()
        let st = realm.object(ofType: Station.self, forPrimaryKey: 10)
        /*try! realm.write {
            realm.delete(realm.objects(Line))
            realm.delete(realm.objects(Station))
        }*/

        Alamofire.request(fullRequest).responseJSON { response in
            
            let jsondata = JSON(data:response.data!)
            if !jsondata.isEmpty{
                
                let stations_array = jsondata["stations"].array?.count
                for i in 0..<stations_array!{
                    let station = Station()
                    st?.stationId = jsondata["stations"][i]["id"].string!
                    st?.name = jsondata["stations"][i]["name"].string!
                    st?.id_underground_line = jsondata["stations"][i]["id_underground_line"].string!
                    DispatchQueue(label: "background22").async {
                        autoreleasepool {
                            let realm = try! Realm()
                            try! realm.write {
                            realm.add(st!, update: true)
                            }
                        }
                    }
                    
                }
                let lines_array = jsondata["lines"].array?.count
                for i in 0..<lines_array!{
                    let line = Line()
                    line.lineId = jsondata["lines"][i]["id"].string!
                    line.name = jsondata["lines"][i]["name"].string!
                    line.color = jsondata["lines"][i]["color"].string!
                 
                }
              /*  DispatchQueue(label: "background2").async {
                    autoreleasepool {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.delete(realm.objects(Line))
                            realm.delete(realm.objects(Station))
                            realm.add(subway, update: true)
                        }
                    }
                }*/

            }
            
            
            
        }
        
    }
    
    */
    
    
    //TOKEN CHECK
    func tokenCheck(token:String,completionHandler:@escaping (_ js:Int) ->()){
        let fullRequest = domain + "/token"
        
        if token != ""{
            headers = ["Token" : token]
        } else {
            headers = ["Token" : ""]
        }
        Alamofire.request(fullRequest, headers: headers).responseJSON { response in
            let jsondata = (response.response?.statusCode)!
            completionHandler(jsondata)
        }
        
    }
    
    func upload(photoData: [Data], parameters: [String : String], completionHandler:@escaping (_ js:Any) ->()){
        let fullRequest = domain + "/flats/single"
        let encoded = fullRequest.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let myUrl = URL(string: encoded!)
        
        headers = ["Token" : UserDefaults.standard.value(forKey: "Token") as! String]
        
        Alamofire.upload(multipartFormData: { (multipart) in
            
            for (key, value) in parameters {
                multipart.append(value.data(using: String.Encoding.utf8)!, withName: key)
                print("\(key) : \(value)")
            }
            
            var i = 0
            
            for data in photoData {
                multipart.append(data, withName: "photo\(i)", fileName: "photo\(i).jpg", mimeType: "image/jpeg")
                i += 1
            }
            
        }, to: myUrl!, method: .post, headers:headers, encodingCompletion: { result in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let request, _, _):
                request.response(completionHandler: { (response) in
                    print("kek: \(response.response!)")
                    let json = JSON(data: response.data!)
                    completionHandler(json)
                })
            }
        })
        
    }
    
    func flatSingle(id:String, completionHandler: @escaping (Flat)->Void){
        let fullRequest = domain + "/flats/single?id_flat=" + id
        let realm = try! Realm()
        let per = realm.object(ofType: person.self, forPrimaryKey: 1)
        headers = ["Token":(per?.token)!]
        var flat = Flat()
        Alamofire.request(fullRequest, headers : headers).responseJSON { response in
            let jsondata = JSON(data:response.data!)
            flat.avatarImage = jsondata["owner"]["avatar"].string!
            flat.flatPrice = jsondata["price"].string!
           // flat.idSubway = "Пока нема"
            let number_of_friends = (jsondata["mutual_friends"].array?.count)!
            flat.flatMutualFriends = "\(number_of_friends) общих друзей"
            flat.flat_id = jsondata["id"].string!
            let photoArray:Int = (jsondata["photos"].array?.count)!
            for i in 0..<photoArray{
                flat.imageOfFlat.append(jsondata["photos"][i]["url"].string!)
            }
            flat.numberOfRoomsInFlat = jsondata["rooms"].string!
            flat.update_date = jsondata["update_date"].string!
            flat.time_to_subway = jsondata["to_underground"].string!
            flat.square = jsondata["square"].string!
            flat.floor = jsondata["floor"].string!
            flat.floors = jsondata["floors"].string!
        }
        completionHandler(flat)
    }
    
    
    
    func user(){
    }
    
}
