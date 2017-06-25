//
//  FlatViewController.swift
//  sixHands
//
//  Created by Илья on 08.02.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FlatViewController: UIViewController,UIScrollViewDelegate{
    let screenSize: CGRect = UIScreen.main.bounds
    var mas = [String]()
    var id_underground = Int()
    var id_underground_line = Int()
    var flat_id = String()
    var segue = String()
    let api = API()
    var fullDesc = ""
    var shortDesc = ""
    var isAlreadyScrolled = false
    let conv = [String:String]()
    let label1ForMutualFriends = UILabel()
    let label2ForMutualFriends = UILabel()
    
    
    var dif = CGFloat()
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet var viewInScroll: UIView!
    @IBOutlet weak var convView: UIView!
    
    @IBOutlet weak var favourite: UIButton!
    @IBOutlet weak var zatemnenie2: UIView!
    @IBOutlet weak var backOutlet: UIButton!
    @IBOutlet weak var mutualFriendsOutlet: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var stairs: UILabel!
    @IBOutlet weak var square: UILabel!
    @IBOutlet weak var numberOfRooms: UILabel!
    @IBOutlet weak var aboutFlat: UITextView!
    @IBOutlet weak var navController: UIImageView!
    @IBOutlet weak var photoStairs: UIImageView!
    @IBOutlet weak var photoSquare: UIImageView!
    @IBOutlet weak var photoNumberOfRooms: UIImageView!
    @IBOutlet weak var razdelitel4: UIImageView!
    @IBOutlet weak var conveniences: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var razdelitel3: UIImageView!
    @IBOutlet weak var razdelitel2: UIImageView!
    @IBOutlet weak var razdelitel1: UIImageView!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var subwayColor: UIImageView!
    @IBOutlet weak var timeToSubway: UILabel!
    @IBOutlet weak var subway: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rentOutlet: UIButton!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var showAllOutlet: UIButton!
    
    
    override func viewDidLoad() {
        favourite.setImage(#imageLiteral(resourceName: "whiteForm"), for: .selected)
        favourite.setImage(#imageLiteral(resourceName: "Bookmark Ribbon_ffffff_100"), for: .normal)
        api.flatSingle(id: flat_id) { (flat) in
            for i in 0..<flat.imageOfFlat.count{
                
                let imageView = UIImageView()
                
                imageView.sd_setImage(with: URL(string : flat.imageOfFlat[i]))
                let x = self.view.frame.width * CGFloat(i)
                imageView.frame = CGRect(x: x, y: 0, width: self.screenSize.width, height: self.imagesScrollView.bounds.height)
                self.imagesScrollView.contentSize.width = self.screenSize.width * CGFloat(i + 1)
                imageView.clipsToBounds = true
                self.imagesScrollView.addSubview(imageView)
            }
            if flat.isFavourite == "1"{
            self.favourite.isSelected = true
            }
            self.price.text = flat.flatPrice + " ₽"
            self.timeToSubway.text = flat.time_to_subway + " мин."
            self.time.text = flat.time
            self.date.text = flat.update_date
            self.stairs.text = flat.floor + " этаж"
            self.square.text = flat.square + " м.кв."
            self.numberOfRooms.text = flat.numberOfRoomsInFlat + " ком."
            self.avatar.sd_setImage(with: URL(string :flat.avatarImage))
            self.subway.text = Subway.getStation(id: flat.subwayId).station
            self.subwayColor.backgroundColor = Subway.getStation(id: flat.subwayId).color
            //BUTTON FOR MUTUAL FRIENDS
            self.label1ForMutualFriends.attributedText = flat.buttonOwner(flat.ownerName)
            self.mutualFriendsOutlet.frame = CGRect(x: self.screenSize.width*0.061333, y: self.avatar.frame.midY - self.avatar.frame.height/2, width: self.screenSize.width/1.5, height: self.avatar.frame.height)
            self.label1ForMutualFriends.frame = CGRect(x: 0, y: 5, width: self.screenSize.width/2, height: 18)
            self.label2ForMutualFriends.text = "\(flat.flatMutualFriends) общих друзей ❯"
            self.label2ForMutualFriends.frame = CGRect(x:  self.label1ForMutualFriends.frame.minX, y:  self.label1ForMutualFriends.frame.maxY+10, width: self.screenSize.width*0.405, height: 28)
            self.label2ForMutualFriends.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
            self.label2ForMutualFriends.font = UIFont(name: ".SFUIText-Light", size: 16)
            self.label1ForMutualFriends.font = UIFont(name: ".SFUIText-Light", size: 18)
            self.label2ForMutualFriends.layer.masksToBounds = false
            self.label2ForMutualFriends.clipsToBounds = true
            self.label2ForMutualFriends.textAlignment = .center
            self.label2ForMutualFriends.sizeToFit()
            self.label2ForMutualFriends.frame.size.width += 20
            self.label2ForMutualFriends.frame.size.height += 6
            self.label2ForMutualFriends.layer.cornerRadius = self.label2ForMutualFriends.frame.height/2
            self.mutualFriendsOutlet.addSubview(self.label2ForMutualFriends)
            self.mutualFriendsOutlet.addSubview(self.label1ForMutualFriends)
            //END OF BUTTON
            
            self.adress.text = flat.address
            self.aboutFlat.text = flat.comments
            
            if self.checkText(textView: self.aboutFlat){
                self.aboutFlat.sizeToFit()
                self.showAllOutlet.isHidden = true
                self.razdelitel4.frame = CGRect(x: self.aboutFlat.frame.minX, y: self.aboutFlat.frame.maxY, width: self.screenSize.width*0.88, height: self.screenSize.height*0.002)
            }else{
                self.razdelitel4.frame = CGRect(x: self.aboutFlat.frame.minX, y: self.showAllOutlet.frame.maxY + self.screenSize.height*0.02338, width: self.screenSize.width*0.88, height: self.screenSize.height*0.002)}
            
            self.conveniences.frame = CGRect(x: self.showAllOutlet.frame.minX, y: self.razdelitel4.frame.maxY+self.screenSize.height*0.02338, width: self.screenSize.width*0.277, height: self.screenSize.height*0.017991)
            self.convView.frame = CGRect(x: 0, y: self.conveniences.frame.maxY, width: self.screenSize.width, height: 0)
            
            self.api.options(options: flat.options, completionHandler: { (opt) in
                
                var count:CGFloat = 15
                for option in opt {
                    let image = UIImageView()
                    let label = UILabel()
                    image.frame = CGRect(x: self.conveniences.frame.minX, y:count, width: 30, height: 30)
                    label.frame = CGRect(x: image.frame.maxX+20, y: image.frame.midY-9, width: self.screenSize.width/1.5, height: 18)
                    
                    count += 45
                    label.textAlignment = .left
                    label.textColor = UIColor(red: 62/255, green: 50/255, blue: 80/255, alpha: 1)
                    label.font = UIFont(name: ".SFUIText-Light", size: 16)
                    label.text = option.name
                    image.contentMode = .scaleAspectFill
                    image.sd_setImage(with: URL(string : option.icon))
                    self.convView.frame.size.height = count
                    self.convView.addSubview(label)
                    self.convView.addSubview(image)
                    
                }
                self.scrollView.contentSize.height = self.convView.frame.maxY+60
            })
            
            
        }
        
        
        
        scrollView.delegate = self
        
        backOutlet.addTarget(self, action: #selector(FlatViewController.backAction), for: .touchUpInside)
        
        if segue == "list" {
            rentOutlet.setTitle("Снять квартиру", for: .normal)
        } else {
            rentOutlet.setTitle("Редактировать квартиру", for: .normal)
        }
        
        //Font of adress
        switch (screenSize.width){
        case 320 : adress.font = UIFont.systemFont(ofSize: 20)
        case 375 : adress.font = UIFont.systemFont(ofSize: 30)
        case 414: adress.font = UIFont.systemFont(ofSize: 32)
        default : adress.font = UIFont.systemFont(ofSize: 25)
        }
        
        
        
        
        //CONSTRAINTS
        imagesScrollView.bounds = CGRect(x: 0, y: 0, width: screenSize.width , height: screenSize.height * 0.38 )
        imagesScrollView.center = CGPoint(x: screenSize.width/2, y: imagesScrollView.frame.height/2)
        
        
        
        backOutlet.bounds = CGRect(x: 0, y: 0, width: 30 , height: 30 )
        backOutlet.center = CGPoint(x: screenSize.width*0.1 , y: screenSize.width*0.1)
        rentOutlet.bounds = CGRect(x: 0, y: 0, width: screenSize.width , height: screenSize.height * 0.08245877 )
        rentOutlet.center = CGPoint(x: screenSize.width/2 , y: screenSize.height - rentOutlet.frame.height/2)
        adress.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.6, height: screenSize.height * 0.12 )
        adress.center = CGPoint(x: screenSize.width * 0.35, y: screenSize.height * 0.46176)
        time.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.2026667, height: screenSize.height * 0.0254 )
        time.center = CGPoint(x: screenSize.width * 0.82666, y: screenSize.height * 0.47601199)
        date.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.3, height: screenSize.height * 0.0254 )
        date.center = CGPoint(x: time.frame.maxX - date.frame.width/2, y: screenSize.height * 0.44302849)
        subwayColor.bounds = CGRect(x: 0, y: 0, width: 12, height:12)
        subwayColor.center = CGPoint(x:adress.frame.minX + subwayColor.frame.width/2, y: screenSize.height * 0.5457)
        subway.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.5, height: screenSize.height * 0.03 )
        subway.center = CGPoint(x: subwayColor.frame.maxX + subway.frame.width/2 + 5, y: screenSize.height * 0.5457)
        
        timeToSubway.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.17, height: screenSize.width * 0.06)
        timeImage.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.032, height: screenSize.width * 0.032 )
        timeToSubway.center = CGPoint(x: time.frame.maxX - timeToSubway.frame.width/2 , y: screenSize.height * 0.5457)
        timeImage.center = CGPoint(x: timeToSubway.frame.minX, y: screenSize.height * 0.5457)
        
        
        
        navController.frame = CGRect(x: 0, y: -screenSize.height*0.09, width: screenSize.width, height: screenSize.height*0.09)
        navController.layer.shadowColor = UIColor.black.cgColor
        navController.layer.shadowOffset = CGSize.zero
        navController.layer.shadowOpacity = 0.7
        navController.layer.shadowRadius = 10
        
        
        
        timeToSubway.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.165, height: screenSize.width * 0.06)
        timeToSubway.center = CGPoint(x: time.frame.maxX - timeToSubway.frame.width/2, y: screenSize.height * 0.5457)
        timeImage.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.032, height: screenSize.width * 0.032 )
        timeImage.center = CGPoint(x: timeToSubway.frame.minX - 12, y: screenSize.height * 0.5457)
        
        razdelitel1.bounds = CGRect(x: 0, y: 0, width: screenSize.width*0.88, height: screenSize.height*0.002)
        razdelitel1.center = CGPoint(x: screenSize.width/2, y: screenSize.height*0.58)
        photoSquare.bounds = CGRect(x: 0, y: 0, width: screenSize.width*0.08, height: screenSize.width*0.08)
        photoStairs.bounds = CGRect(x: 0, y: 0, width: screenSize.width*0.08, height: screenSize.width*0.08)
        photoNumberOfRooms.bounds = CGRect(x: 0, y: 0, width: screenSize.width*0.08, height: screenSize.width*0.08)
        photoSquare.center = CGPoint(x: screenSize.width/2, y: razdelitel1.frame.maxY + screenSize.height*0.04)
        photoStairs.center = CGPoint(x: screenSize.width*5/6, y: razdelitel1.frame.maxY + screenSize.height*0.04)
        photoNumberOfRooms.center = CGPoint(x: screenSize.width/6, y: razdelitel1.frame.maxY + screenSize.height*0.04)
        square.bounds = CGRect(x: 0, y: 0, width: screenSize.width*0.2, height: screenSize.height * 0.025487)
        square.center = CGPoint(x: screenSize.width/2, y: photoSquare.frame.maxY + screenSize.height*0.04)
        stairs.bounds = CGRect(x: 0, y: 0, width: screenSize.width*0.17, height: screenSize.height * 0.025487)
        stairs.center = CGPoint(x: screenSize.width*5/6, y: photoSquare.frame.maxY + screenSize.height*0.04)
        numberOfRooms.bounds = CGRect(x: 0, y: 0, width: screenSize.width*0.17, height: screenSize.height * 0.025487)
        numberOfRooms.center = CGPoint(x: screenSize.width/6, y: photoSquare.frame.maxY + screenSize.height*0.04)
        razdelitel2.bounds = CGRect(x: 0, y: 0, width: screenSize.width*0.88, height: screenSize.height*0.002)
        razdelitel2.center = CGPoint(x: screenSize.width/2, y: square.frame.maxY + screenSize.height * 0.02)
        avatar.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.174, height: screenSize.width * 0.174)
        avatar.center = CGPoint(x: screenSize.width*0.846666, y: razdelitel2.frame.maxY + screenSize.height * 0.0809)
        mutualFriendsOutlet.bounds = CGRect(x: 0, y: 0, width: screenSize.width*0.4, height: screenSize.height*0.07)
        mutualFriendsOutlet.center = CGPoint(x: screenSize.width * 0.26666, y: razdelitel2.frame.maxY + screenSize.height * 0.0809)
        price.bounds = CGRect(x: 0, y: 0, width: screenSize.width/3 , height: screenSize.height * 0.06 )
        price.center = CGPoint(x: screenSize.width-price.bounds.width/2 , y:screenSize.height*0.29 + price.bounds.height/2)
        
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.clipsToBounds = true
        subwayColor.layer.masksToBounds = false
        subwayColor.layer.cornerRadius = 6
        subwayColor.clipsToBounds = true
        favourite.bounds = CGRect(x: 0, y: 0, width: 30 , height: 30 )
        favourite.center = CGPoint(x: screenSize.width-screenSize.width*0.1 , y: screenSize.width*0.1)
        
        razdelitel3.frame = CGRect(x: razdelitel2.frame.minX, y: avatar.frame.midY+screenSize.height * 0.0809, width: screenSize.width*0.88, height: screenSize.height*0.002)
        
        about.frame = CGRect(x: razdelitel2.frame.minX, y: razdelitel3.frame.maxY+screenSize.height*0.02338, width: screenSize.width*0.277, height: screenSize.height*0.017991)
        if screenSize.width == 375{
            aboutFlat.frame = CGRect(x: about.frame.minX-5, y: about.frame.maxY+screenSize.height*0.017, width: screenSize.width*0.845333, height: screenSize.height*0.16)}else if screenSize.width == 414{
            aboutFlat.frame = CGRect(x: about.frame.minX-5, y: about.frame.maxY+screenSize.height*0.017, width: screenSize.width*0.845333, height: screenSize.height*0.165)
        }
        showAllOutlet.frame = CGRect(x: razdelitel3.frame.minX, y: aboutFlat.frame.maxY, width: screenSize.width*0.5, height: screenSize.height*0.02)
        
        razdelitel4.frame = CGRect(x: showAllOutlet.frame.minX, y: showAllOutlet.frame.maxY + screenSize.height*0.02338 , width: screenSize.width*0.88, height: screenSize.height*0.002)
        conveniences.frame = CGRect(x: showAllOutlet.frame.minX, y: razdelitel4.frame.maxY+screenSize.height*0.02338, width: screenSize.width*0.277, height: screenSize.height*0.017991)
        convView.frame = CGRect(x: 0, y: conveniences.frame.maxY, width: screenSize.width, height: screenSize.height*0.022*0)
        
        scrollView.addSubview(showAllOutlet)
        zatemnenie2.frame = CGRect(x: 0, y:0 , width: screenSize.width, height: screenSize.height*0.31784)
        
        
        //GRADIENT
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: zatemnenie2.frame.width, height: zatemnenie2.frame.height)
        
        let color1 = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4).cgColor
        let color2 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0).cgColor
        gradient.colors = [color1,color2]
        gradient.locations = [0.0, 1.0]
        zatemnenie2.layer.insertSublayer(gradient, at: 0)
        
        
        
        
        
        
        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //Falling menu
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.y
        
        if scrollView.contentOffset.y > screenSize.height*0.3 && isAlreadyScrolled == false{
            isAlreadyScrolled = true
            
            UIView.animate(withDuration: 1, delay: 0.0, options: [], animations: {
                self.navController.frame.origin.y += self.screenSize.height*0.09
                self.favourite.setImage(#imageLiteral(resourceName: "Bookmark Ribbon_18bca9_100"), for: .normal)
                self.favourite.setImage(#imageLiteral(resourceName: "formBlue"), for: .selected)
            }, completion: nil)
            backOutlet.setImage(#imageLiteral(resourceName: "18"), for: .normal)
        }
        
        if scrollView.contentOffset.y < screenSize.height*0.3{
            isAlreadyScrolled = false
            UIView.animate(withDuration: 1, delay: 0.0, options: [], animations: {
                self.navController.frame.origin.y = -self.screenSize.height*0.09
                self.favourite.setImage(#imageLiteral(resourceName: "Bookmark Ribbon_ffffff_100"), for: .normal)
                self.favourite.setImage(#imageLiteral(resourceName: "whiteForm"), for: .selected)
            }, completion: nil)
            backOutlet.setImage(#imageLiteral(resourceName: "Back_ffffff_100"), for: .normal)
            
        }
        
    }
    
    func backAction() {
        if segue == "profile" {
            performSegue(withIdentifier: "unwindToProfile", sender: self)
        } else {
            performSegue(withIdentifier: "unwindToList", sender: self)
        }
    }
    
    
    
    @IBAction func showAllButton(_ sender: Any) {
        print("kek")
        if screenSize.width == 375{
            dif = aboutFlat.contentSize.height-screenSize.height*0.16
            
        }else if screenSize.width == 414{
            
            dif = aboutFlat.contentSize.height-screenSize.height*0.165
        }
        
        if showAllOutlet.title(for: .normal) == "показать полностью"{
            aboutFlat.frame.size.height += dif
            showAllOutlet.frame.origin.y += dif
            showAllOutlet.setTitle("скрыть", for: .normal)
            scrollView.contentSize.height += dif
            razdelitel4.frame = CGRect(x:razdelitel4.frame.minX , y: razdelitel4.frame.minY+dif, width: razdelitel4.frame.width, height: razdelitel4.frame.height)
            conveniences.frame = CGRect(x: conveniences.frame.minX, y: conveniences.frame.minY+dif, width: conveniences.frame.width, height: conveniences.frame.height)
            convView.frame = CGRect(x: convView.frame.minX, y: convView.frame.minY+dif, width: convView.frame.width, height: convView.frame.height)
            //print(dif)
        }
        else {
            
            
            print(dif)
            aboutFlat.frame.size.height-=dif
            showAllOutlet.frame.origin.y-=dif
            showAllOutlet.setTitle("показать полностью", for: .normal)
            scrollView.contentSize.height -= dif
            razdelitel4.frame.origin.y -= dif
            conveniences.frame.origin.y -= dif
            convView.frame.origin.y -= dif
        }
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutFlat.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func fromMutual(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMutual"{
            let VC = segue.destination as! MutualFriendsViewController
            VC.segue = "flat"
            VC.flat_id = flat_id
        }
    }
    
    @IBAction func favouriteAction(_ sender: UIButton!) {
         api.favourite(id: flat_id)
        sender.isSelected = !sender.isSelected
        if !isAlreadyScrolled{
            favourite.setImage(#imageLiteral(resourceName: "whiteForm"), for: .selected)
        }else{
            favourite.setImage(#imageLiteral(resourceName: "formBlue"), for: .selected)
        }
    }
    
    // ДЛЯ КНОПКИ ПОКАЗАТЬ ПОЛНОСТЬЮ
    func checkText(textView:UITextView)->Bool{
        return textView.numberOfLines()<5
    }
}
