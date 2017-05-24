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
    
    
    
   func flatsSingle(id:String,completionHandler:@escaping (_ js:Any) ->()){
        let fullRequest = domain + "/flats/single?id_flat=" + id
    let realm = try! Realm()
    let per = realm.object(ofType: person.self, forPrimaryKey: 1)
    headers = ["Token":(per?.token)!]

   
    Alamofire.request(fullRequest, headers:headers).responseJSON { response in
            let jsondata = JSON(data:response.data!)
            completionHandler(jsondata)
        }
    }
    
    //FLATS FILTER
    
    func flatsFilter(offset:Int,amount:Int, parameters: String, completionHandler: @escaping ([Flat])->Void){
        let realm = try! Realm()
        let per = realm.object(ofType: person.self, forPrimaryKey: 1)
        headers = ["Token":(per?.token)!]
        let fullRequest = domain + "/flats/filter?select=all&offset=\(offset)&amount=\(amount)\(parameters)"
        
        Alamofire.request(fullRequest, headers : headers).responseJSON { response in
            var flats = [Flat]()
            let jsondata = JSON(data:response.data!)
            let array = jsondata.array
            if (array?.count) != nil {
                for i in 0..<array!.count{
                    let flat = Flat()
                    flat.avatarImage = jsondata[i]["owner"]["avatar"].string!
                    flat.flatPrice = jsondata[i]["price"].string!
                    flat.idSubway = "Пока нема"
                    let number_of_friends = (jsondata[i]["mutual_friends"].array?.count)!
                    flat.flatMutualFriends = "\(number_of_friends) общих друзей"
                    flat.flat_id = jsondata[i]["id"].string!
                    flat.imageOfFlat.append(jsondata[i]["photos"][0]["url"].string!)
                    flat.numberOfRoomsInFlat = jsondata[i]["rooms"].string!
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
    func update_subway(){
        var stations = [station]()
        var lines = [line]()
        let realm = try! Realm()
        let per = realm.object(ofType: person.self, forPrimaryKey: 1)
        let fullRequest = domain + "/underground?id_city=1"
        Alamofire.request(fullRequest).responseJSON { response in
            let jsondata = JSON(data:response.data!)
            if !jsondata.isEmpty{
            let stations_array = jsondata["stations"].array?.count
                for i in 0..<stations_array!{
                let Station = station()
                    Station.id = jsondata["stations"][i]["id"].string!
                    Station.name = jsondata["stations"][i]["name"].string!
                    Station.id_underground_line = jsondata["stations"][i]["id_underground_line"].string!
                    stations.append(Station)
                }
            let lines_array = jsondata["lines"].array?.count
                for i in 0..<lines_array!{
                    let Line = line()
                    Line.id = jsondata["lines"][i]["id"].string!
                    Line.name = jsondata["lines"][i]["name"].string!
                    Line.color = jsondata["lines"][i]["color"].string!
                    lines.append(Line)
                }

            }
         //
           
        }

    }
       
   
    
    
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
    
     func Single(id:String, completionHandler: @escaping (Flat)->Void){
        let fullRequest = domain + "/flats/single?id_flat=" + id
        let realm = try! Realm()
        let per = realm.object(ofType: person.self, forPrimaryKey: 1)
        headers = ["Token":(per?.token)!]
       
        Alamofire.request(fullRequest, headers : headers).responseJSON { response in
            var flat = Flat()
            let jsondata = JSON(data:response.data!)
            flat.avatarImage = jsondata["owner"]["avatar"].string!
            flat.flatPrice = jsondata["price"].string!
            flat.idSubway = "Пока нема"
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
    }
    
    
    
    func user(){
    }
    
}
