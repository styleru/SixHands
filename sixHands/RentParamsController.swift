//
//  RentParamsController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 08.02.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class RentParamsController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    static var paramsValues = [Int]()
    let rooms = ["1 комната", "2 комнаты", "3 комнаты", "4 комнаты", "более 4"]
    let picker = UIPickerView()
    let viewForField = UIView()
    let subView = UIView()
    let doneButton = UIButton()
    let separator = UIView()

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var roomsField: UITextField!
    @IBOutlet weak var squareField: UITextField!
    @IBOutlet weak var floorsField: UITextField!
    @IBOutlet weak var floorField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let screen = self.view.frame
        RentParamsController.paramsValues = [0, 0, 0, 0, 0]
        
        scroll.contentSize.height = 1000
        
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
    }
    
    func doneButtonAction() {
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
        RentAddressController.flatToRent.numberOfRoomsInFlat = roomsField.text!
        //self.view.endEditing(false)
    }
    
    @IBAction func first(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            RentParamsController.paramsValues[sender.tag] = 1
        } else {
            sender.isSelected = false
            RentParamsController.paramsValues[sender.tag] = 0
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
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
        
        if textField == priceField {
            if !((textField.text?.hasSuffix(" Р"))!) && textField.text != "" {
                RentAddressController.flatToRent.flatPrice = priceField.text!
                textField.text = textField.text! + " Р"
            }
        } else if textField == squareField {
            if !((textField.text?.hasSuffix(" м²"))!) && textField.text != "" {
                RentAddressController.flatToRent.square = squareField.text!
                textField.text = textField.text! + " м²"
            }
        } else if textField == floorField {
            RentAddressController.flatToRent.floor = floorField.text ?? "-"
        } else if textField == floorField {
            RentAddressController.flatToRent.floors = floorsField.text ?? "-"
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
