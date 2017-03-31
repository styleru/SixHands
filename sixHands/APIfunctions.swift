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
   // let headers:HTTPHeaders = ["Token": UserDefaults.standard.object(forKey:"token") as! String]
    //при первом входе токена нет и будет nil!!!!!!!!!
    let headers:HTTPHeaders = ["Token": per!.token]
    func flatsSingle(id:String,completionHandler:@escaping (_ js:Any) ->()){
    let fullRequest = domain + "/flats/single?id_flat="+id
        Alamofire.request(fullRequest).responseJSON { response in
        let jsondata = JSON(data:response.data!)
        completionHandler(jsondata)
    }
    }
    
    
    
    func flatsFilter(offset:Int,amount:Int, parameters: String, completionHandler:@escaping (_ js:Any) ->()){
        let fullRequest = domain + "/flats/filter?select=all&offset=\(offset)&amount=\(amount)\(parameters)"
        print(fullRequest)
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
    
    func user(){
    }
    
}
