//
//  RentParamsController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 08.02.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class RentParamsController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    
    let rooms = ["Студия", "1 комната", "2 комнаты", "3 комнаты", "4 комнаты", "более 4"]
    let picker = UIPickerView()
    let viewForField = UIView()
    let subView = UIView()
    let doneButton = UIButton()
    let separator = UIView()
    var options = Options()
    var isLayout = false

    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var roomsField: UITextField!
    @IBOutlet weak var squareField: UITextField!
    @IBOutlet weak var floorsField: UITextField!
    @IBOutlet weak var floorField: UITextField!
    
    let rubleSymbol = UILabel()
    let meterSymbol = UILabel()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (!isLayout) {
            options = Options.getAll()
            for _ in 1...options.options.count - 4 {
                DispatchQueue.main.async {
                    self.scroll.contentSize.height += 40
                }
            }
            isLayout = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let screen = self.view.frame
        roomsField.tintColor = UIColor.clear
        scroll.delegate = self
        options = Options.getAll()
        var i = 0
        for option in options.options {
            
            let avatar = UIImageView()
            let avatarSize = CGSize(width: 25, height: 25)
            avatar.frame = CGRect(x: screen.minX + 16.0, y: self.bottomSeparator.frame.maxY + 15 + CGFloat(40 * i), width: avatarSize.width, height: avatarSize.height)
            avatar.image = UIImage(data: option["image"] as! Data)
            avatar.contentMode = .scaleAspectFill
            self.scroll.addSubview(avatar)
            
            let yourLabel = UILabel()
            let yourLabelSize = CGSize(width: 190, height: 17)
            yourLabel.frame = CGRect(x: avatar.frame.maxX + 20, y: 0, width: yourLabelSize.width, height: yourLabelSize.height)
            yourLabel.center.y = avatar.frame.midY
            yourLabel.text = (option["name"] as! String)
            yourLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
            self.scroll.addSubview(yourLabel)
            
            let yourButton = UIButton()
            let yourButtonSize = CGSize(width: 25, height: 25)
            yourButton.frame = CGRect(x: screen.width - 16 - 25, y: avatar.frame.minY, width: yourButtonSize.width, height: yourButtonSize.height)
            yourButton.setImage(UIImage(named:"uncheckedMark3"), for: .normal)
            yourButton.setImage(UIImage(named:"checkedMark2"), for: .selected)
            yourButton.addTarget(self, action: #selector(first(_:)), for: .touchUpInside)
            yourButton.tag = Int(option["id"] as! String)!
            self.scroll.addSubview(yourButton)
            
            i += 1
        }
        
        picker.delegate = self
        picker.dataSource = self
        
        separator.frame = CGRect(x: 0, y: 0, width: screen.width, height: 2)
        separator.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        self.viewForField.addSubview(separator)
        
        subView.frame = CGRect(x: 0, y: 2, width: screen.width, height: 45)
        subView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        self.viewForField.addSubview(subView)
        
        doneButton.frame = CGRect(x: screen.width - 8 - 65, y: 10, width: 65, height: 29)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1), for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        self.subView.addSubview(doneButton)
        
        picker.frame = CGRect(x: 0, y: 47, width: screen.width, height: 213)
        picker.backgroundColor = UIColor.white
        self.viewForField.addSubview(picker)
        
        viewForField.frame = CGRect(x: 0, y: 0, width: screen.width, height: 260)
        
        roomsField.inputView = viewForField
        roomsField.textColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
        
        priceField.delegate = self
        floorField.delegate = self
        floorsField.delegate = self
        squareField.delegate = self
        
        rubleSymbol.text = " Р"
        rubleSymbol.sizeToFit()
        rubleSymbol.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        priceField.rightView = rubleSymbol
        priceField.rightViewMode = UITextFieldViewMode.always
        
        meterSymbol.text = " м²"
        meterSymbol.sizeToFit()
        meterSymbol.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        squareField.rightView = meterSymbol
        squareField.rightViewMode = UITextFieldViewMode.always
        
        rubleSymbol.textColor = UIColor.lightGray
        meterSymbol.textColor = UIColor.lightGray
    }
    
    func doneButtonAction() {
        roomsField.text = rooms[picker.selectedRow(inComponent: 0)]
        self.view.endEditing(false)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rooms.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rooms[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roomsField.text = rooms[row]
        RentAddressController.flatToRent.numberOfRoomsInFlat = String(row)
        //self.view.endEditing(false)
    }
    
    func first(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            RentAddressController.flatToRent.options.append(String(sender.tag))
        } else {
            sender.isSelected = false
            for i in 0...RentAddressController.flatToRent.options.count - 1 {
                if RentAddressController.flatToRent.options[i] == String(sender.tag) {
                    RentAddressController.flatToRent.options.remove(at: i)
                    break
                }
            }
        }
        print(RentAddressController.flatToRent.options)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //textField.text = ""
        if textField == priceField {
            rubleSymbol.textColor = UIColor.black
        } else if textField == squareField {
            meterSymbol.textColor = UIColor.black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*if textField.text == "" {
            if textField == roomsField {
                textField.placeholder = "Количество комнат"
            } else {
                textField.placeholder = "Площадь квартиры"
            }
        }*/
        
        if textField == floorField {
            RentAddressController.flatToRent.floor = floorField.text ?? "-"
        } else if textField == floorsField {
            RentAddressController.flatToRent.floors = floorsField.text ?? "-"
        } else if textField == priceField {
            if textField.text == "" {
                rubleSymbol.textColor = UIColor.lightGray
            } else {
                RentAddressController.flatToRent.flatPrice = priceField.text ?? "-"
            }
        } else if textField == squareField {
            if textField.text == "" {
                meterSymbol.textColor = UIColor.lightGray
            } else {
                RentAddressController.flatToRent.square = squareField.text ?? "-"
            }
        }
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
