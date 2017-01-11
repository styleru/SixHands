//
//  ViewController.swift
//  sixHands
//
//  Created by Владимир Марков on 11.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class ViewController: UIViewController, VKSdkDelegate,VKSdkUIDelegate {

     var first_name, last_name, email, phone, avatar, sn_type, device, sn_id, resultToken : String?
     var VKSDKInstance: VKSdk?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        VKSDKInstance = VKSdk.initialize(withAppId: "5769875")
        VKSDKInstance!.register(self)
        VKSDKInstance!.uiDelegate = self
        sn_type = "vk"
        device = "iphone"
        phone = "+70000000"
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
                    
                    let listUrlString = "https://dev.6hands.styleru.net/user"
                    let myUrl = URL(string: listUrlString)
                    var request = URLRequest(url:myUrl!);
                    request.httpMethod = "POST"
                    var postString = "first_name=" + self.first_name!
                    postString += "&last_name=" + self.last_name!
                    postString += "email=" + self.email!
                    postString += "&avatar=" + self.avatar!
                    postString += "&phone=" + self.phone!
                    postString += "&device=" + self.device!
                    postString += "sn_type=" + self.sn_type!
                    postString += "&sn_id=" + self.sn_id!
                    postString += "&token=" + self.resultToken!
                    
                    request.httpBody = postString.data(using: .utf8)
                    
                    let task = URLSession.shared.dataTask(with: request){ data, response, error in
                        guard let data = data, error == nil else{
                            print("error=\(error)")
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                            print("SHIEEET \(httpStatus.statusCode)")
                            print("response =\(response)")
                            
                        }
                        let responseString = String(data: data, encoding: .utf8)
                        print("responseString = \(responseString)")
                    }
                    task.resume()
                    
            }, errorBlock: {
                (error) -> Void in
                print("error")
                
            })
            
            
            // User successfully authorized, you may start working with VK API
            
            //            DispatchQueue.main.async {
            //            self.performSegue(withIdentifier: "login", sender: self)
            //            }
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

