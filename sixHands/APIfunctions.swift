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

/*func Filter(user_id:String,sorting:String,parameters:String?,amount:Int8) {
    
    let headers:HTTPHeaders = ["Token": UserDefaults.standard.object(forKey:"token") as! String]
    Alamofire.request("http://dev.6hands.styleru.net/flats/filter?id_user=\(user_id)&sorting=\(sorting)&offset=0&amount=\(amount)&parameters=\(parameters)",headers:headers).responseData { response in
        if let data = (response.data){
        
        parseJSON(data: data)
        }
        }
}



 func parseJSON(data: Data) {
    do{
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

        let jsonFlat = jsonResult?["body"] as! [AnyObject]
        for j in jsonFlat{
        }
    
    
    }
    catch{}
}*/
