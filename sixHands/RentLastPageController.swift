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
    let priceField = UITextField()
    let commentsField = UITextView()
    let separator = UIView()
    let separator3 = UIView()
    let photoLabel = UILabel()
    let addButton = UIButton()
    var photos = [UIImage]()
    let imagePicker = UIImagePickerController()
    let scrollView = UIScrollView()
    let mainScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //view bounds
        let screen = self.view.frame
        
        //main scroll
        mainScrollView.frame = CGRect(x: 0.0, y: screen.height * 0.12 + 52, width: screen.width, height: screen.height - 55.0 - screen.height * 0.12)
        mainScrollView.contentSize.height = mainScrollView.frame.height
        mainScrollView.contentSize.width = screen.width
        mainScrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(mainScrollView)
        
        //price text field
        priceField.frame = CGRect(x: screen.minX + 15.0, y: 0.0, width: screen.width - 30.0, height: 36.0)
        priceField.delegate = self
        priceField.placeholder = "Введите цену"
        priceField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        priceField.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightHeavy)
        priceField.adjustsFontSizeToFitWidth = true
        mainScrollView.addSubview(priceField)
        
        //separator
        let separator2 = UIView()
        separator2.frame = CGRect(x: 15.0, y: priceField.frame.maxY + 15.0, width: screen.width - 30.0, height: 1.0)
        separator2.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        mainScrollView.addSubview(separator2)
        
        //comments textview
        commentsField.frame = CGRect(x: screen.minX + 10.0, y: separator2.frame.maxY + 30.0, width: screen.width - 30.0, height: 36.0)
        commentsField.delegate = self
        commentsField.text = "Комментарии"
        commentsField.textColor = UIColor.gray
        commentsField.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightSemibold)
        mainScrollView.addSubview(commentsField)
        
        //separator
        separator.frame = CGRect(x: 15.0, y: commentsField.frame.maxY + 15.0, width: screen.width - 30.0, height: 1.0)
        separator.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        mainScrollView.addSubview(separator)
        
        //label photo
        photoLabel.frame = CGRect(x: screen.minX + 15.0, y: separator.frame.maxY + 30.0, width: 192.0, height: 72.0)
        photoLabel.text = "Фотографии квартиры"
        photoLabel.numberOfLines = 2
        photoLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        photoLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightHeavy)
        mainScrollView.addSubview(photoLabel)
        
        //separator
        separator3.frame = CGRect(x: 15.0, y: photoLabel.frame.maxY + 15.0, width: screen.width - 30.0, height: 1.0)
        separator3.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        mainScrollView.addSubview(separator3)
        
        //add button
        var size: CGFloat = 35.0
        addButton.frame = CGRect(x: screen.width - 25.0 - size, y: photoLabel.frame.midY - size/2, width: size, height: size)
        addButton.addTarget(self, action: #selector(RentLastPageController.addButtonAction), for: .touchUpInside)
        addButton.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        mainScrollView.addSubview(addButton)
        
        //recognize tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(RentLastPageController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //scroll view
        size = screen.width/2 - 30
        scrollView.frame = CGRect(x: 0.0, y: separator3.frame.maxY + 30.0, width: screen.width, height: size)
        scrollView.contentSize.height = scrollView.frame.height
        scrollView.contentSize.width = screen.width/2 * CGFloat(photos.count)
        scrollView.showsHorizontalScrollIndicator = false
        mainScrollView.addSubview(scrollView)
        
    }
    
    //dismiss keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Комментарии" {
            textView.text = ""
            textView.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Комментарии"
            textView.textColor = UIColor.gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if commentsField.contentSize.height < 180 {
            var textFrame = commentsField.frame
            textFrame.size.height = commentsField.contentSize.height
            let dif = textFrame.size.height - commentsField.frame.height
            separator.frame.origin.y += dif
            photoLabel.frame.origin.y += dif
            separator3.frame.origin.y += dif
            addButton.frame.origin.y += dif
            scrollView.frame.origin.y += dif
            mainScrollView.contentSize.height += dif
            commentsField.frame = textFrame
            commentsField.setContentOffset(CGPoint(x: 0.0, y: commentsField.contentSize.height - commentsField.frame.height), animated: false)
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.placeholder = "Введите цену"
        }
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
            "price" : "\(priceField.text!)",
            "square" : "\(RentAddressController.flatToRent.square)",
            "rooms" : "\(RentAddressController.flatToRent.numberOfRoomsInFlat)",
            "description" : "\(commentsField.text!)",
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
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            self.snap()
        }
        alertController.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            self.choose()
        }
        alertController.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func cancelButtonAction() {
        performSegue(withIdentifier: "cancelRent", sender: self)
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
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 15.0, y: 0, width: self.scrollView.frame.height, height: self.scrollView.frame.height)
        if photos.count != 1 {
            for subview in scrollView.subviews {
                subview.frame.origin.x += self.view.frame.width/2
            }
        }
        scrollView.contentSize.width += self.view.frame.width/2
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
        scrollView.addSubview(imageView)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photos.insert(pickedImage, at: 0)
            
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 15.0, y: 0, width: self.scrollView.frame.height, height: self.scrollView.frame.height)
            if photos.count != 1 {
                for subview in scrollView.subviews {
                    subview.frame.origin.x += self.view.frame.width/2
                }
            }
            scrollView.contentSize.width += self.view.frame.width/2
            imageView.image = pickedImage
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = false
            scrollView.addSubview(imageView)
            
        }
        
        dismiss(animated: true, completion: nil)
        
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
