//
//  RentCommentController.swift
//  sixHands
//
//  Created by Nikita Guzhva on 05/06/2017.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import UIKit

class RentCommentController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var comment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        comment.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        print(numberOfChars)
        return numberOfChars < 501;
    }
    
    //dismiss keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Здесь можно писать всё, что вы считаете нужным сказать о квартире. Уложитесь в 500 символов." {
            textView.text = ""
            textView.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Здесь можно писать всё, что вы считаете нужным сказать о квартире. Уложитесь в 500 символов."
            textView.textColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        RentAddressController.flatToRent.comments = comment.text ?? "-"
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
