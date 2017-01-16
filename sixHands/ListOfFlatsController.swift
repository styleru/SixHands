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
        super.viewDidLoad()
    }
    
    func loadFlats(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        // cell selected code here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //some shit had to be written here
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
}




