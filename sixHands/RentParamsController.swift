//
//  RentParamsController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 08.02.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class RentParamsController: UIViewController, UITextFieldDelegate {

    var params = [String]()
    static var paramsValues = [Int]()

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var content: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view bounds
        let screen = self.view.frame
        
        params = ["Холодильник", "Интернет", "Телевизор", "Парковка", "Кондиционер", "Стиральная машина", "Посудомоечная машина", "Животные"]
        RentParamsController.paramsValues = [0, 0, 0, 0, 0]
        
        scroll.contentSize.height = 1000
    }
    
    @IBAction func first(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            RentParamsController.paramsValues[sender.tag] = 1
        } else {
            sender.isSelected = false
            RentParamsController.paramsValues[sender.tag] = 0
        }
        print(RentParamsController.paramsValues)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
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
    }
    
    func continueButtonAction() {
        print("continue...")
        RentAddressController.flatToRent.conditioning = "\(RentParamsController.paramsValues[4])"
        RentAddressController.flatToRent.fridge = "\(RentParamsController.paramsValues[0])"
        RentAddressController.flatToRent.internet = "\(RentParamsController.paramsValues[1])"
        RentAddressController.flatToRent.tv = "\(RentParamsController.paramsValues[2])"
        RentAddressController.flatToRent.parking = "\(RentParamsController.paramsValues[3])"
        //RentAddressController.flatToRent.numberOfRoomsInFlat = roomsField.text!
        //RentAddressController.flatToRent.square = squareField.text!
        RentAddressController.flatToRent.stiralka = "\(RentParamsController.paramsValues[5])"
        RentAddressController.flatToRent.posudomoyka = "\(RentParamsController.paramsValues[6])"
        RentAddressController.flatToRent.animals = "\(RentParamsController.paramsValues[7])"
        performSegue(withIdentifier: "lastStep", sender: self)
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
