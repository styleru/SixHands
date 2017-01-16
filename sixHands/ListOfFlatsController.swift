//
//  ListOfFlatsController.swift
//  sixHands
//
//  Created by Владимир Марков on 16.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class ListOfFlatsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
     @IBOutlet weak var listOfFlatsTableView: UITableView!
    
    
    override func viewDidLoad() {
        listOfFlatsTableView.delegate = self
        listOfFlatsTableView.dataSource = self
//        listOfFlatsTableView.beginUpdates()
//        listOfFlatsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//        listOfFlatsTableView.endUpdates()
        super.viewDidLoad()
    }
    
    func loadFlats(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //some shit had to be written here
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
}




