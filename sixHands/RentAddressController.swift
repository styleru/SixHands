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
import CoreLocation

class RentAddressController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    let addressField = UITextField()
    //var addresses = [CLLocationCoordinate2D]()
    var addressString = String()
    var addressStrings = [String]()
    var detailedStrings = [String]()
    var longitudes = [Float]()
    var latitudes = [Float]()
    let table = UITableView()
    static var flatToRent = Flat()
    let separator = UIView()
    let locationManager = CLLocationManager()
    
    //view bounds
    let screen = UIScreen.main.bounds
    
    static var staticSelf: RentAddressController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        RentAddressController.staticSelf = self
        
        //address
        addressField.frame = CGRect(x: screen.minX + 50.0, y: 10, width: screen.width - 100.0, height: 40.0)
        addressField.delegate = self
        addressField.placeholder = "Где вы сдаёте квартиру?"
        addressField.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightLight)
        addressField.adjustsFontSizeToFitWidth = true
        addressField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.view.addSubview(addressField)
        
        let greyView = UIView()
        greyView.frame = CGRect(x: 0.0, y: addressField.frame.minY - 10, width: screen.width, height: 60)
        greyView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        greyView.layer.borderWidth = 1
        greyView.layer.borderColor = UIColor(red: 220/255.0, green:220/255.0, blue:220/255.0, alpha: 1.0).cgColor
        self.view.insertSubview(greyView, belowSubview: addressField)
        
        let border = UIView()
        border.frame = CGRect(x: 5.0, y: addressField.frame.minY, width: screen.width - 10, height: 40)
        border.backgroundColor = UIColor.clear
        border.layer.cornerRadius = 5.0
        border.clipsToBounds = true
        border.layer.borderWidth = 2
        border.layer.borderColor = UIColor(red: 220/255.0, green:220/255.0, blue:220/255.0, alpha: 1.0).cgColor
        self.view.insertSubview(border, belowSubview: addressField)
        
        let searchIcon = UIImageView()
        let searchIconSize = CGSize(width: 18, height: 18)
        searchIcon.frame = CGRect(x: border.frame.minX + 15, y: addressField.frame.midY - searchIconSize.width/2, width: searchIconSize.width, height: searchIconSize.height)
        searchIcon.image = #imageLiteral(resourceName: "searchIcon")
        self.view.addSubview(searchIcon)
        
        let locationButton = UIButton()
        let locationButtonSize = CGSize(width: 18, height: 18)
        locationButton.frame = CGRect(x: border.frame.maxX - 15 - locationButtonSize.width/2, y: addressField.frame.midY - locationButtonSize.width/2, width: locationButtonSize.width, height: locationButtonSize.height)
        locationButton.setImage(#imageLiteral(resourceName: "compass"), for: .normal)
        locationButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        view.addSubview(locationButton)
        
        //tableView for suggestions
        table.frame = CGRect(x: 0.0, y: greyView.frame.maxY, width: screen.width, height: screen.height - greyView.frame.maxY - 55.0 - 116.0)
        table.rowHeight = screen.height * 0.1
        table.delegate = self
        table.dataSource = self
        table.register(FlatViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorInset.left = 15.0
        table.separatorInset.right = 15.0
        table.tableFooterView = UIView()
        self.view.addSubview(table)
        
        separator.frame = CGRect(x: 0.0, y: greyView.frame.maxY-1.5, width: screen.width, height: 1.5)
        separator.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        self.view.addSubview(separator)
        
    }
    
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)-> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if placemarks?.count != 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(placemark: pm!)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        if placemark != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            print(placemark.name!)
            /*print(placemark.locality ? placemark.locality : "")
            print(placemark.postalCode ? placemark.postalCode : "")
            print(placemark.administrativeArea ? placemark.administrativeArea : "")
            print(placemark.country ? placemark.country : "")*/
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + (error.localizedDescription))
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (addressStrings.count != 0) {
            self.separator.isHidden = true
        } else {
            self.separator.isHidden = false
        }
        return addressStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlatViewCell
        
        //view bounds
        let screen = self.view.frame
        
        
        //for that ending separator(nailed it!)
        for sublayer in cell.layer.sublayers! {
            if sublayer.name == "separator" {
                sublayer.removeFromSuperlayer()
            }
        }
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: cell.frame.size.height - 1, width: cell.frame.size.width, height: 1)
        bottomBorder.name = "separator"
        cell.layer.addSublayer(bottomBorder)
        
        if(indexPath.row == addressStrings.count-1) {
            bottomBorder.frame = CGRect(x: 0, y: cell.frame.size.height - 1.5, width: cell.frame.size.width, height: 1.5)
            bottomBorder.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        } else {
            bottomBorder.frame = CGRect(x: 15, y: cell.frame.size.height - 1, width: cell.frame.size.width - 30, height: 1)
            bottomBorder.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0).cgColor
        }
        
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
        if let controller = MasterContainer.staticSelf {
            controller.continueButton.backgroundColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
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
