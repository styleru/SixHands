//
// FacebookAuth.swift
// sixHands
//
// Created by Илья on 18.01.17.
// Copyright © 2017 Владимир Марков. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON
import RealmSwift

public func FBLogin(){
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    fbLoginManager .logIn(withReadPermissions: ["public_profile","email","user_friends","user_location"], handler: { (result, error) -> Void in
        if (error == nil){
            let fbloginresult : FBSDKLoginManagerLoginResult = result!
            if(fbloginresult.grantedPermissions != nil && fbloginresult.grantedPermissions.contains("email"))
            {
                getFBUserData(token: (result?.token.tokenString)!,withcompletionHandler: { (true) in
                    
                })
                
               
                
                
                fbLoginManager.logOut()
            }
        }
    })
}

func getFBUserData(token:String,withcompletionHandler:(_ success:Bool) ->())
{
    let request = FBSDKGraphRequest(graphPath: "me", parameters:["fields": "id,first_name, last_name, email"])
    
    request?.start(completionHandler: { (connection, result, error) -> Void in
        if(error == nil)
        {
            let fbDetails = result as! NSDictionary
            let params:Parameters = ["first_name": fbDetails["first_name"]! as! String,
                                     "last_name":fbDetails["last_name"]! as! String ,
                                     "email":fbDetails["email"]! as! String ,
                                     "avatar": "http://graph.facebook.com/\(fbDetails["id"]!)/picture?type=large",
                "phone": "000",
                "device":"iPhone",
                "sn_type":"fb",
                "sn_id":fbDetails["id"]! as! String,
                "token": token]
       
            
            let url = "http://6hand.anti.school/user"
            //ПОЛУЧАЮ JSON С СЕРВАКА
            
            Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
                
                //ЗАНОС В CORE DATA
                
                if let data = response.data {
                    var jsondata = JSON(data: data)
                    let per = person()
                    per.token = jsondata["token"].string!
                  
                    
                        if jsondata != nil{
                        print(jsondata)
                        per.first_name = jsondata["user"]["first_name"].string!
                        per.last_name = jsondata["user"]["last_name"].string!
                        per.email = jsondata["user"]["email"].string!
                        per.phone = jsondata["user"]["phone"].string!
                        per.avatar_url = jsondata["user"]["avatar"].string!
                        per.fb_id = jsondata["user"]["social_networks"][0]["id_user"].string!
                            per.user_id = Int(jsondata["user"]["id"].string!)!
                            UserDefaults.standard.set(per.user_id, forKey: "id_user")
                            UserDefaults.standard.synchronize()
                           }
                    DispatchQueue(label: "background").async {
                        autoreleasepool {
                            print(per)
                            let realm = try! Realm()
                            try! realm.write {
                                realm.add(per, update: true)
                            }
                        }
                    }
                    }
                let delayTime = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let afterLoginTB = storyboard.instantiateViewController(withIdentifier: "afterLogin") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = afterLoginTB}
            }
            
            
        }
        else
        {
            print("error \(error)")
        }
        
        
    })
}
