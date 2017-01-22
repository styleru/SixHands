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
                    print("ВСЕ ОК")
                    print( FBSDKAccessToken.current())
                   
                    fbLoginManager.logOut()
                }
            }
        })
    }

  public func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, country, city"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                }
            })}
    

   

}








