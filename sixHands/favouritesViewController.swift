//
//  favouritesViewController.swift
//  sixHands
//
//  Created by Илья on 09.07.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class favouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var flats = [Flat]()
    let screenSize: CGRect = UIScreen.main.bounds
    let api = API()
    let refreshControl = UIRefreshControl()
    var offsetInc = 10
    let amount = 10
    var id = String()
    let internetLabel = UILabel()
    @IBOutlet var favouritesLabel: UILabel!
    @IBOutlet var listOfFlatsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
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
        
        
        listOfFlatsTableView.rowHeight = screenSize.height * 0.4
        
        favouritesLabel.bounds = CGRect(x:0, y:0 , width: screenSize.width * 0.8, height: 30)
        favouritesLabel.center = CGPoint(x: favouritesLabel.bounds.width/2 + screenSize.width/2 - screenSize.width * 0.91466 / 2, y: (screenSize.height * 0.16 - 49)/2 + UIApplication.shared.statusBarFrame.height)
        
        
        
        listOfFlatsTableView.frame = CGRect(x: 0, y: screenSize.height * 0.16 - 49, width: screenSize.width, height: screenSize.height * 0.84)
        
        listOfFlatsTableView.separatorInset.left = 15.0
        listOfFlatsTableView.separatorInset.right = 15.0
        
        //pull
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(ListOfFlatsController.refresh), for: UIControlEvents.valueChanged)
        self.listOfFlatsTableView?.addSubview(refreshControl)
        checkInternet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func refresh() {
        checkInternet()
        print("refresh...")
        flats = []
        api.flatsFilter(offset: 0, amount: amount,select: "favourites", parameters: "[]") { (i) in
            self.flats += i
            self.listOfFlatsTableView.isUserInteractionEnabled = true
            if self.flats.isEmpty {
                self.noFavourites()
            }
            OperationQueue.main.addOperation({()-> Void in
                
                self.listOfFlatsTableView.reloadData()
            })
            
        }
        offsetInc = amount
        self.listOfFlatsTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    func mutual(_ sender: UIButton) {
        id = "\(sender.tag)"
        performSegue(withIdentifier: "mutual2", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "favouriteFlat"{
            let VC = segue.destination as! FlatViewController
            let indexPath = self.listOfFlatsTableView.indexPathForSelectedRow
            VC.flat_id = flats[(indexPath?.row)!].flat_id
            VC.segue = "favourite"
        } else if segue.identifier == "mutual2"{
            let VC1 = segue.destination as! MutualFriendsViewController
            VC1.flat_id = id
            VC1.segue = "favourite"
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        view.viewWithTag(1)?.removeFromSuperview()
        view.viewWithTag(2)?.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
      
        flats = []
        api.flatsFilter(offset: 0, amount: amount,select: "favourites", parameters: "[]") { (i) in
            self.flats += i
            self.listOfFlatsTableView.isUserInteractionEnabled = true
            if self.flats.isEmpty {
                self.noFavourites()
            }
            OperationQueue.main.addOperation({()-> Void in
                
                self.listOfFlatsTableView.reloadData()
            })
            
        }}
    
    func checkInternet(){
        if !ConnectionCheck.isConnectedToNetwork() {
            let image = UIImageView()
            image.image = #imageLiteral(resourceName: "attentionSignOutline")
            image.frame = CGRect(x: 10, y: 10, width: 16, height: 16)
            internetLabel.frame = CGRect(x: 0, y: listOfFlatsTableView.frame.minY, width: self.screenSize.width, height: 35)
            internetLabel.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 0.9)
            internetLabel.text = "Отсутствует подключение к интернету"
            internetLabel.font = UIFont(name: ".SFUIText-Med", size: 16)
            internetLabel.textColor = UIColor.white
            internetLabel.textAlignment = .center
            internetLabel.addSubview(image)
            view.addSubview(internetLabel)
        }
        else{
            internetLabel.removeFromSuperview()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlatViewCell", for: indexPath) as! FlatViewCell
        
        
        //CONSTRAINTS
        cell.flatImage.bounds = CGRect(x: 0, y: 0.0, width: screenSize.width * 0.91466 , height: screenSize.height * 0.27436282 )
        cell.flatImage.center = CGPoint(x: cell.bounds.width / 2, y: cell.flatImage.frame.height/2 + 20.0)
        
        cell.subway.center = CGPoint(x:cell.flatImage.frame.minX+cell.subway.frame.width/2 + 4, y: cell.flatImage.frame.maxY + cell.subway.frame.height )
        cell.mutualFriends.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.3 , height: screenSize.height * 0.03)
        cell.mutualFriends.center = CGPoint(x:cell.flatImage.frame.minX+cell.mutualFriends.frame.width/2 + 4, y: cell.subway.frame.maxY+20)
       
        
        cell.price.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.25066 , height: screenSize.height * 0.05997)
        cell.price.center = CGPoint(x:cell.flatImage.frame.maxX-cell.price.frame.width/2, y:cell.flatImage.frame.height * 0.95)
        
        cell.subway.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.3 , height: screenSize.height * 0.02698)
        cell.subway.center = CGPoint(x:cell.flatImage.frame.minX+cell.subway.frame.width/2 + 4, y: cell.flatImage.frame.maxY + cell.subway.frame.height + 5.0)
        //
        cell.numberOfRooms.bounds = CGRect(x: 0, y: 0, width:screenSize.width * 0.3, height: screenSize.height * 0.02698)
        cell.numberOfRooms.center = CGPoint(x:cell.subway.frame.maxX+10+cell.numberOfRooms.frame.width/2, y:cell.flatImage.frame.maxY + cell.subway.frame.height + 5.0)
        //
        cell.dot.layer.cornerRadius = cell.dot.frame.size.width / 2
        //
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
            
            cell.separator.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
            
        } else {
            cell.separator.backgroundColor = UIColor.clear
        }
        
        
        //END OF CONSTRAINTS
        cell.mutualFriends.setTitle(flats[indexPath.row].flatMutualFriends, for: .normal)
        cell.subway.text = Subway.getStation(id:flats[indexPath.row].subwayId ).station
        cell.numberOfRooms.text = "\(flats[indexPath.row].numberOfRoomsInFlat)-комн."
        //FOR DOT
        cell.subway.sizeToFit()
        cell.dot.center = CGPoint(x: cell.subway.frame.maxX+10, y: cell.subway.frame.midY)
        cell.numberOfRooms.frame = CGRect(x: cell.dot.frame.maxX+9, y: cell.numberOfRooms.frame.minY, width: screenSize.width * 0.3, height: screenSize.height * 0.02698)
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
   
    @IBAction func fromSingleFlatToFavourites(segue: UIStoryboardSegue) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"favouriteFlat", sender: self)
    }
    func noFavourites(){
         listOfFlatsTableView.isUserInteractionEnabled = false
        let description = UITextView()
        description.frame = CGRect(x: favouritesLabel.frame.minX - 4, y: favouritesLabel.frame.maxY + 30, width: screenSize.width*0.9, height: 45)
        description.font = UIFont(name: ".SFUIText-Light", size: 14)
        description.textColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0)
        description.textAlignment = .left
        description.text = "Добавляйте понравившиеся квартиры в\nзакладки, чтобы потом легко к ним вернуться."
        description.tag = 1
        let image = UIImageView()
        let backView = UIView()
        backView.frame = CGRect(x: screenSize.width/2, y: screenSize.height/2, width: 138, height: 18)
        backView.center = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        
        image.image = #imageLiteral(resourceName: "forma13")
        image.contentMode = .scaleAspectFill
        image.frame = CGRect(x: 0, y: 0, width: 14, height: 18)
        
        let noLabel = UILabel()
        noLabel.frame = CGRect(x: image.frame.maxX + 11, y: 0, width: 113, height: 18)
        noLabel.font = UIFont(name: ".SFUIText-Bold", size: 16)
        noLabel.textColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
        noLabel.textAlignment = .left
        noLabel.text = "Нет закладок"
        
        backView.addSubview(noLabel)
        backView.addSubview(image)
        backView.tag = 2
        
        view.addSubview(backView)
        view.addSubview(description)
    }
}
