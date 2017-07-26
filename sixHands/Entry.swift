//
//  Entry.swift
//  sixHands
//
//  Created by Nikita Guzhva on 10/04/2017.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class Entry: UIViewController {
    let realm = try! Realm()
    let api = API()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        print("REALM FILE:\(Realm.Configuration().fileURL)")
        api.update_subway()
        api.updateOptions()
        let per = realm.object(ofType: person.self, forPrimaryKey: 1)
        var token = String()
        if let i = per?.token{
        token = (per?.token)!
        }else{
        token = ""
        }
     
        
        api.tokenCheck(token: token) { (statusCode) in
            if (statusCode != 200) {
                DispatchQueue.main.async() {
                    [unowned self] in
                    self.performSegue(withIdentifier: "showAuth", sender: self)
                }
            } else {
                DispatchQueue.main.async() {
                    [unowned self] in
                    self.performSegue(withIdentifier: "enter", sender: self)
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    

}
