//
//  MasterContainer.swift
//  sixHands
//
//  Created by Nikita Guzhva on 05/06/2017.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import SwiftyJSON

class MasterContainer: UIViewController {
    
    var containerView: NumbersContainer?
    @IBOutlet weak var progress: UIProgressView!
    var i = Int()
    let cancel = UIButton()
    let nextButton = UIButton()
    let continueButton = UIButton()
    let first = UILabel()
    let second = UILabel()
    let third = UILabel()
    let fourth = UILabel()
    let api = API()
    
    static var staticSelf: MasterContainer?

    override func viewDidLoad() {
        super.viewDidLoad()

        MasterContainer.staticSelf = self
        // Do any additional setup after loading the view.
        i = 1
        
        let screen = self.view.frame
        UIApplication.shared.statusBarStyle = .default
        
        navigationItem.title = "Шаг \(i) из 4"
        
        let firstSize = CGSize(width: 12, height: 18)
        first.frame = CGRect(x: screen.width * 39/375, y: 74 + 10, width: firstSize.width, height: firstSize.height)
        first.text = "1"
        first.textColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
        first.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightMedium)
        view.insertSubview(first, aboveSubview: (containerView?.view)!)
        
        second.frame = CGRect(x: first.frame.maxX + screen.width * 82/375, y: 74 + 10, width: firstSize.width + 1, height: firstSize.height + 1)
        second.text = "2"
        second.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        second.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightMedium)
        view.insertSubview(second, aboveSubview: (containerView?.view)!)
        
        third.frame = CGRect(x: second.frame.maxX + screen.width * 82/375, y: 74 + 10, width: firstSize.width + 2, height: firstSize.height + 1)
        third.text = "3"
        third.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        third.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightMedium)
        view.insertSubview(third, aboveSubview: (containerView?.view)!)
        
        fourth.frame = CGRect(x: third.frame.maxX + screen.width * 82/375, y: 74 + 10, width: firstSize.width + 2, height: firstSize.height)
        fourth.text = "4"
        fourth.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        fourth.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightMedium)
        view.insertSubview(fourth, aboveSubview: (containerView?.view)!)
        
        //continue button
        continueButton.frame = CGRect(x: 0.0, y: screen.maxY - 55.0, width: screen.width, height: 55.0)
        continueButton.addTarget(self, action: #selector(MasterContainer.continueButtonAction), for: .touchUpInside)
        continueButton.backgroundColor = UIColor(red: 176/255, green: 176/255, blue: 176/255, alpha: 1)
        continueButton.setTitle("Далее", for: .normal)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightMedium)
        self.view.addSubview(continueButton)
        
        cancel.setTitle("Отменить", for: .normal)
        cancel.setTitleColor(UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1), for: .normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancel.contentHorizontalAlignment = .left
        cancel.frame = CGRect(x: 0, y: 0, width: 90, height: 25)
        cancel.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = cancel
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        nextButton.setTitle("Далее", for: .normal)
        nextButton.setTitleColor(UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1), for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextButton.contentHorizontalAlignment = .right
        nextButton.frame = CGRect(x: 0, y: 0, width: 120, height: 25)
        nextButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = nextButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func continueButtonAction() {
        
        var isCompleted = true
        print("continue...")
        print("long: \(RentAddressController.flatToRent.longitude), lat: \(RentAddressController.flatToRent.latitude)")
        
        if i == 2 {
            if let controller = RentParamsController.staticSelf {
                if RentAddressController.flatToRent.square == "" || RentAddressController.flatToRent.square == "-" {
                    isCompleted = false
                    controller.squareLabel.textColor = UIColor(red: 221/255, green: 86/255, blue: 86/255, alpha: 1)
                } else {
                    controller.squareLabel.textColor = UIColor.darkText
                }
                if RentAddressController.flatToRent.flatPrice == "" || RentAddressController.flatToRent.flatPrice == "-" {
                    isCompleted = false
                    controller.priceLabel.textColor = UIColor(red: 221/255, green: 86/255, blue: 86/255, alpha: 1)
                } else {
                    controller.priceLabel.textColor = UIColor.darkText
                }
                if RentAddressController.flatToRent.floor == "" || RentAddressController.flatToRent.floor == "-" {
                    isCompleted = false
                    controller.floorLabel.textColor = UIColor(red: 221/255, green: 86/255, blue: 86/255, alpha: 1)
                } else {
                    controller.floorLabel.textColor = UIColor.darkText
                }
                if RentAddressController.flatToRent.floors == "" || RentAddressController.flatToRent.floors == "-" {
                    isCompleted = false
                        controller.floorsLabel.textColor = UIColor(red: 221/255, green: 86/255, blue: 86/255, alpha: 1)
                } else {
                    controller.floorsLabel.textColor = UIColor.darkText
                }
                if RentAddressController.flatToRent.numberOfRoomsInFlat == "" || RentAddressController.flatToRent.numberOfRoomsInFlat == "-" {
                    isCompleted = false
                    controller.roomsLabel.textColor = UIColor(red: 221/255, green: 86/255, blue: 86/255, alpha: 1)
                } else {
                    controller.roomsLabel.textColor = UIColor.darkText
                }
                
                if !isCompleted {
                    let alertController = UIAlertController(title: nil, message: "Заполните все поля", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: UIAlertActionStyle.cancel)
                    {
                        (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(cancelAction)
                    controller.present(alertController, animated: true, completion: nil)
                }
            }
        } else if i == 4 {
            if let controller = RentLastPageController.staticSelf {
                if RentAddressController.flatToRent.photos.count == 0 {
                    isCompleted = false
                    let alertController = UIAlertController(title: nil, message: "Добавьте хотя бы одно фото квартиры", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: UIAlertActionStyle.cancel)
                    {
                        (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(cancelAction)
                    controller.present(alertController, animated: true, completion: nil)
                }
            }
        } else if i == 1 {
            if let controller = RentAddressController.staticSelf {
                if RentAddressController.flatToRent.address == "" {
                    isCompleted = false
                    let alertController = UIAlertController(title: nil, message: "Добавьте адрес", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Ок", style: UIAlertActionStyle.cancel)
                    {
                        (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(cancelAction)
                    controller.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        if (isCompleted) {
            i += 1
            if i < 5 {
                if i != 3 {
                    continueButton.backgroundColor = UIColor(red: 176/255, green: 176/255, blue: 176/255, alpha: 1)
                }
                navigationItem.title = "Шаг \(i) из 4"
                containerView?.segueIdentifierReceived(button: i)
                progress.setProgress(progress.progress + 0.25, animated: true)
                switch i {
                case 2:
                    second.textColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
                case 3:
                    third.textColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
                case 4:
                    fourth.textColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
                    continueButton.setTitle("Опубликовать", for: .normal)
                    nextButton.setTitle("Опубликовать", for: .normal)
                    
                default:
                    print("waaaat?!")
                }
                cancel.setTitle("Назад", for: .normal)
                cancel.removeTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
                cancel.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
            } else {
                i -= 1
                
                print("goPublic...")
                var params = "["
                if RentAddressController.flatToRent.options.count != 0 {
                    for id in RentAddressController.flatToRent.options {
                        params += id + ","
                    }
                    params = String(params.characters.dropLast(1))
                }
                params += "]"
                
                //separate building and street
                let full = RentAddressController.flatToRent.address
                var building = ""
                var street = ""
                if let rangeOfComma = full.range(of: ",", options: .backwards) {
                    building = String(full.characters.suffix(from: rangeOfComma.upperBound))
                    building = String(building.characters.dropFirst())
                }
                if let rangeOfComma = full.range(of: ",") {
                    street = String(full.characters.prefix(upTo: rangeOfComma.upperBound))
                    street = String(street.characters.dropLast())
                }
                
                let parameters = [
                    "id_city" : "1",
                    "id_underground" : "4",
                    "street" : street,
                    "building" : building,
                    "longitude" : "\(RentAddressController.flatToRent.longitude)",
                    "latitude" : "\(RentAddressController.flatToRent.latitude)",
                    "price" : "\(RentAddressController.flatToRent.flatPrice)",
                    "square" : "\(RentAddressController.flatToRent.square)",
                    "rooms" : "\(RentAddressController.flatToRent.numberOfRoomsInFlat)",
                    "floor" : "\(RentAddressController.flatToRent.floor)",
                    "floors" : "\(RentAddressController.flatToRent.floors)",
                    "description" : "\(RentAddressController.flatToRent.comments)",
                    "options" : params
                ]
                
                upload(photoData: RentAddressController.flatToRent.photos, parameters: parameters)
            }
        }
    }
    
    func upload(photoData: [Data], parameters: [String : String]) {
        
        api.upload(photoData: photoData, parameters: parameters) { (js: Any) in
            let jsondata = js as! JSON
            print("data: \(jsondata)")
            if (jsondata != JSON.null) {
                print("finally!")
                self.performSegue(withIdentifier: "cancelRent", sender: self)
            } else {
                print("Something's wrong")
                
                //temporary alert
                let alertController = UIAlertController(title: "Something's wrong", message: "hmmm... 500 Internal Server Error", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
                {
                    (result : UIAlertAction) -> Void in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func cancelButtonAction() {
        performSegue(withIdentifier: "cancelRent", sender: self)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func backButtonAction() {
        continueButton.setTitle("Далее", for: .normal)
        nextButton.setTitle("Далее", for: .normal)
        i -= 1
        containerView?.segueIdentifierReceived(button: i)
        progress.setProgress(progress.progress - 0.25, animated: true)
        navigationItem.title = "Шаг \(i) из 4"
        if i == 1 {
            cancel.setTitle("Отменить", for: .normal)
            cancel.removeTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
            cancel.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        }
        switch i {
        case 1:
            second.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        case 2:
            third.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        case 3:
            fourth.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        default:
            print("waaaat?!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            containerView = segue.destination as? NumbersContainer
            
        }
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
