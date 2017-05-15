//
//  Entry.swift
//  sixHands
//
//  Created by Nikita Guzhva on 10/04/2017.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import RealmSwift

class Entry: UIViewController {
    let realm = try! Realm()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        let per = realm.object(ofType: person.self, forPrimaryKey: 1)
        if (per?.token == "") || (per?.token == nil) {
            DispatchQueue.main.async() {
                [unowned self] in
                self.performSegue(withIdentifier: "showAuth", sender: self)
            }
            print("no token")
        } else {
            DispatchQueue.main.async() {
                [unowned self] in
                self.performSegue(withIdentifier: "enter", sender: self)
            }
            print("entering...")
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
