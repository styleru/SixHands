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

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var info = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view bounds
        let screen = self.view.frame

        //right Button
        let settingsButton = UIButton()
        settingsButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        settingsButton.setImage(UIImage(named: "Settings"), for: .normal)
        settingsButton.imageView?.contentMode = .scaleAspectFill
        settingsButton.addTarget(self, action: #selector(ProfileController.settingsButtonAction), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = settingsButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        //gray bar
        let grayBar = UIView()
        grayBar.frame = CGRect(x: 0.0, y: 0.0, width: screen.width, height: 25.0)
        grayBar.backgroundColor = UIColor.black
        grayBar.alpha = 0.37
        self.view.addSubview(grayBar)
        
        //profile photo
        let avatar = UIImageView()
        avatar.frame = CGRect(x: screen.maxX - 15.0 - screen.height * 0.09, y: screen.minY + 40.0, width: screen.height * 0.09, height: screen.height * 0.09)
        avatar.image = UIImage(named: "2")
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = avatar.frame.size.width/2
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        self.view.addSubview(avatar)
        
        //name label
        let name = UILabel()
        name.frame = CGRect(x: screen.minX + 15.0, y: screen.minY + 40.0, width: 172.0, height: 36.0)
        name.text = "Ryan"
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
        vkButton.frame = CGRect(x: 15.0, y: changeButton.frame.maxY + 25.0, width: 34.0, height: 34.0)
        vkButton.addTarget(self, action: #selector(ProfileController.vkButtonAction), for: .touchUpInside)
        /*
        vkButton.backgroundColor = UIColor(red: 80/255, green: 114/255, blue: 153/255, alpha: 1)
        vkButton.setTitle("VK", for: .normal)
        vkButton.setTitleColor(UIColor.white, for: .normal)
        vkButton.layer.masksToBounds = false
        vkButton.layer.cornerRadius = vkButton.frame.size.width/2
        vkButton.clipsToBounds = true*/
        vkButton.setImage(#imageLiteral(resourceName: "vk"), for: .normal)
        self.view.addSubview(vkButton)
        
        //FB button
        let fbButton = UIButton()
        fbButton.frame = CGRect(x: vkButton.frame.maxX + 6, y: changeButton.frame.maxY + 25.0, width: 116.0, height: 34.0)
        fbButton.addTarget(self, action: #selector(ProfileController.fbButtonAction), for: .touchUpInside)
        fbButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        fbButton.layer.masksToBounds = false
        fbButton.layer.cornerRadius = fbButton.frame.size.height/2
        fbButton.clipsToBounds = true
        fbButton.setTitle("+ Facebook", for: .normal)
        fbButton.setTitleColor(UIColor.white, for: .normal)
        fbButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(fbButton)
        
        //rent button
        let rentButton = UIButton()
        rentButton.frame = CGRect(x: 15.0, y: screen.maxY - 15.0 - 49.0 - 44.0, width: screen.width - 30.0, height: 44.0)
        rentButton.addTarget(self, action: #selector(ProfileController.rentButtonAction), for: .touchUpInside)
        rentButton.backgroundColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
        rentButton.setTitle("СДАТЬ КВАРТИРУ", for: .normal)
        rentButton.setTitleColor(UIColor.white, for: .normal)
        rentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium)
        self.view.addSubview(rentButton)
        
        //tableView
        let table = UITableView()
        table.frame = CGRect(x: 0.0, y: vkButton.frame.maxY + 15.0, width: screen.width, height: screen.height - 167.0 - 124.0)
        table.rowHeight = screen.height * 0.375
        table.delegate = self
        table.dataSource = self
        table.register(FlatViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorInset.left = 15.0
        table.separatorInset.right = 15.0
        self.view.addSubview(table)
        
        
        //get info from coredata
        do {
            info = try context.fetch(Person.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        
        print("kek: \(info[0].value(forKey: "first_name") as! String)")
        name.text = info[0].value(forKey: "first_name") as? String
        print("lol: \(info[0].value(forKey: "avatar_url") as! String)")
        avatar.sd_setImage(with: URL(string: (info[0].value(forKey: "avatar_url") as? String)!))
        
        
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
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlatViewCell
        
        //view bounds
        let screen = self.view.frame
        
        //image
        cell.flat.image = UIImage(named: "1")
        cell.flat.frame = CGRect(x: 15.0, y: 10.0, width: screen.width - 30.0, height: tableView.rowHeight * 0.7)
        cell.flat.contentMode = .scaleToFill
        
        //price
        cell.priceLabel.text = "10 000 Р"
        cell.priceLabel.textColor = UIColor.white
        cell.priceLabel.textAlignment = .center
        cell.priceLabel.font = UIFont(name: "Lato-Medium", size: 16.0)
        cell.priceLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.36)
        cell.priceLabel.frame = CGRect(x: screen.maxX - screen.height * 0.15 - 15.0, y: cell.flat.frame.minY + screen.height * 0.2, width: screen.height * 0.15, height: screen.height * 0.056)
        
        //subway
        cell.subwayLabel.text = "м. Славянский Бульвар"
        cell.subwayLabel.textColor = UIColor.black
        cell.subwayLabel.font = UIFont.systemFont(ofSize: 14.0)
        cell.subwayLabel.frame = CGRect(x: 15.0, y: cell.flat.frame.maxY + screen.height * 0.009, width: screen.height * 0.276, height: screen.height * 0.032)
        cell.subwayLabel.adjustsFontSizeToFitWidth = true
        
        //rooms
        cell.rooms.text = "2-комн.кв"
        cell.rooms.textColor = UIColor.black
        cell.rooms.font = UIFont.systemFont(ofSize: 14.0)
        cell.rooms.frame = CGRect(x: cell.subwayLabel.frame.maxX + 17.0, y: cell.flat.frame.maxY + screen.height * 0.009, width: screen.height * 0.143, height: screen.height * 0.032)
        cell.rooms.adjustsFontSizeToFitWidth = true
        
        //views
        cell.views.text = "Просмотров: 98"
        cell.views.textColor = UIColor.black
        cell.views.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightLight)
        cell.views.frame = CGRect(x: 15.0, y: cell.subwayLabel.frame.maxY + screen.height * 0.009, width: screen.height * 0.176, height: screen.height * 0.026)
        cell.views.adjustsFontSizeToFitWidth = true
        
        //new views
        cell.new.text = "Новых: 65"
        cell.new.textColor = UIColor(red: 72/255, green: 218/255, blue: 200/255, alpha: 1)
        cell.new.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightLight)
        cell.new.frame = CGRect(x: cell.views.frame.maxX + 11.0, y: cell.subwayLabel.frame.maxY + screen.height * 0.009, width: screen.height * 0.123, height: screen.height * 0.026)
        cell.new.adjustsFontSizeToFitWidth = true
        
        
        return cell
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
