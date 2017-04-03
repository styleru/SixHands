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

let per = realm.object(ofType: person.self, forPrimaryKey: 0)
class API{
    
    let domain = "http://dev.6hands.styleru.net"

    var headers:HTTPHeaders = HTTPHeaders()


   // let headers:HTTPHeaders = ["Token": UserDefaults.standard.object(forKey:"token") as! String]
    //при первом входе токена нет и будет nil!!!!!!!!!

   //let headers:HTTPHeaders = ["Token": UserDefaults.standard.object(forKey:"token") as! String]

    // headers:HTTPHeaders = ["Token": per!.token]

    
    func flatsSingle(id:String,completionHandler:@escaping (_ js:Any) ->()){
    let fullRequest = domain + "/flats/single?id_flat=" + id
        
        Alamofire.request(fullRequest).responseJSON { response in
        let jsondata = JSON(data:response.data!)
        completionHandler(jsondata)
        }
    }
    
    
    

    func flatsFilter(offset:Int,amount:Int, parameters: String, completionHandler:@escaping (_ js:Any) ->()){
        let fullRequest = domain + "/flats/filter?select=all&offset=\(offset)&amount=\(amount)"}

    func flatsFilter(offset:Int,amount:Int,completionHandler:@escaping (_ js:Any) ->()){
        let fullRequest = domain + "/flats/filter?select=all&offset=\(offset)&amount=\(amount)"

        Alamofire.request(fullRequest).responseJSON { response in
            let jsondata = JSON(data:response.data!)
            completionHandler(jsondata)
        }
        }
    
    func underground(id:String,completionHandler:@escaping (_ js:Any) ->()){
        let fullRequest = domain + "/underground?id_city=\(id)"
        Alamofire.request(fullRequest).responseJSON { response in
            let jsondata = JSON(data:response.data!)
            completionHandler(jsondata)
        }
        }
    
    func upload(photoData: [Data], parameters: [String : String], completionHandler:@escaping (_ js:Any) ->()){
        let fullRequest = domain + "/flats/single"
        let encoded = fullRequest.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let myUrl = URL(string: encoded!)
        
        headers = ["Token" : per!.token]
        print("headers: \(headers)")
        
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
            
        }, to: myUrl!, method: .post, headers: headers, encodingCompletion: { result in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let request, _, _):
                request.response(completionHandler: { (response) in
                    let json = JSON(data: response.data!)
                    print("\(response.response!)")
                    completionHandler(json)
                })
            }
        })

    }
    
    func user(){
    }
    
        }
