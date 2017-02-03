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

class ListOfFlatsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  let screenSize: CGRect = UIScreen.main.bounds
   
    var flats = [Flat]()
    typealias JSONStandard = [String : AnyObject]
    
    @IBOutlet weak var listOfFlats: UILabel!
    
    @IBOutlet weak var favouritesOutlet: UIButton!
    @IBOutlet weak var popularOutlet: UIButton!
    @IBOutlet weak var newOutlet: UIButton!
    @IBAction func new(_ sender: Any) {
    }
    @IBAction func popular(_ sender: Any) {
    }
    @IBAction func favourites(_ sender: Any) {
    }
    @IBOutlet weak var listOfFlatsTableView: UITableView!
        
    
    override func viewDidLoad() {
        //let params = "%5B%7B%22key%22%3A%22id%22%2C%22value%22%3A%22307%22%2C%20%22criterion%22%3A%22single%22%7D%5D"
        update(user_id: "129", sorting: "last", parameters: "", amount: 20)
        
        //gray bar
        let grayBar = UIView()
        grayBar.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 25.0)
        grayBar.backgroundColor = UIColor.black
        grayBar.alpha = 0.37
        self.view.addSubview(grayBar)
        
        listOfFlatsTableView.delegate = self
        listOfFlatsTableView.dataSource = self
        listOfFlatsTableView.beginUpdates()
        listOfFlatsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        listOfFlatsTableView.endUpdates()
        
        
        //CONSTRAINTS:
        listOfFlatsTableView.rowHeight = screenSize.height * 0.4
        
        listOfFlats.bounds = CGRect(x:0, y:0 , width: screenSize.width * 0.8, height: screenSize.height * 0.096)
        listOfFlats.center = CGPoint(x: listOfFlats.bounds.width/2 + screenSize.width/2 - screenSize.width * 0.91466 / 2, y: screenSize.height * 0.089955)
        
        favouritesOutlet.center = CGPoint(x: screenSize.width * 0.836 , y: screenSize.height * 0.16041)
        popularOutlet.center = CGPoint(x: screenSize.width * 0.448 , y: screenSize.height * 0.16041)
        newOutlet.center = CGPoint(x: screenSize.width * 0.11333 , y: screenSize.height * 0.16041)
        
        favouritesOutlet.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.3  , height: screenSize.height * 0.0299 )
        popularOutlet.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.3, height: screenSize.height * 0.0299 )
        newOutlet.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.141333, height: screenSize.height * 0.0299)
        
        listOfFlatsTableView.center = CGPoint(x: screenSize.width/2, y: screenSize.height * 0.564467)
        listOfFlatsTableView.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.91466, height: screenSize.height * 0.70614)
        
       
        
        
        
        
        
    super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlatViewCell", for: indexPath) as! FlatViewCell
        
        
        //CONSTRAINTS
        cell.flatImage.bounds = CGRect(x: 0, y: 0.0, width: screenSize.width * 0.91466 , height: screenSize.height * 0.27436282 )
        cell.flatImage.center = CGPoint(x: cell.bounds.width / 2, y: cell.flatImage.frame.height/2 + 5.0)
        
        cell.mutualFriends.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.3 , height: screenSize.height * 0.03)
        cell.mutualFriends.center = CGPoint(x:cell.mutualFriends.frame.width / 2, y: cell.bounds.height-cell.mutualFriends.frame.height)
        
        cell.price.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.25066 , height: screenSize.height * 0.05997)
        cell.price.center = CGPoint(x:cell.bounds.width-cell.price.frame.width/2, y:cell.flatImage.frame.height * 0.7)

        cell.subway.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.429333 , height: screenSize.height * 0.02698)
        cell.subway.center = CGPoint(x:cell.subway.frame.width / 2, y: cell.flatImage.frame.maxY + cell.subway.frame.height )
        
        cell.numberOfRooms.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.17866, height: screenSize.height * 0.02698)
        cell.numberOfRooms.center = CGPoint(x:cell.subway.frame.maxX+5, y:cell.flatImage.frame.maxY + cell.subway.frame.height )
        
        
        cell.avatar.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.11733 , height: screenSize.width * 0.11733)
        cell.avatar.center = CGPoint(x:cell.bounds.width - cell.avatar.bounds.width/2 - 6,y:cell.bounds.height-(cell.bounds.height-cell.flatImage.frame.maxY)/2)
        cell.avatar.layer.masksToBounds = false
        cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width / 2
        cell.avatar.clipsToBounds = true
        cell.avatar.contentMode = .scaleAspectFill
        //END OF CONSTRAINTS
        
        cell.subway.text = "Нет пока"
        cell.mutualFriends.text = "Отсутствуют"
        cell.numberOfRooms.text = "\(flats[indexPath.row].numberOfRoomsInFlat)-комн."
        cell.price.text = "\(flats[indexPath.row].flatPrice) Р"
        cell.avatar.sd_setImage(with: URL(string : flats[indexPath.row].avatarImage))
        
        var flatImageURL : String = flats[indexPath.row].imageOfFlat
        flatImageURL = String(flatImageURL.characters.dropFirst(29))
        cell.flatImage.sd_setImage(with: URL(string : flatImageURL))
        
        
        return cell
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return flats.count
    }
    
    func update(user_id:String,sorting:String,parameters:String,amount:Int8) {
        
        let headers:HTTPHeaders = ["Token": UserDefaults.standard.object(forKey:"token") as! String]
        Alamofire.request("http://dev.6hands.styleru.net/flats/filter?id_user=\(user_id)&sorting=\(sorting)&offset=0&amount=\(amount)&parameters=\(parameters)",headers:headers).responseJSON { response in
            var jsondata = JSON(data:response.data!)["body"]
            let array = jsondata.array
            print(jsondata)
            
            if (array?.count) != nil {
                for i in 0..<array!.count{
                    let flat = Flat()
                    flat.avatarImage = jsondata[i]["avatar"].string!
                    flat.flatPrice = jsondata[i]["parameters"]["30"].string!
                    flat.flatSubway = "Пока нема"
                    flat.flatMutualFriends = "социопат"
                    flat.imageOfFlat = jsondata[i]["photos"][0]["url"].string!
                    print(flat.imageOfFlat)
                    flat.numberOfRoomsInFlat = jsondata[i]["parameters"]["31"].string!
                    self.flats.append(flat)
                
                }
            }
            OperationQueue.main.addOperation({()-> Void in
                
                self.listOfFlatsTableView.reloadData()
                
            })
            
        //self.flats = self.parseData(JSONdata: response.data!)
        }
    }

   
    
    
    
    
    
    
    

}




