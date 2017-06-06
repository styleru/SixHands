//
//  NumbersContainer.swift
//  sixHands
//
//  Created by Nikita Guzhva on 31/05/2017.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class NumbersContainer: UIViewController {
    
    var vc : UIViewController!
    var segueIdentifier : String!
    var lastViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segueIdentifier = "rent1"
        self.performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    func segueIdentifierReceived(button: Int){
        if button == 2
        {
            
            self.segueIdentifier = "rent2"
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
            
        }
        else if button == 3
        {
            
            self.segueIdentifier = "rent3"
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        }
        else if button == 1
        {
            
            self.segueIdentifier = "rent1"
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        }
        else if button == 4
        {
            
            self.segueIdentifier = "rent4"
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            //Avoids creation of a stack of view controllers
            if lastViewController != nil {
                lastViewController.view.removeFromSuperview()
            }
            //Adds View Controller to Container "first" or "second"
            vc = segue.destination 
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width,height: self.view.frame.height)
            self.view.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
            lastViewController = vc
            
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
