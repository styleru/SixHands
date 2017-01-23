//
//  ProfileController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 23.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view bounds
        let screen = self.view.frame

        // NavigationBar configuration
        let navBar = self.navigationController?.navigationBar
        
        //remove separator
        navBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar?.shadowImage = UIImage()
        
        //set title
        navBar?.topItem?.title = "Профиль"
        
        //right Button
        let settingsButton = UIButton()
        settingsButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        settingsButton.setImage(UIImage(named: "Settings"), for: .normal)
        settingsButton.imageView?.contentMode = .scaleAspectFill
        settingsButton.addTarget(self, action: #selector(ProfileController.settingsButtonAction), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = settingsButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        //profile photo
        let avatar = UIImageView()
        avatar.frame = CGRect(x: screen.minX + 25.0, y: screen.minY + 25.0, width: 75.0, height: 75.0)
        avatar.image = UIImage(named: "2")
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = avatar.frame.size.width/2
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        self.view.addSubview(avatar)
        
        //name label
        let name = UILabel()
        name.frame = CGRect(x: avatar.frame.maxX + 40.0, y: screen.minY + 30.0, width: 100.0, height: 30.0)
        name.text = "Ryan"
        name.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        self.view.addSubview(name)
        
        //location label
        let location = UILabel()
        location.frame = CGRect(x: avatar.frame.maxX + 40.0, y: name.frame.maxY + 5.0, width: 150.0, height: 30.0)
        location.text = "Moscow, Russia"
        location.textColor = UIColor.gray
        self.view.addSubview(location)
        
        //VK button
        let vkButton = UIButton()
        vkButton.frame = CGRect(x: 0.0, y: avatar.frame.maxY + 10.0, width: screen.width / 3, height: 60.0)
        vkButton.addTarget(self, action: #selector(ProfileController.vkButtonAction), for: .touchUpInside)
        vkButton.backgroundColor = UIColor.gray
        vkButton.setTitle("VK", for: .normal)
        vkButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(vkButton)
        
        //rent button
        let rentButton = UIButton()
        rentButton.frame = CGRect(x: vkButton.frame.maxX, y: avatar.frame.maxY + 10.0, width: screen.width / 3, height: 60.0)
        rentButton.addTarget(self, action: #selector(ProfileController.rentButtonAction), for: .touchUpInside)
        rentButton.backgroundColor = UIColor.green
        rentButton.setTitle("Сдать", for: .normal)
        rentButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(rentButton)
        
        //FB button
        let fbButton = UIButton()
        fbButton.frame = CGRect(x: rentButton.frame.maxX, y: avatar.frame.maxY + 10.0, width: screen.width / 3, height: 60.0)
        fbButton.addTarget(self, action: #selector(ProfileController.fbButtonAction), for: .touchUpInside)
        fbButton.backgroundColor = UIColor.blue
        fbButton.setTitle("FB", for: .normal)
        fbButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(fbButton)
        
        //tableView
        let table = UITableView()
        table.frame = CGRect(x: 0.0, y: vkButton.frame.maxY, width: screen.width, height: screen.height - vkButton.frame.maxY - 49.0 - 64.0)
        table.rowHeight = 120.0
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorInset.left = 15.0
        table.separatorInset.right = 15.0
        self.view.addSubview(table)
        
        
    }
    
    //action for bar button
    func settingsButtonAction() {
        print("Settings button tapped!")
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
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
