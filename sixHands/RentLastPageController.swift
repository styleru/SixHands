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

class RentLastPageController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let api = API()
    var photos = [UIImage]()
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var justLabel: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var collection: UICollectionView!
    var photoSize = CGFloat()
    
    static var staticSelf: RentLastPageController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        RentLastPageController.staticSelf = self
        //view bounds
        photoSize = (100 / 375) * self.view.frame.width
        
        photos.append(UIImage(named: "addicon")!)
        
        let flow = collection.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumLineSpacing = 4
        flow.minimumInteritemSpacing = 4
        flow.itemSize = CGSize(width: photoSize, height: photoSize)
        flow.sectionInset = UIEdgeInsets(top: 0, left: (self.view.frame.width - photoSize - 5)/2, bottom: 0, right: 0)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.frame.size = CGSize(width: photoSize, height: photoSize)
        let imageview = UIImageView(frame: CGRect(x: 0, y: 5, width: photoSize - 5, height: photoSize - 5))
        imageview.image = photos[indexPath.item]
        imageview.tag = 100
        cell.contentView.addSubview(imageview)
        
        if indexPath.row != 0 {
            let yourView = UIButton()
            let yourViewSize = CGSize(width: 25, height: 25)
            yourView.frame = CGRect(x: photoSize - 25, y: 0, width: yourViewSize.width, height: yourViewSize.height)
            yourView.setImage(UIImage(named: "82"), for: .normal)
            yourView.addTarget(self, action: #selector(RentLastPageController.deletePhoto(_:)), for: .touchUpInside)
            yourView.tag = indexPath.item
            cell.contentView.addSubview(yourView)
        } else {
            for subview in cell.contentView.subviews {
                if subview.tag != 100 {
                    subview.removeFromSuperview()
                } else {
                    let img = subview as! UIImageView
                    if img.image != photos[0] {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let cameraAction = UIAlertAction(title: "Камера", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                self.snap()
            }
            alertController.addAction(cameraAction)
            
            let libraryAction = UIAlertAction(title: "Медиатека", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                self.choose()
            }
            alertController.addAction(libraryAction)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel)
            {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(cancelAction)
            
            if photos.count < 21 {
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
        photos.insert(image, at: 1)
        RentAddressController.flatToRent.photos.append(UIImageJPEGRepresentation(image,1)!)
        justLabel.text = "\(photos.count - 1) фотографий"
        if photos.count == 21 {
            justLabel.text = "\(photos.count - 1) фотографий (максимум)"
            photos[0] = UIImage(named: "7")!
        }
        let flow = collection.collectionViewLayout as! UICollectionViewFlowLayout
        if photos.count == 1 {
            flow.sectionInset = UIEdgeInsets(top: 0, left: (self.view.frame.width - photoSize - 5)/2, bottom: 0, right: 0)
        } else if photos.count == 2 {
            flow.sectionInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 55)
        } else {
            flow.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 20)
        }
        justLabel.sizeToFit()
        justLabel.frame.origin.x = self.view.frame.width/2 - justLabel.frame.width/2
        
        collection.reloadData()
        if (photos.count - 1) % 3 == 0 && photos.count > 9  {
            DispatchQueue.main.async {
                self.scroll.contentSize.height += 109
                self.collection.frame.size.height += 109
            }
        }
        
        if let controller = MasterContainer.staticSelf {
            controller.continueButton.backgroundColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photos.insert(pickedImage, at: 1)
            RentAddressController.flatToRent.photos.append(UIImageJPEGRepresentation(pickedImage,1)!)
            justLabel.text = "\(photos.count - 1) фотографий"
            if photos.count == 21 {
                justLabel.text = "\(photos.count - 1) фотографий (максимум)"
                photos[0] = UIImage(named: "7")!
            }
            let flow = collection.collectionViewLayout as! UICollectionViewFlowLayout
            if photos.count == 1 {
                flow.sectionInset = UIEdgeInsets(top: 0, left: (self.view.frame.width - 100)/2, bottom: 0, right: 0)
            } else if photos.count == 2 {
                flow.sectionInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 55)
            } else {
                flow.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 20)
            }
            justLabel.sizeToFit()
            justLabel.frame.origin.x = self.view.frame.width/2 - justLabel.frame.width/2
            
            collection.reloadData()
            if (photos.count - 1) % 3 == 0 && photos.count > 9  {
                DispatchQueue.main.async {
                    self.scroll.contentSize.height += 109
                    self.collection.frame.size.height += 109
                }
            }
            
            if let controller = MasterContainer.staticSelf {
                controller.continueButton.backgroundColor = UIColor(red: 85/255, green: 197/255, blue: 183/255, alpha: 1)
            }
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func deletePhoto(_ sender: UIButton) {
        photos.remove(at: sender.tag)
        collection.reloadData()
        if (photos.count) % 3 == 0 && photos.count > 8  {
            DispatchQueue.main.async {
                self.scroll.contentSize.height -= 109
                self.collection.frame.size.height -= 109
            }
        }
        let flow = collection.collectionViewLayout as! UICollectionViewFlowLayout
        if photos.count == 1 {
            flow.sectionInset = UIEdgeInsets(top: 0, left: (self.view.frame.width - 100)/2, bottom: 0, right: 0)
        } else if photos.count == 2 {
            flow.sectionInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 55)
        } else {
            flow.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 20)
        }
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
