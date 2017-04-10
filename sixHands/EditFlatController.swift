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
        backButton.frame = CGRect(x: 35, y: 30, width: 25, height: 25)
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
        
        api.flatsSingle(id: "350"){(js:Any) in
            let jsondata = js as! JSON
            let imageSize = CGSize(width: scrollViewSize.width * 0.6, height: scrollViewSize.height * 0.8)
            scrollView.contentSize.width = 55.0 + CGFloat(jsondata["photos"].array!.count) * (imageSize.width + 15.0)
            for i in 0..<jsondata["photos"].array!.count {
                let image = UIImageView()
                let dx = 35.0 + CGFloat(i) * (imageSize.width + 15.0)
                image.frame = CGRect(x: dx, y: 20.0, width: imageSize.width, height: imageSize.height)
                image.sd_setImage(with: URL(string: jsondata["photos"][i]["url"].string!))
                scrollView.addSubview(image)
                //self.photos.append(image.image!)
                
                let deleteButton = UIButton()
                let deleteButtonSize = CGSize(width: image.frame.width * 0.1, height: image.frame.width * 0.1)
                deleteButton.frame = CGRect(x: image.frame.maxX - deleteButtonSize.width / 2, y: image.frame.minY - deleteButtonSize.height / 2, width: deleteButtonSize.width, height: deleteButtonSize.height)
                deleteButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
                //yourButton.addTarget(self, action: #selector(), for: .touchUpInside)
                scrollView.addSubview(deleteButton)
            }
            
        }
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
