//
//  RentParamsController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 08.02.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class RentParamsController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let roomsField = UITextField()
    let squareField = UITextField()
    let table = UITableView()
    var params = [String]()
    var paramsValues = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view bounds
        let screen = self.view.frame
        

        params = ["Холодильник", "Интернет", "Телевизор", "Парковка", "Кондиционер", "Стиральная машина", "Посудомоечная машина", "Мебель", "Животные", "Совместная аренда", "Кухонная мебель"]
        paramsValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

        params = ["Холодильник", "Интернет", "Телевизор", "Парковка", "Кондиционер"]
        paramsValues = [0, 0, 0, 0, 0]

        params = ["Холодильник", "Интернет", "Телевизор", "Парковка", "Кондиционер", "Стиральная машина", "Посудомоечная машина", "Мебель", "Животные", "Совместная аренда", "Кухонная мебель"]
        paramsValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]


        
        //gray bar
        let grayBar = UIView()
        grayBar.frame = CGRect(x: 0.0, y: 0.0, width: screen.width, height: 20.0)
        grayBar.backgroundColor = UIColor.black
        grayBar.alpha = 0.37
        self.view.addSubview(grayBar)
        
        //continue button
        let continueButton = UIButton()
        continueButton.frame = CGRect(x: 0.0, y: screen.maxY - 55.0, width: screen.width, height: 55.0)
        continueButton.addTarget(self, action: #selector(RentParamsController.continueButtonAction), for: .touchUpInside)
        continueButton.backgroundColor = UIColor(red: 60/255, green: 70/255, blue: 77/255, alpha: 1)
        continueButton.setTitle("Далее", for: .normal)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightMedium)
        self.view.addSubview(continueButton)
        
        //cancel button
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: screen.maxX - 15.0 - 90.0, y: 40.0, width: 100.0, height: 20.0)
        cancelButton.addTarget(self, action: #selector(RentParamsController.cancelButtonAction), for: .touchUpInside)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightRegular)
        self.view.addSubview(cancelButton)
        
        roomsField.frame = CGRect(x: screen.minX + 15.0, y: screen.height * 0.12, width: screen.width - 30.0, height: 36.0)
        roomsField.delegate = self
        roomsField.placeholder = "Количество комнат"
        roomsField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        roomsField.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightHeavy)
        roomsField.adjustsFontSizeToFitWidth = true
        self.view.addSubview(roomsField)
        
        //separator
        let separator2 = UIView()
        separator2.frame = CGRect(x: 15.0, y: roomsField.frame.maxY + 15.0, width: screen.width - 30.0, height: 1.0)
        separator2.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        self.view.addSubview(separator2)
        
        squareField.frame = CGRect(x: screen.minX + 15.0, y: separator2.frame.maxY + 30.0, width: screen.width - 30.0, height: 36.0)
        squareField.delegate = self
        squareField.placeholder = "Площадь квартиры"
        squareField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        squareField.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightHeavy)
        squareField.adjustsFontSizeToFitWidth = true
        self.view.addSubview(squareField)
        
        //separator
        let separator = UIView()
        separator.frame = CGRect(x: 15.0, y: squareField.frame.maxY + 15.0, width: screen.width - 30.0, height: 1.0)
        separator.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        self.view.addSubview(separator)
        
        //tableView for suggestions
        table.frame = CGRect(x: 0.0, y: separator.frame.maxY, width: screen.width, height: screen.height - separator.frame.maxY - 55.0)
        table.rowHeight = screen.height * 0.09
        table.delegate = self
        table.dataSource = self
        table.register(FlatViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        self.view.addSubview(table)
        

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            if textField == roomsField {
                textField.placeholder = "Количество комнат"
            } else {
                textField.placeholder = "Площадь квартиры"
            }
        }
    }
    
    func continueButtonAction() {
        print("continue...")
        RentAddressController.flatToRent.conditioning = "\(paramsValues[4])"
        RentAddressController.flatToRent.fridge = "\(paramsValues[0])"
        RentAddressController.flatToRent.internet = "\(paramsValues[1])"
        RentAddressController.flatToRent.tv = "\(paramsValues[2])"
        RentAddressController.flatToRent.parking = "\(paramsValues[3])"
        RentAddressController.flatToRent.numberOfRoomsInFlat = roomsField.text!
        RentAddressController.flatToRent.square = squareField.text!
        RentAddressController.flatToRent.stiralka = "\(paramsValues[5])"
        RentAddressController.flatToRent.posudomoyka = "\(paramsValues[6])"
        RentAddressController.flatToRent.furniture = "\(paramsValues[7])"
        RentAddressController.flatToRent.animals = "\(paramsValues[8])"
        RentAddressController.flatToRent.mutualFriends = "\(paramsValues[9])"
        RentAddressController.flatToRent.kitchenFurniture = "\(paramsValues[10])"

        performSegue(withIdentifier: "lastStep", sender: self)
    }
    
    func cancelButtonAction() {
        performSegue(withIdentifier: "cancelRent", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return params.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlatViewCell
        
        //view bounds
        let screen = self.view.frame
        
        //parameter label
        cell.subwayLabel.text = "\(params[indexPath.row])"
        cell.subwayLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        cell.subwayLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightSemibold)
        cell.subwayLabel.frame = CGRect(x: 15.0, y: (self.table.rowHeight - 25) / 2, width: screen.width - 100, height: 25.0)
        cell.subwayLabel.adjustsFontSizeToFitWidth = true
        
        //switch
        cell.switchButton.frame = CGRect(x: screen.width - 20.0 - 40.0, y: (self.table.rowHeight - 25) / 2, width: 40.0, height: 25.0)
        cell.switchButton.addTarget(self, action: #selector(RentParamsController.switchDidChange(_:)), for: UIControlEvents.valueChanged)
        cell.switchButton.tag = indexPath.row
        
        return cell
    }
    
    func switchDidChange(_ uiSwitch: UISwitch) {
        if uiSwitch.isOn {
            self.paramsValues[uiSwitch.tag] = 1
        } else {
            self.paramsValues[uiSwitch.tag] = 0
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
