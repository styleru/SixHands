//
//  ViewController.swift
//  sixHands
//
//  Created by Владимир Марков on 11.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData



class ViewController: UIViewController, VKSdkDelegate,VKSdkUIDelegate {

    var first_name, last_name, email, phone, avatar, sn_type, device, sn_id, resultToken : String?
    var VKSDKInstance: VKSdk?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        VKSDKInstance = VKSdk.initialize(withAppId: "5446345")
        VKSDKInstance!.register(self)
        VKSDKInstance!.uiDelegate = self
        sn_type = "vk"
        device = "iphone"
        phone = "+70000000"
        
        //тест coredata
        
        //добавление
//        let People = Person(context:context)
//        People.name = "1"
//        People.surname = "2"
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//        
//        //показывание
//        do
//        {
//            let task :[Person] = try context.fetch(Person.fetchRequest())
//            for tas in task {
//                print(tas.name!)
//            }
//        }
//        catch{
//            
//        }
//        
        
        
        //конец тестов
        
    }

    @IBAction func vkLogin(_ sender: UIButton) {
        VKSdk.wakeUpSession([VK_API_LONG]) { (state, error) -> Void in
            switch (state) {
            case VKAuthorizationState.authorized:
                break
            case VKAuthorizationState.initialized:
                // User not yet authorized, proceed to next ste
                VKSdk.authorize(["friends","email"])
                break
                
            default:
                // Probably, network error occured, try call +[VKSdk wakeUpSession:completeBlock:] later
                break
            }
            
        }

    }
    
    
    
    @IBAction func fbLogin(_ sender: UIButton) {
        FBLogin()
        //getFBUserData()
        
       
    }
    
   
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        self.dismiss(animated: true, completion: nil)
        
        if result.token != nil {
            email = result.token.email
            resultToken = result.token.accessToken
            
            let getData: VKRequest =  VKApi.users().get(["fields": "photo_50,contacts"])
            
            
            getData.execute(
                resultBlock: {
                    (response) -> Void in
                    
                    let user: VKUser = (response?.parsedModel as! VKUsersArray).firstObject()!
                    
                    self.first_name = user.first_name
                    self.last_name = user.last_name
                    self.avatar = user.photo_50
                    self.sn_id = result.token.userId
                    
                    let listUrlString = "http://dev.6hands.styleru.net/user"
                    let myUrl = URL(string: listUrlString)
                    var request = URLRequest(url:myUrl!);
                    request.httpMethod = "POST"
                    var postString = "first_name=" + self.first_name!
                    postString += "&last_name=" + self.last_name!
                    postString += "&email=" + self.email!
                    postString += "&avatar=" + self.avatar!
                    postString += "&phone=" + self.phone!
                    postString += "&device=" + self.device!
                    postString += "&sn_type=" + self.sn_type!
                    postString += "&sn_id=" + self.sn_id!
                    postString += "&token=" + self.resultToken!
                    request.httpBody = postString.data(using: .utf8)
                    
                    let task = URLSession.shared.dataTask(with: request){ data, response, error in
                        guard let data = data, error == nil else{
                            print("error=\(error)")
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                            print("statusCode \(httpStatus.statusCode)")
                            print("response =\(response)")
                            }
                        let responseString = String(data: data, encoding: .utf8)
                        print("responseString = \(responseString)")
                        
                        
                        if let dataFromString = responseString?.data(using: .utf8, allowLossyConversion: false) {
                            var jsondata = JSON(data: dataFromString)
                            jsondata = jsondata["body"]
                            UserDefaults.standard.setValue(jsondata["token"].string, forKey: "token")
                            var bool = true
                            do{
                                let task :[Person] = try self.context.fetch(Person.fetchRequest())
                                for tas in task {
                                        tas.first_name = jsondata["user"]["first_name"].string
                                        tas.last_name = jsondata["user"]["last_name"].string
                                        tas.email = jsondata["user"]["email"].string
                                        tas.phone = jsondata["user"]["phone"].string
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
                                let user = Person(context: self.context)
                                user.first_name = jsondata["user"]["first_name"].string
                                user.last_name = jsondata["user"]["last_name"].string
                                user.email = jsondata["user"]["email"].string
                                user.phone = jsondata["user"]["phone"].string
                                print("User has been added!")
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            }

                        }
                        
                        
                        
                        DispatchQueue.main.async { [unowned self] in
                        self.performSegue(withIdentifier: "login", sender: self)
                        }
                    }
                    task.resume()
                    
                    
            }, errorBlock: {
                (error) -> Void in
                print("error")
                
            })
        }
            
            
        else if (result.error != nil) {
            // User canceled authorization, or occured unresolving networking error. Reset your UI to initial state and try authorize user later
            //уведомление о том, что не вошли
        }
    }
    
    
    
    
    
    
    
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
    }
    
    func vkSdkUserAuthorizationFailed() {
    }
    

}

