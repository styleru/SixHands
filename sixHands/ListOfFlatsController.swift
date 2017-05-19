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
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

class ListOfFlatsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    let screenSize: CGRect = UIScreen.main.bounds
    let api = API()
    var flats = [Flat]()
    typealias JSONStandard = [String : AnyObject]
    let refreshControl = UIRefreshControl()
    var offsetInc = 10
    let amount = 10
    var id = String()
    
    var dot = UIImageView()
    
    @IBOutlet weak var listOfFlats: UILabel!
    
    @IBOutlet weak var favouritesOutlet: UIButton!
    @IBOutlet weak var popularOutlet: UIButton!
    @IBOutlet weak var newOutlet: UIButton!
    @IBOutlet weak var listOfFlatsTableView: UITableView!
    
    
    override func viewDidLoad() {
                
        api.flatsFilter(offset: 0, amount: amount, parameters: "") { (i) in
            self.flats += i
            OperationQueue.main.addOperation({()-> Void in
                self.listOfFlatsTableView.reloadData()
            })

        }
        

        //update(offset:0,amount: amount)
        //DOT BETWEEN SUBWAY
        dot.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
        //gray bar
        let grayBar = UIView()
        grayBar.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 20.0)
        grayBar.backgroundColor = UIColor.black
        grayBar.alpha = 0.37
        self.view.addSubview(grayBar)
        
        listOfFlatsTableView.delegate = self
        listOfFlatsTableView.dataSource = self
        listOfFlatsTableView.beginUpdates()
        listOfFlatsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        listOfFlatsTableView.endUpdates()
        
        
        //CONSTRAINTS:
        favouritesOutlet.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.3  , height: screenSize.height * 0.0299 )
        favouritesOutlet.center = CGPoint(x: screenSize.width * 0.836 , y: screenSize.height * 0.16041)
        
        listOfFlatsTableView.rowHeight = screenSize.height * 0.4
        
        listOfFlats.bounds = CGRect(x:0, y:0 , width: screenSize.width * 0.8, height: screenSize.height * 0.096)
        listOfFlats.center = CGPoint(x: listOfFlats.bounds.width/2 + screenSize.width/2 - screenSize.width * 0.91466 / 2, y: screenSize.height * 0.089955)
        
        popularOutlet.center = CGPoint(x: screenSize.width * 0.448 , y: screenSize.height * 0.16041)
        newOutlet.center = CGPoint(x: screenSize.width * 0.11333 , y: screenSize.height * 0.16041)
        
        popularOutlet.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.3, height: screenSize.height * 0.0299 )
        newOutlet.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.141333, height: screenSize.height * 0.0299)
        
        listOfFlatsTableView.center = CGPoint(x: screenSize.width/2, y: screenSize.height * 0.564467)
        listOfFlatsTableView.bounds = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height * 0.70614)
        listOfFlatsTableView.separatorInset.left = 15.0
        listOfFlatsTableView.separatorInset.right = 15.0
        
        //pull
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(ListOfFlatsController.refresh), for: UIControlEvents.valueChanged)
        self.listOfFlatsTableView?.addSubview(refreshControl)
     
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = self.listOfFlatsTableView.indexPathForSelectedRow
        {
            self.listOfFlatsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        print("refresh...")
        flats = []
        api.flatsFilter(offset: 0, amount: amount, parameters: "") { (i) in
            self.flats += i
            OperationQueue.main.addOperation({()-> Void in
                
                self.listOfFlatsTableView.reloadData()
            })
            
        }
        offsetInc = amount
        self.listOfFlatsTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == flats.count - 1 {
            api.flatsFilter(offset: offsetInc, amount: amount, parameters: "") { (i) in
                self.flats += i
                OperationQueue.main.addOperation({()-> Void in
                    
                    self.listOfFlatsTableView.reloadData()
                })
                
            }
            offsetInc += amount
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        performSegue(withIdentifier:"singleFlat", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlatViewCell", for: indexPath) as! FlatViewCell
        
        
        //CONSTRAINTS
        cell.flatImage.bounds = CGRect(x: 0, y: 0.0, width: screenSize.width * 0.91466 , height: screenSize.height * 0.27436282 )
         cell.flatImage.center = CGPoint(x: cell.bounds.width / 2, y: cell.flatImage.frame.height/2 + 20.0)
        
        cell.subway.center = CGPoint(x:cell.flatImage.frame.minX+cell.subway.frame.width/2 + 4, y: cell.flatImage.frame.maxY + cell.subway.frame.height )
        cell.mutualFriends.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.3 , height: screenSize.height * 0.03)
        cell.mutualFriends.center = CGPoint(x:cell.flatImage.frame.minX+cell.mutualFriends.frame.width/2 + 4, y: cell.subway.frame.maxY+15)
        
        cell.price.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.25066 , height: screenSize.height * 0.05997)
        cell.price.center = CGPoint(x:cell.flatImage.frame.maxX-cell.price.frame.width/2, y:cell.flatImage.frame.height * 0.8)
        
        cell.subway.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.3 , height: screenSize.height * 0.02698)
        cell.subway.center = CGPoint(x:cell.flatImage.frame.minX+cell.subway.frame.width/2 + 4, y: cell.flatImage.frame.maxY + cell.subway.frame.height )
        
        
        
        cell.numberOfRooms.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.3, height: screenSize.height * 0.02698)
        cell.numberOfRooms.center = CGPoint(x:cell.subway.frame.maxX+10+cell.numberOfRooms.frame.width/2, y:cell.flatImage.frame.maxY + cell.subway.frame.height )
        
        
        //cell.dot.layer.cornerRadius = cell.dot.frame.size.width / 2
        cell.avatar.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.11733 , height: screenSize.width * 0.11733)
        cell.avatar.center = CGPoint(x:cell.flatImage.frame.maxX-cell.avatar.frame.width/2 - 8,y:cell.bounds.height-(cell.bounds.height-cell.flatImage.frame.maxY)/2)
        cell.avatar.layer.masksToBounds = false
        cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width / 2
        cell.avatar.clipsToBounds = true
        cell.avatar.contentMode = .scaleAspectFill
        cell.flatImage.contentMode = .scaleAspectFill
        cell.flatImage.clipsToBounds = true
        
        cell.separator.bounds = CGRect(x: 0, y: 0, width: screenSize.width-30, height: 1)
        cell.separator.center = CGPoint(x:cell.bounds.width / 2, y: 2)
        
        if indexPath.row != 0{
            if #available(iOS 10.0, *) {
                cell.separator.backgroundColor = UIColor(displayP3Red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
            } else {
                // Fallback on earlier versions
            }
        } else {
            cell.separator.backgroundColor = UIColor.clear
        }
        
        
        //END OF CONSTRAINTS
        cell.mutualFriends.setTitle(flats[indexPath.row].flatMutualFriends, for: .normal)
        cell.subway.text = "Арбатская"
        //cell.mutualFriends.text = "5 общих друзей"
        cell.numberOfRooms.text = "\(flats[indexPath.row].numberOfRoomsInFlat)-комн."
        cell.price.text = "\(flats[indexPath.row].flatPrice) ₽"
        cell.avatar.sd_setImage(with: URL(string : flats[indexPath.row].avatarImage))
        cell.mutualFriends.tag = Int(flats[indexPath.row].flat_id)!
        cell.mutualFriends.addTarget(self, action: #selector(ListOfFlatsController.mutual(_:)), for: .touchUpInside)
        
        if flats[indexPath.row].imageOfFlat.isEmpty {
        } else {
            cell.flatImage.sd_setImage(with: URL(string :flats[indexPath.row].imageOfFlat[0]))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return flats.count
    }
    
    func mutual(_ sender: UIButton) {
        id = "\(sender.tag)"
        performSegue(withIdentifier: "mutual", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "singleFlat"{
            let VC = segue.destination as! FlatViewController
            let indexPath = self.listOfFlatsTableView.indexPathForSelectedRow
            VC.flat_id = flats[(indexPath?.row)!].flat_id
            VC.segue = "list"
        } else if segue.identifier == "mutual"{
            let VC1 = segue.destination as! MutualFriendsViewController
            VC1.flat_id = id
            VC1.segue = "list"
        }
    }
    
    @IBAction func new(_ sender: UIButton) {
        flats = []
        api.flatsFilter(offset: 0, amount: amount, parameters: "") { (i) in
            self.flats += i
            OperationQueue.main.addOperation({()-> Void in
                
                self.listOfFlatsTableView.reloadData()
            })
            
        }
        newOutlet.alpha = 1
        favouritesOutlet.alpha = 0.2
        popularOutlet.alpha = 0.2
        
    }
   
    @IBAction func popular(_ sender: UIButton) {
        flats = []
        api.flatsFilter(offset: 0, amount: amount, parameters: "") { (i) in
            self.flats += i
            OperationQueue.main.addOperation({()-> Void in
                
                self.listOfFlatsTableView.reloadData()
            })
            
        }
        newOutlet.alpha = 0.2
        favouritesOutlet.alpha = 0.2
        popularOutlet.alpha = 1
        
    }
    @IBAction func favourites(_ sender: UIButton) {
        
        newOutlet.alpha = 0.2
        flats = []
        api.flatsFilter(offset: 0, amount: amount, parameters: "") { (i) in
            self.flats += i
            OperationQueue.main.addOperation({()-> Void in
                
                self.listOfFlatsTableView.reloadData()
            })
            
        }
        favouritesOutlet.alpha = 1
        popularOutlet.alpha = 0.2
       
    }
    
    @IBAction func filter(_ sender: UIButton) {
        //performSegue(withIdentifier: "", sender: self)
    }
    @IBAction func fromSingleFlat(segue: UIStoryboardSegue) {}
    @IBAction func fromMutualFriends(segue: UIStoryboardSegue) {}
    
   

}




