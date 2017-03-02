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

class API{
    let domain = "http://dev.6hands.styleru.net"
    
    
    func flatsSingle(id:String,withcompletionHandler: @escaping () ->()){
    let fullRequest = domain + "/flats/single?id_flat="+id
        Alamofire.request(fullRequest).responseJSON { response in
            var jsondata = JSON(data:response.data!)
            print("getFlat: ")
        }

    
    
    }
    
    func underGround(){
    }
    
    func user(){
    }
    
}
