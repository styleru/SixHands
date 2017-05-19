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
        
        let per = realm.object(ofType: person.self, forPrimaryKey: 1)
        guard var token = per?.token else{
        return
        }
        
        print("AUE:\(token.isEmpty)")
        if token.isEmpty{
        token = ""}
        
        api.tokenCheck(token: "") { (statusCode) in
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
