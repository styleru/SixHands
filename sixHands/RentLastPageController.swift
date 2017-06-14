//
//  RentLastPageController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 08.02.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation

class RentLastPageController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let api = API()
    var photos = [UIImage]()
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var justLabel: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    let border = UIView()
    let addPhoto = UIButton()
    let avatar = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //view bounds
        let screen = self.view.frame
        
        let yourViewSize = CGSize(width: 100, height: 100)
        border.frame = CGRect(x: screen.width/2 - yourViewSize.width/2, y: justLabel.frame.maxY + 15.0, width: yourViewSize.width, height: yourViewSize.height)
        border.backgroundColor = UIColor.clear
        border.layer.cornerRadius = 4.0
        border.clipsToBounds = true
        border.layer.borderWidth = 2
        border.layer.borderColor = UIColor(red: 220/255.0, green:220/255.0, blue:220/255.0, alpha: 1.0).cgColor
        self.scroll.addSubview(border)
        
        let avatarSize = CGSize(width: 50, height: 40)
        avatar.frame = CGRect(x: 25, y: 30, width: avatarSize.width, height: avatarSize.height)
        avatar.image = UIImage(named: "72")
        border.addSubview(avatar)
        
        let yourButtonSize = CGSize(width: 96, height: 96)
        addPhoto.frame = CGRect(x: 2, y: 2, width: yourButtonSize.width, height: yourButtonSize.height)
        addPhoto.backgroundColor = UIColor.clear
        addPhoto.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        border.addSubview(addPhoto)
        
        
    }
    
    func continueButtonAction() {
        print("goPublic...")
        
        let param = [
            "24" : "\(RentAddressController.flatToRent.parking)",
            "23" : "\(RentAddressController.flatToRent.conditioning)",
            "21" : "\(RentAddressController.flatToRent.stiralka)",
            "20" : "\(RentAddressController.flatToRent.posudomoyka)",
            "19" : "\(RentAddressController.flatToRent.fridge)",
            "18" : "\(RentAddressController.flatToRent.tv)",
            "9" : "\(RentAddressController.flatToRent.animals)",
            "15" : "\(RentAddressController.flatToRent.internet)"
        ]
        
        var params = "["
        for (id, value) in param {
            if value == "1" {
                params += id + ","
            }
        }
        params = String(params.characters.dropLast(1))
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
            "id_underground" : "1",
            "street" : street,
            "building" : building,
            "longitude" : "\(RentAddressController.flatToRent.longitude)",
            "latitude" : "\(RentAddressController.flatToRent.latitude)",
            //"price" : "\(priceField.text!)",
            "square" : "\(RentAddressController.flatToRent.square)",
            "rooms" : "\(RentAddressController.flatToRent.numberOfRoomsInFlat)",
            //"description" : "\(commentsField.text!)",
            "options" : params
        ]
        
        var photoDatas = [Data]()
        for photo in photos {
            photoDatas.append(UIImageJPEGRepresentation(photo,1)!)
        }
        
        upload(photoData: photoDatas, parameters: parameters)
        
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
    
    func addButtonAction() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Камера", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            self.snap()
        }
        alertController.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Медиатека", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            self.choose()
        }
        alertController.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(cancelAction)
        
        if photos.count < 20 {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func snap() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choose() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        photos.insert(image, at: 0)
        justLabel.text = "\(photos.count) фотографий"
        if photos.count == 20 {
            self.border.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
            self.avatar.image = UIImage(named:"7")
            justLabel.text = "\(photos.count) фотографий (максимум)"
        }
        justLabel.sizeToFit()
        justLabel.frame.origin.x = self.view.frame.width/2 - justLabel.frame.width/2
        
        let imageView = UIImageView()
        let delete = UIButton()
        imageView.frame = CGRect(x: 0.0, y: 0, width: 100, height: 100)
        delete.frame = CGRect(x: 0.0, y: 0, width: 25, height: 25)
        if photos.count == 1 {
            border.frame.origin.x = self.view.frame.width/2 - border.frame.width - 6
            imageView.frame.origin = CGPoint(x: self.view.frame.width/2 + 6, y: border.frame.minY)
        } else if photos.count == 2 {
            border.frame.origin.x = self.view.frame.width/2 - border.frame.width * 1.5 - 12
            for subview in scroll.subviews {
                if subview.tag == 1 {
                    subview.frame.origin.x -= 56
                }
            }
            imageView.frame.origin = CGPoint(x: self.view.frame.width/2 + 12 + 50, y: border.frame.minY)
        } else {
            let q = photos.count
            if q % 3 == 0 {
                let x = self.view.frame.width/2 - border.frame.width * 1.5 - 12
                let y = border.frame.maxY + 10 + CGFloat((q/3 - 1) * 110)
                imageView.frame.origin = CGPoint(x: x, y: y)
                if q > 6 {
                    self.scroll.contentSize.height += 110
                }
            } else if (q - 1) % 3 == 0 {
                let x = self.view.frame.width/2 - 50
                let y = border.frame.maxY + 10 + CGFloat(((q - 1)/3 - 1) * 110)
                imageView.frame.origin = CGPoint(x: x, y: y)
            } else if (q - 2) % 3 == 0 {
                let x = self.view.frame.width/2 + 12 + 50
                let y = border.frame.maxY + 10 + CGFloat(((q - 2)/3 - 1) * 110)
                imageView.frame.origin = CGPoint(x: x, y: y)
            }
        }
        
        delete.frame.origin = CGPoint(x: imageView.frame.maxX - 17, y: imageView.frame.minY - 7)
        imageView.image = image
        delete.setImage(UIImage(named: "82"), for: .normal)
        delete.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
        imageView.tag = photos.count
        delete.tag = photos.count
        self.scroll.addSubview(imageView)
        self.scroll.addSubview(delete)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photos.insert(pickedImage, at: 0)
            justLabel.text = "\(photos.count) фотографий"
            if photos.count == 20 {
                self.border.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
                self.avatar.image = UIImage(named:"7")
                justLabel.text = "\(photos.count) фотографий (максимум)"
            }
            justLabel.sizeToFit()
            justLabel.frame.origin.x = self.view.frame.width/2 - justLabel.frame.width/2
            
            let imageView = UIImageView()
            let delete = UIButton()
            imageView.frame = CGRect(x: 0.0, y: 0, width: 100, height: 100)
            delete.frame = CGRect(x: 0.0, y: 0, width: 25, height: 25)
            if photos.count == 1 {
                border.frame.origin.x = self.view.frame.width/2 - border.frame.width - 6
                imageView.frame.origin = CGPoint(x: self.view.frame.width/2 + 6, y: border.frame.minY)
            } else if photos.count == 2 {
                border.frame.origin.x = self.view.frame.width/2 - border.frame.width * 1.5 - 12
                for subview in scroll.subviews {
                    if subview.tag == 1 {
                        subview.frame.origin.x -= 56
                    }
                }
                imageView.frame.origin = CGPoint(x: self.view.frame.width/2 + 12 + 50, y: border.frame.minY)
            } else {
                let q = photos.count
                if q % 3 == 0 {
                    let x = self.view.frame.width/2 - border.frame.width * 1.5 - 12
                    let y = border.frame.maxY + 10 + CGFloat((q/3 - 1) * 110)
                    imageView.frame.origin = CGPoint(x: x, y: y)
                    if q > 6 {
                        self.scroll.contentSize.height += 110
                    }
                } else if (q - 1) % 3 == 0 {
                    let x = self.view.frame.width/2 - 50
                    let y = border.frame.maxY + 10 + CGFloat(((q - 1)/3 - 1) * 110)
                    imageView.frame.origin = CGPoint(x: x, y: y)
                } else if (q - 2) % 3 == 0 {
                    let x = self.view.frame.width/2 + 12 + 50
                    let y = border.frame.maxY + 10 + CGFloat(((q - 2)/3 - 1) * 110)
                    imageView.frame.origin = CGPoint(x: x, y: y)
                }
            }
            
            delete.frame.origin = CGPoint(x: imageView.frame.maxX - 17, y: imageView.frame.minY - 7)
            imageView.image = pickedImage
            delete.setImage(UIImage(named: "82"), for: .normal)
            delete.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = false
            imageView.tag = photos.count
            delete.tag = photos.count
            self.scroll.addSubview(imageView)
            self.scroll.addSubview(delete)
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func deletePhoto() {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
