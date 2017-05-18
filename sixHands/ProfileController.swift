//
//  ProfileController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 23.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData
import Alamofire
import SwiftyJSON
import RealmSwift

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let realm = try! Realm()
    var flats = [Flat]()
    let api = API()
    typealias JSONStandard = [String : AnyObject]
    let table = UITableView()
    let refreshControl = UIRefreshControl()
    var id = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        let per = realm.object(ofType: person.self, forPrimaryKey: 1)
        //parameters for request & request
        let params = "&parameters=%5B%7B%22key%22%3A%22id_user%22%2C%22value%22%3A%22\(UserDefaults.standard.value(forKey: "id_user")!))%22%2C%20%22criterion%22%3A%22single%22%7D%5D"
        
        //get(sorting: "last", parameters: params, amount: 20)
        

        //view bounds
        let screen = self.view.frame
        
        tabBarController?.tabBar.isHidden = false

     
        
        //gray bar
        let grayBar = UIView()
        grayBar.frame = CGRect(x: 0.0, y: 0.0, width: screen.width, height: 20.0)
        grayBar.backgroundColor = UIColor.black
        grayBar.alpha = 0.37
        self.view.addSubview(grayBar)
        
        //profile photo
        let avatar = UIImageView()
        avatar.frame = CGRect(x: screen.maxX - 15.0 - screen.height * 0.09, y: screen.minY + 40.0, width: screen.height * 0.09, height: screen.height * 0.09)
        avatar.sd_setImage(with: URL(string: (per?.avatar_url)!))
        
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = avatar.frame.size.width/2
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        self.view.addSubview(avatar)
        
        //name label
        let name = UILabel()
        name.frame = CGRect(x: screen.minX + 15.0, y: screen.minY + 40.0, width: 172.0, height: 36.0)
        name.text = per?.first_name
        name.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightHeavy)
        name.textColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
        self.view.addSubview(name)
        
        //change button
        let changeButton = UIButton()
        changeButton.frame = CGRect(x: 15.0, y: name.frame.maxY, width: 123.0, height: 17.0)
        changeButton.addTarget(self, action: #selector(ProfileController.changeButtonAction), for: .touchUpInside)
        changeButton.backgroundColor = UIColor.clear
        changeButton.setTitle("Изменить данные", for: .normal)
        changeButton.setTitleColor(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1), for: .normal)
        changeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(changeButton)
        
        //VK button
        let vkButton = UIButton()
        
        if (per?.vk_id)! != "" {
            vkButton.frame = CGRect(x: 15.0, y: changeButton.frame.maxY + 25.0, width: 34.0, height: 34.0)
            vkButton.setTitle("VK", for: .normal)
        } else {
            vkButton.frame = CGRect(x: 15.0, y: changeButton.frame.maxY + 25.0, width: 60.0, height: 34.0)
            vkButton.setTitle("+ VK", for: .normal)
        }
        
        vkButton.addTarget(self, action: #selector(ProfileController.vkButtonAction), for: .touchUpInside)
        vkButton.backgroundColor = UIColor(red: 80/255, green: 114/255, blue: 153/255, alpha: 1)
        vkButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        vkButton.setTitleColor(UIColor.white, for: .normal)
        vkButton.layer.masksToBounds = false
        vkButton.layer.cornerRadius = vkButton.frame.size.height/2
        vkButton.clipsToBounds = true
        //vkButton.setImage(#imageLiteral(resourceName: "vk"), for: .normal)
        self.view.addSubview(vkButton)
        
        //FB button
        let fbButton = UIButton()
        
        if (per?.fb_id)! != "" {
            fbButton.frame = CGRect(x: vkButton.frame.maxX + 6, y: changeButton.frame.maxY + 25.0, width: 34.0, height: 34.0)
            fbButton.setTitle("FB", for: .normal)
        } else {
            fbButton.frame = CGRect(x: vkButton.frame.maxX + 6, y: changeButton.frame.maxY + 25.0, width: 116.0, height: 34.0)
            fbButton.setTitle("+ Facebook", for: .normal)
        }
    
        fbButton.addTarget(self, action: #selector(ProfileController.fbButtonAction), for: .touchUpInside)
        fbButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        fbButton.layer.masksToBounds = false
        fbButton.layer.cornerRadius = fbButton.frame.size.height/2
        fbButton.clipsToBounds = true
        fbButton.setTitleColor(UIColor.white, for: .normal)
        fbButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(fbButton)
        
        //rent button
        let rentButton = UIButton()
        rentButton.frame = CGRect(x: 15.0, y: screen.maxY - 30.0 - 49.0 - 44.0, width: screen.width - 30.0, height: 55.0)
        rentButton.addTarget(self, action: #selector(ProfileController.rentButtonAction), for: .touchUpInside)
        rentButton.backgroundColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
        rentButton.setTitle("СДАТЬ КВАРТИРУ", for: .normal)
        rentButton.setTitleColor(UIColor.white, for: .normal)
        rentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium)
        self.view.addSubview(rentButton)
        
        //tableView
        table.frame = CGRect(x: 0.0, y: vkButton.frame.maxY + 15.0, width: screen.width, height: screen.height - 167.0 - 124.0)
        table.rowHeight = screen.height * 0.375
        table.delegate = self
        table.dataSource = self
        table.register(FlatViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorInset.left = 15.0
        table.separatorInset.right = 15.0
        self.view.addSubview(table)
        
        //pull
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(ProfileController.refresh), for: UIControlEvents.valueChanged)
        self.table.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = self.table.indexPathForSelectedRow
        {
            self.table.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func refresh() {
        print("refresh...")
        flats = []
        let params = "&parameters=%5B%7B%22key%22%3A%22id_user%22%2C%22value%22%3A%22\(UserDefaults.standard.value(forKey: "id_user")!)%22%2C%20%22criterion%22%3A%22single%22%7D%5D"
        //get(sorting: "all", parameters: params, amount: 20)
        self.table.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    //action for bar button
    func settingsButtonAction() {
        print("Settings button tapped!")
    }
    
    //action for change button
    func changeButtonAction() {
        print("Change button tapped!")
    }
    
    //action for vk button
    func vkButtonAction() {
        print("vk button tapped!")
    }
    
    //action for vk button
    func fbButtonAction() {
        print("fb button tapped!")
         
    }
    //action for vk button
    func rentButtonAction() {
        print("rent button tapped!")
        performSegue(withIdentifier: "rent", sender: self)
    }
    
    @IBAction func cancelRent(segue: UIStoryboardSegue) {}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlatViewCell
        
        //view bounds
        let screen = self.view.frame
        
        //image
        cell.flat.sd_setImage(with: URL(string : flats[indexPath.row].imageOfFlat[0]))
        cell.flat.frame = CGRect(x: 15.0, y: 10.0, width: screen.width - 30.0, height: tableView.rowHeight * 0.7)
        cell.flat.contentMode = .scaleToFill
        
        //price
        cell.priceLabel.text = "\(flats[indexPath.row].flatPrice) Р"
        cell.priceLabel.textColor = UIColor.white
        cell.priceLabel.textAlignment = .center
        cell.priceLabel.font = UIFont(name: "Lato-Medium", size: 16.0)
        cell.priceLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.36)
        cell.priceLabel.frame = CGRect(x: screen.maxX - screen.height * 0.15 - 15.0, y: cell.flat.frame.minY + screen.height * 0.2, width: screen.height * 0.15, height: screen.height * 0.056)
        
        //subway
        cell.subwayLabel.text = "\(flats[indexPath.row].flatSubway)"
        cell.subwayLabel.textColor = UIColor.black
        cell.subwayLabel.font = UIFont.systemFont(ofSize: 14.0)
        cell.subwayLabel.frame = CGRect(x: 15.0, y: cell.flat.frame.maxY + screen.height * 0.009, width: screen.height * 0.276, height: screen.height * 0.032)
        cell.subwayLabel.adjustsFontSizeToFitWidth = true
        
        //rooms
        cell.rooms.text = "\(flats[indexPath.row].numberOfRoomsInFlat)-комн."
        cell.rooms.textColor = UIColor.black
        cell.rooms.font = UIFont.systemFont(ofSize: 14.0)
        cell.rooms.frame = CGRect(x: cell.subwayLabel.frame.maxX + 17.0, y: cell.flat.frame.maxY + screen.height * 0.009, width: screen.height * 0.143, height: screen.height * 0.032)
        cell.rooms.adjustsFontSizeToFitWidth = true
        
        //views
        cell.views.text = "Просмотров: \(flats[indexPath.row].views)"
        cell.views.textColor = UIColor.black
        cell.views.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightLight)
        cell.views.frame = CGRect(x: 15.0, y: cell.subwayLabel.frame.maxY + screen.height * 0.009, width: screen.height * 0.176, height: screen.height * 0.026)
        cell.views.adjustsFontSizeToFitWidth = true
        
        //new views
        cell.new.text = "Новых: \(flats[indexPath.row].newView)"
        cell.new.textColor = UIColor(red: 72/255, green: 218/255, blue: 200/255, alpha: 1)
        cell.new.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightLight)
        cell.new.frame = CGRect(x: cell.views.frame.maxX + 11.0, y: cell.subwayLabel.frame.maxY + screen.height * 0.009, width: screen.height * 0.123, height: screen.height * 0.026)
        cell.new.adjustsFontSizeToFitWidth = true
        
        //edit button
        let size = screen.width * 0.09
        cell.edit.frame = CGRect(x: screen.width - 15.0 - size, y: cell.flat.frame.maxY + screen.height * 0.009, width: size, height: size)
        cell.edit.setImage(#imageLiteral(resourceName: "Edit"), for: .normal)
        cell.edit.tag = Int(flats[indexPath.row].flat_id)!
        cell.edit.addTarget(self, action: #selector(ProfileController.edit(_:)), for: .touchUpInside)
        
        cell.switchButton.isHidden = true
        
        
        return cell
    }
    
    func edit(_ sender: UIButton) {
        id = "\(sender.tag)"
        performSegue(withIdentifier: "editFlat", sender: self)
    }
    
    @IBAction func fromSingleFlatToProfile(segue: UIStoryboardSegue) {}
    @IBAction func fromEditToProfile(segue: UIStoryboardSegue) {}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFlat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFlat" {
            let VC = segue.destination as! FlatViewController
            let indexPath = self.table.indexPathForSelectedRow
            VC.flat_id = flats[(indexPath?.row)!].flat_id
            VC.segue = "profile"
        } else if segue.identifier == "editFlat" {
            let VC1 = segue.destination as! EditFlatController
            VC1.flat_id = id
            VC1.segue = "profile"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}
