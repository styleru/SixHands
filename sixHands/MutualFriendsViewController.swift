//
//  MutualFriendsViewController.swift
//  sixHands
//
//  Created by Илья on 20.03.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import SwiftyJSON

class MutualFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let screenSize: CGRect = UIScreen.main.bounds
    var flat_id = String()
    var friends = [JSON]()
    let api = API()
    var segue = String()
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var mutualFriendsTableView: UITableView!
    @IBOutlet weak var mutualFriends: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        back.frame = CGRect(x: screenSize.width*0.072, y: screenSize.height*0.0475, width: screenSize.width*0.024, height: screenSize.height*0.02548)
        mutualFriends.frame = CGRect(x: screenSize.width*0.072, y: screenSize.height*0.10794, width: screenSize.width*0.592, height: screenSize.height*0.05)
        
        mutualFriendsTableView.separatorStyle = .none
        mutualFriendsTableView.rowHeight = screenSize.height * 0.4
        back.addTarget(self, action: #selector(MutualFriendsViewController.backAction), for: .touchUpInside)
        
        api.flatsSingle(id: flat_id){(js:Any) in
            let jsondata = js as! JSON
            if jsondata["mutual_friends"].array != nil {
                self.friends = jsondata["mutual_friends"].array!
                print("friends: \(self.friends)")
                self.mutualFriendsTableView.reloadData()
            }
        }
    }
    
    func backAction() {
        if segue == "flat" {
            performSegue(withIdentifier: "toFlat", sender: self)
        } else {
            performSegue(withIdentifier: "toList", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mut", for: indexPath) as! MutualFriendsTableViewCell
        cell.fullName.text = friends[indexPath.row]["name"].string!
        cell.avatar.sd_setImage(with: URL(string: friends[indexPath.row]["photo"].string!))
        if friends[indexPath.row]["sn_type"].string! == "vk" {
            cell.sn.image = #imageLiteral(resourceName: "vkLogo")
        } else {
            cell.sn.image = #imageLiteral(resourceName: "fbLogo")
        }
        
        return cell
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
