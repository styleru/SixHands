//
//  FacebookAuth.swift
//  sixHands
//
//  Created by Илья on 18.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON



let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
var fbDetails  = NSDictionary()
public func FBLogin(){
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logIn(withReadPermissions: ["public_profile","email"], handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions != nil && fbloginresult.grantedPermissions.contains("email"))
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let  afterLoginTB = storyboard.instantiateViewController(withIdentifier: "afterLogin") as! UITabBarController
                     let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = afterLoginTB
                    })
                    getFBUserData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        //КИДАЮ ДАННЫЕ НА СЕРВАК
                        let params: Parameters = [
                            "first_name": fbDetails["first_name"]! as! String,
                            "last_name":fbDetails["last_name"]! as! String ,
                            "email":fbDetails["email"]! as! String ,
                            "avatar": "http://graph.facebook.com/\(fbDetails["id"]!)/picture?type=large",
                            "phone": "000",
                            "device":"iPhone",
                            "sn_type":"fb",
                            "sn_id":fbDetails["id"]! as! String,
                            "token":(result?.token.tokenString)!
                        ]
                        
                        let url = "http://dev.6hands.styleru.net/user"
                        //ПОЛУЧАЮ JSON С СЕРВАКА
                        Alamofire.request(url, method: .post, parameters: params)
                            .responseJSON { response in
                                
                                //ЗАНОС В CORE DATA
                                
                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                    
                                    var jsondata = JSON(data: data)
                                    jsondata = jsondata["body"]
                                    UserDefaults.standard.setValue(jsondata["token"].string, forKey: "token")
                                    UserDefaults.standard.set(jsondata["user"]["id"].string, forKey: "id_user")
                                    var bool = true
                                    do{
                                        let task :[Person] = try context.fetch(Person.fetchRequest())
                                        for tas in task {
                                            tas.first_name = jsondata["user"]["first_name"].string
                                            tas.last_name = jsondata["user"]["last_name"].string
                                            tas.email = jsondata["user"]["email"].string
                                            tas.phone = jsondata["user"]["phone"].string
                                            tas.avatar_url = jsondata["user"]["avatar"].string
                                            for(_,subJson):(String,JSON) in jsondata["user"]["social_networks"]{
                                                if(subJson["sn"] == "vk"){
                                                    tas.vk_id = subJson["id_user"].int32Value
                                                }
                                                if(subJson["sn"] == "fb"){
                                                    tas.fb_id = subJson["id_user"].int32Value
                                                }
                                            }
                                            
                                            bool = false
                                            var warning = "The user has already registered: "
                                            warning += tas.first_name!+" "
                                            warning += tas.email!+" "
                                            warning += tas.vk_id.description
                                            print(warning)
                                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                        }
                                    }
                                    catch{
                                        
                                    }
                                    if bool {
                                        let user = Person(context: context)
                                        user.first_name = jsondata["user"]["first_name"].string
                                        user.last_name = jsondata["user"]["last_name"].string
                                        user.email = jsondata["user"]["email"].string
                                        user.phone = jsondata["user"]["phone"].string
                                        print("User has been added!")
                                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                    }

                                
                                }}
                        
                    
                    })
                     fbLoginManager.logOut()
                }
            }
        })
    }


func getFBUserData(){
    let request = FBSDKGraphRequest(graphPath: "me", parameters:["fields": "id,first_name, last_name, email"])
    
    request?.start {
        (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
        if error != nil{
           
            print(error)}
        else {
       fbDetails = result as! NSDictionary
       
        }
    }

}

   










