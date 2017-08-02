//
//  EditFlatController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 10/04/2017.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditFlatController: UIViewController {
    
    var flat_id = String()
    var segue = String()
    var api = API()
    var photos = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let screen = self.view.frame
        // Do any additional setup after loading the view.
        
        //gray bar
        let grayBar = UIView()
        grayBar.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 20.0)
        grayBar.backgroundColor = UIColor.black
        grayBar.alpha = 0.37
        self.view.addSubview(grayBar)
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: 28, y: 30, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "Back"), for: .normal)
        backButton.addTarget(self, action: #selector(EditFlatController.backAction), for: .touchUpInside)
        view.addSubview(backButton)
        
        let addPhoto = UIButton()
        let addPhotoSize = CGSize(width: 35, height: 30)
        addPhoto.frame = CGRect(x: screen.width - 30 - addPhotoSize.width, y: 30, width: addPhotoSize.width, height: addPhotoSize.height)
        addPhoto.setImage(#imageLiteral(resourceName: "addPhoto"), for: .normal)
        addPhoto.addTarget(self, action: #selector(EditFlatController.addPhotoAction), for: .touchUpInside)
        view.addSubview(addPhoto)
        
        let scrollView = UIScrollView()
        let scrollViewSize = CGSize(width: screen.width, height: screen.height * 0.25)
        scrollView.frame = CGRect(x: 0.0, y: backButton.frame.maxY + 5.0, width: scrollViewSize.width, height: scrollViewSize.height)
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
      
    }
    
    func backAction() {
        if segue == "profile" {
            performSegue(withIdentifier: "backToProfile", sender: self)
        } else {
            //performSegue(withIdentifier: "toList", sender: self)
        }
    }
    
    func addPhotoAction() {
        
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
