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



var fbDetails  = NSDictionary()
public func FBLogin(){
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logIn(withReadPermissions: ["public_profile","email"], handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions != nil && fbloginresult.grantedPermissions.contains("email"))
                {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let  afterLoginTB = storyboard.instantiateViewController(withIdentifier: "afterLogin") as! UITabBarController
                     let appDelegate = UIApplication.shared.delegate as! AppDelegate
                     appDelegate.window?.rootViewController = afterLoginTB
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
                                print(response.result.value)
                        }
                        
                    
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
            print(fbDetails["id"])
            print(fbDetails["email"])
            print(fbDetails["first_name"] as! String)
            print(fbDetails["last_name"])
            print("http://graph.facebook.com/\(fbDetails["id"]!)/picture?type=large")
            
       
        }
    }

}

   










