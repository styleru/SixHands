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


class FlatViewController: UIViewController {
let screenSize: CGRect = UIScreen.main.bounds
   let per = realm.object(ofType: person.self, forPrimaryKey: 0)
    var mas = [String]()
    var id_underground = Int()
    var id_underground_line = Int()
    var flat_id = String()
    let api = API()
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var backOutlet: UIButton!
    @IBOutlet weak var mutualFriendsOutlet: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var stairs: UILabel!
    @IBOutlet weak var square: UILabel!
    @IBOutlet weak var numberOfRooms: UILabel!
    @IBOutlet weak var photoStairs: UIImageView!
    @IBOutlet weak var photoSquare: UIImageView!
    @IBOutlet weak var photoNumberOfRooms: UIImageView!
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
    
    
    
    override func viewDidLoad() {
        print(screenSize.width)
        print(screenSize.height)
        
        api.flatsSingle(id: flat_id){(js:Any) in
            let jsondata = js as! JSON
        let time = jsondata["create_date"].string!
        if time != nil{
        self.date.text = try? String(time.characters.dropLast(9))
        self.time.text = try? String(time.characters.dropFirst(11))}
        if jsondata["price"] != nil { self.price.text = jsondata["price"].string!+" ₽"} else {self.price.text = "-"}
        if jsondata["address"] != nil{  self.adress.text = jsondata["address"].string!}else {self.adress.text = " "}
        if jsondata["square"] != nil{self.square.text = jsondata["square"].string! + " м.кв."}else{self.square.text = "-"}
        if jsondata["rooms"] != nil{self.numberOfRooms.text = jsondata["rooms"].string! + " ком."}else{self.numberOfRooms.text = "-"}
        if jsondata["floor"] != nil{self.stairs.text = jsondata["floor"].string! + "-этаж"}else {self.stairs.text = "-"}
        if jsondata["to_underground"] != nil {self.timeToSubway.text = jsondata["to_underground"].string! + " мин."} else {self.timeToSubway.text = "-"}
        if jsondata["owner"]["first_name"] != nil {self.mutualFriendsOutlet.setTitle( "Хохяин "+jsondata["owner"]["first_name"].string!+"\n5 общих друзей", for: .normal)}else{self.mutualFriendsOutlet.setTitle("Owner", for: .normal)}
        if jsondata["owner"]["avatar"] != nil {self.avatar.sd_setImage(with:  URL(string : jsondata["owner"]["avatar"].string!))}
            
            if  let amount = jsondata["photos"].array?.count{
            for i in 0..<amount{
                
                    let imageView = UIImageView()
                if jsondata["photos"][i]["url"] != nil{
                imageView.sd_setImage(with: URL(string : jsondata["photos"][i]["url"].string!))
                    let x = self.view.frame.width * CGFloat(i)
                    imageView.frame = CGRect(x: x, y: 0, width: self.screenSize.width, height: self.imagesScrollView.bounds.height)
                    self.imagesScrollView.contentSize.width = self.screenSize.width * CGFloat(i + 1)
                    imageView.clipsToBounds = true
                    self.imagesScrollView.addSubview(imageView)
                }}
            }
            if let id_underground = jsondata["id_underground"].string{
                self.api.underground(id: id_underground){(js:Any) in
                let jsondata = js as! JSON
                    print("Metroha:\(jsondata)")
                    self.subway.text = jsondata["stations"][Int(id_underground)!-1]["name"].string!
                    self.id_underground_line = Int(jsondata["stations"][Int(id_underground)!-1]["id_underground_line"].string!)!
                    let color = (jsondata["lines"].array?.count)!
                    
                    for i in 0..<color{
                        if jsondata["lines"][i]["id"].string! == "\(self.id_underground_line)"{
                            let col = jsondata["lines"][i]["color"].string!
                            switch col{
                            case "Синий": self.subwayColor.backgroundColor = UIColor.blue
                            case "Красный": self.subwayColor.backgroundColor = UIColor.red
                            case "Зеленый": self.subwayColor.backgroundColor = UIColor.green
                            case "Желтая": self.subwayColor.backgroundColor = UIColor.yellow
                            case "Серый": self.subwayColor.backgroundColor = UIColor.gray
                            default : self.subwayColor.backgroundColor = UIColor.black
                            }
                        }
                        }}
            }
            
            
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
        backOutlet.center = CGPoint(x: 40 , y: 40)
        rentOutlet.bounds = CGRect(x: 0, y: 0, width: screenSize.width , height: screenSize.height * 0.08245877 )
        rentOutlet.center = CGPoint(x: screenSize.width/2 , y: screenSize.height - rentOutlet.frame.height/2)
        adress.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.6, height: screenSize.height * 0.12 )
        adress.center = CGPoint(x: screenSize.width * 0.35, y: screenSize.height * 0.46176)
        time.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.2026667, height: screenSize.height * 0.0254 )
        time.center = CGPoint(x: screenSize.width * 0.82666, y: screenSize.height * 0.47601199)
        date.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.3, height: screenSize.height * 0.0254 )
        date.center = CGPoint(x: time.frame.maxX - date.frame.width/2, y: screenSize.height * 0.44302849)
        subwayColor.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.032, height: screenSize.width * 0.032 )
        subwayColor.center = CGPoint(x:adress.frame.minX + subwayColor.frame.width/2, y: screenSize.height * 0.5457)
        subway.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.5, height: screenSize.height * 0.03 )
        subway.center = CGPoint(x: subwayColor.frame.maxX + subway.frame.width/2 + 5, y: screenSize.height * 0.5457)

        timeToSubway.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.17, height: screenSize.width * 0.06)
        timeImage.bounds = CGRect(x: 0, y: 0, width: screenSize.width * 0.032, height: screenSize.width * 0.032 )
        timeToSubway.center = CGPoint(x: time.frame.maxX - timeToSubway.frame.width/2 , y: screenSize.height * 0.5457)
        timeImage.center = CGPoint(x: timeToSubway.frame.minX, y: screenSize.height * 0.5457)

        

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
        subwayColor.layer.cornerRadius = subwayColor.frame.size.width / 2
        subwayColor.clipsToBounds = true
        
        
        
        
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func getSubway(underground_id:Int, city_id:String){
        Alamofire.request("http://6hands.styleru.net/underground?id_city=\(city_id)").responseJSON { response in
            var jsondata = JSON(data:response.data!)
            print(jsondata["stations"][underground_id-1])
            self.subway.text = jsondata["stations"][underground_id-1]["name"].string!
            self.id_underground_line = Int(jsondata["stations"][underground_id-1]["id_underground_line"].string!)!
            let color = (jsondata["lines"].array?.count)!
            
            for i in 0..<color{
                if jsondata["lines"][i]["id"].string! == "\(self.id_underground_line)"{
                    let col = jsondata["lines"][i]["color"].string!
                    switch col{
                    case "Синий": self.subwayColor.backgroundColor = UIColor.blue
                    case "Красный": self.subwayColor.backgroundColor = UIColor.red
                    case "Зеленый": self.subwayColor.backgroundColor = UIColor.green
                    case "Желтая": self.subwayColor.backgroundColor = UIColor.yellow
                    case "Серый": self.subwayColor.backgroundColor = UIColor.gray
                    default : self.subwayColor.backgroundColor = UIColor.black
                    }
                }
                
            }
        }
    }


   
}
