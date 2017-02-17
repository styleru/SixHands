//
//  RentAddressController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 05.02.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
//import GooglePlaces
import Alamofire
import SwiftyJSON

class RentAddressController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let addressField = UITextField()
    //var addresses = [CLLocationCoordinate2D]()
    var addressString = String()
    var addressStrings = [String]()
    var detailedStrings = [String]()
    var longitudes = [Float]()
    var latitudes = [Float]()
    let table = UITableView()
    static var flatToRent = Flat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //view bounds
        let screen = self.view.frame
        
        //gray bar
        let grayBar = UIView()
        grayBar.frame = CGRect(x: 0.0, y: 0.0, width: screen.width, height: 20.0)
        grayBar.backgroundColor = UIColor.black
        grayBar.alpha = 0.37
        self.view.addSubview(grayBar)
        
        //continue button
        let continueButton = UIButton()
        continueButton.frame = CGRect(x: 0.0, y: screen.maxY - 55.0, width: screen.width, height: 55.0)
        continueButton.addTarget(self, action: #selector(RentAddressController.continueButtonAction), for: .touchUpInside)
        continueButton.backgroundColor = UIColor(red: 60/255, green: 70/255, blue: 77/255, alpha: 1)
        continueButton.setTitle("Далее", for: .normal)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightMedium)
        self.view.addSubview(continueButton)
        
        //cancel button
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: screen.maxX - 15.0 - 90.0, y: 40.0, width: 100.0, height: 20.0)
        cancelButton.addTarget(self, action: #selector(RentAddressController.cancelButtonAction), for: .touchUpInside)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightRegular)
        self.view.addSubview(cancelButton)
        
        addressField.frame = CGRect(x: screen.minX + 15.0, y: screen.height * 0.12, width: screen.width - 30.0, height: 36.0)
        addressField.delegate = self
        addressField.placeholder = "Где вы сдаёте квартиру?"
        addressField.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        addressField.font = UIFont.systemFont(ofSize: 22.0, weight: UIFontWeightHeavy)
        addressField.adjustsFontSizeToFitWidth = true
        addressField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.view.addSubview(addressField)
        
        //separator
        let separator = UIView()
        separator.frame = CGRect(x: 15.0, y: addressField.frame.maxY + 15.0, width: screen.width - 30.0, height: 1.0)
        separator.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
        self.view.addSubview(separator)
        
        //tableView for suggestions
        table.frame = CGRect(x: 0.0, y: separator.frame.maxY, width: screen.width, height: screen.height - separator.frame.maxY - 55.0)
        table.rowHeight = screen.height * 0.1
        table.delegate = self
        table.dataSource = self
        table.register(FlatViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorInset.left = 15.0
        table.separatorInset.right = 15.0
        self.view.addSubview(table)
        
        
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        //request parameters
        let key = "a43e81f7-dc3b-4789-be06-78fef3f4d48a"
        let lang = "ru_RU"
        let text = textField.text!
        
        let urlString = "https://search-maps.yandex.ru/v1/?apikey=\(key)&text=\(text)&lang=\(lang)&type=geo"
        let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let myUrl = URL(string: encoded!)
        let request = URLRequest(url:myUrl!)
        
        Alamofire.request(request).responseJSON {
            response in
            
            var jsondata = JSON(data:response.data!)["features"]
            let array = jsondata.array
            
            self.addressStrings = []
            self.detailedStrings = []
            self.latitudes = []
            self.longitudes = []
            
            if (array?.count) != nil {
                for i in 0..<array!.count{
                    //street and house
                    self.addressStrings.append(jsondata[i]["properties"]["name"].string!)
                    //other details(city, country etc.)
                    self.detailedStrings.append(jsondata[i]["properties"]["description"].string!)
                    
                    var coordianates = jsondata[i]["geometry"]["coordinates"].array
                    self.longitudes.append((coordianates?[1].floatValue)!)
                    self.latitudes.append((coordianates?[0].floatValue)!)
                }
            }
            self.table.reloadData()
            
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addressField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return addressField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if addressField.text == "" {
            addressField.placeholder = "Где вы сдаёте квартиру?"
            addressStrings = []
            detailedStrings = []
            longitudes = []
            latitudes = []
            self.table.reloadData()
        }
    }
    
    func continueButtonAction() {
        print("continue...")
        print("long: \(RentAddressController.flatToRent.longitude), lat: \(RentAddressController.flatToRent.latitude)")
        performSegue(withIdentifier: "continue", sender: self)
    }
    
    func cancelButtonAction() {
        performSegue(withIdentifier: "cancelRent", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlatViewCell
        
        //view bounds
        let screen = self.view.frame
        
        //address big label
        cell.subwayLabel.text = "\(addressStrings[indexPath.row])"
        cell.subwayLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        cell.subwayLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightHeavy)
        cell.subwayLabel.frame = CGRect(x: 15.0, y: 10.0, width: screen.width - 30, height: 22.0)
        cell.subwayLabel.adjustsFontSizeToFitWidth = true
        
        //details small label
        cell.rooms.text = "\(detailedStrings[indexPath.row])"
        cell.rooms.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        cell.rooms.font = UIFont.systemFont(ofSize: 14.0)
        cell.rooms.frame = CGRect(x: 15.0, y: cell.subwayLabel.frame.maxY + 5.0, width: screen.width - 30, height: 16.0)
        cell.rooms.adjustsFontSizeToFitWidth = true
        
        cell.switchButton.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlatViewCell
        
        self.addressField.text = "\(addressStrings[indexPath.row])"
        RentAddressController.flatToRent.address = "\(addressStrings[indexPath.row])"
        RentAddressController.flatToRent.addressDetailedInfo = "\(detailedStrings[indexPath.row])"
        RentAddressController.flatToRent.longitude = "\(longitudes[indexPath.row])"
        RentAddressController.flatToRent.latitude = "\(latitudes[indexPath.row])"
        self.addressField.resignFirstResponder()
        addressStrings = []
        detailedStrings = []
        longitudes = []
        latitudes = []
        self.table.reloadData()
        cell.setSelected(false, animated: false)
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
