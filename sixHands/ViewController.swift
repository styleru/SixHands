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
import RealmSwift
import Alamofire


@available(iOS 10.0, *)
class ViewController: UIViewController, VKSdkDelegate,VKSdkUIDelegate {
    let screenSize: CGRect = UIScreen.main.bounds
    let api = API()
    @IBOutlet weak var terms: UIButton!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet var okOutlet: UIButton!
    @IBOutlet weak var fbOutlet: UIButton!
    @IBOutlet weak var vkOutlet: UIButton!
    @IBOutlet weak var image: UIImageView!
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
        
        image.frame = CGRect(x: -screenSize.width * 0.05, y: -screenSize.height * 0.05, width: screenSize.width * 1.1, height: screenSize.height * 1.1)
        motion(toView: image, magnitude: 20)
        motion(toView: fbOutlet, magnitude: -10)
        motion(toView: vkOutlet, magnitude: -10)
        okOutlet.frame = CGRect(x: screenSize.width*0.08, y: screenSize.height*0.55, width: screenSize.width*0.8125, height: screenSize.height*0.0845)
        fbOutlet.frame = CGRect(x: okOutlet.frame.minX, y: okOutlet.frame.maxY+20, width: okOutlet.frame.width, height: okOutlet.frame.height)
        vkOutlet.frame = CGRect(x: okOutlet.frame.minX, y: fbOutlet.frame.maxY+20, width: okOutlet.frame.width, height: okOutlet.frame.height)

        okOutlet.layer.cornerRadius = okOutlet.frame.height/2
        fbOutlet.layer.cornerRadius = fbOutlet.frame.height/2
        vkOutlet.layer.cornerRadius = vkOutlet.frame.height/2
        switch (screenSize.width){
        case 320 : vkOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                fbOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        case 375 : vkOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            fbOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        case 414: vkOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 21)
            fbOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 21)
        default : vkOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            fbOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        }
        label1.frame = CGRect(x: fbOutlet.frame.minX+5, y: screenSize.height*0.1654, width: screenSize.width*0.63125, height: screenSize.height*0.0704)
        label2.frame = CGRect(x: fbOutlet.frame.minX+5, y: screenSize.height*0.2658, width: screenSize.width*0.70625, height: screenSize.height*0.1109)
        label2.text = "Сервис безопасной\nсдачи и аренды жилой\nнедвижимости"
        label3.frame = CGRect(x: fbOutlet.frame.minX+5, y: screenSize.height*0.91, width: screenSize.width*0.78125, height: 15)
        terms.frame = CGRect(x: fbOutlet.frame.minX+5, y: label3.frame.maxY, width: screenSize.width*0.70625, height: 15)
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
    
    
    @IBAction func okLogin(_ sender: Any) {
        OKSDK.authorize(withPermissions: ["LONG_ACCESS_TOKEN","PHOTO_CONTENT","VALUABLE_ACCESS","GET_EMAIL"], success: { (result) in
            let Data = result as! NSArray
            let token = Data[0]
            print(result)
            print(token)
            OKSDK.invokeMethod("users.getCurrentUser", arguments: [:] , success: { (data) in
                let Data = data as! NSDictionary
                print(data)
                let name = Data["first_name"]
                let age = Data["age"]
                
                
                let params:Parameters = ["first_name": Data["first_name"] as! String,
                                         "last_name":Data["last_name"]! as! String ,
                                         "email":Data["email"]! as! String ,
                                         "avatar": Data["pic_3"] as! String ,
                                         "phone": "000",
                                         "device":"iPhone",
                                         "sn_type":"ok",
                                         "sn_id":Data["uid"]! as! String,
                                         "token": token]
                
                
                let url = "http://6hand.anti.school/user"
                Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
                    
                    //ЗАНОС В CORE DATA
                    
                    if let data = response.data {
                        var jsondata = JSON(data: data)
                        let per = person()
                        per.token = jsondata["token"].string!
                        
                        
                        if jsondata != nil{
                            print(jsondata)
                            per.first_name = jsondata["user"]["first_name"].string ?? ""
                            per.last_name = jsondata["user"]["last_name"].string ?? ""
                            per.email = jsondata["user"]["email"].string ?? ""
                            per.phone = jsondata["user"]["phone"].string ?? ""
                            per.avatar_url = jsondata["user"]["avatar"].string ?? ""
                            per.ok_id = jsondata["user"]["social_networks"][0]["id_user"].string ?? ""
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
            }, error: { (error) in
                print("ERROR:\(error)")
            })
        }) { (error) in
            print("error:\(error)")
        }
    }
    
    @IBAction func fbLogin(_ sender: UIButton) {
        FBLogin()

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
            print(resultToken!)
            
            let getData: VKRequest =  VKApi.users().get(["fields": "photo_max,contacts"])
            
            
            getData.execute(
                resultBlock: {
                    (response) -> Void in
                    
                    let user: VKUser = (response?.parsedModel as! VKUsersArray).firstObject()!
                    
                    self.first_name = user.first_name
                    self.last_name = user.last_name
                    self.avatar = user.photo_max
                    self.sn_id = result.token.userId
                    
                    let listUrlString = "http://6hand.anti.school/user"
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
                    print(postString)
                    
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
                            let per = person()

                            per.token = jsondata["token"].string!
                            self.api.headers = ["Token": per.token]
                            if jsondata != JSON.null {
                                print(jsondata)
                                per.first_name = jsondata["user"]["first_name"].string!
                                per.last_name = jsondata["user"]["last_name"].string!
                                per.email = jsondata["user"]["email"].string!
                                per.phone = jsondata["user"]["phone"].string!
                                per.avatar_url = jsondata["user"]["avatar"].string!
                                per.vk_id = jsondata["user"]["social_networks"][0]["id_user"].string!
                                per.user_id = Int(jsondata["user"]["id"].string!)!
                                UserDefaults.standard.set(per.user_id, forKey: "id_user")
                                UserDefaults.standard.set(per.token, forKey: "Token")
                                UserDefaults.standard.synchronize()
                            }
                            
                            DispatchQueue(label: "background").async {
                                autoreleasepool {
                                    let realm = try! Realm()
                                    try! realm.write {
                                        realm.add(per, update: true)
                                    }
                                }
                            }


                        }
                        let delayTime = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        DispatchQueue.main.async { [unowned self] in
                        //self.performSegue(withIdentifier: "login", sender: self)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let afterLoginTB = storyboard.instantiateViewController(withIdentifier: "afterLogin") as! UITabBarController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = afterLoginTB
                            }}
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
    func motion(toView view:UIView,magnitude: Float){
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion,yMotion]
        view.addMotionEffect(group)
        }
    

}

