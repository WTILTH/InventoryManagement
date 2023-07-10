//
//  ForgotPasswordConfirmPassViewController.swift
//  Framily
//
//  Created by Tharun kumar on 05/07/23.
//

import UIKit

class ForgotPasswordConfirmPassViewController: UIViewController {

    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var FPConfirmPasswordTxt: UITextField!
    @IBOutlet weak var FPCreatePasswordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 1.5
        let shadowOffset = CGSize(width: 0, height: 2)
        let shadowRadius: CGFloat = 4
        
        FPConfirmPasswordTxt.layer.shadowColor = shadowColor
        FPConfirmPasswordTxt.layer.shadowOpacity = shadowOpacity
        FPConfirmPasswordTxt.layer.shadowOffset = shadowOffset
        FPConfirmPasswordTxt.layer.shadowRadius = shadowRadius
        
        FPCreatePasswordTxt.layer.shadowColor = shadowColor
        FPCreatePasswordTxt.layer.shadowOpacity = shadowOpacity
        FPCreatePasswordTxt.layer.shadowOffset = shadowOffset
        FPCreatePasswordTxt.layer.shadowRadius = shadowRadius
        
        confirmBtn.layer.shadowColor = shadowColor
        confirmBtn.layer.shadowOpacity = shadowOpacity
        confirmBtn.layer.shadowOffset = shadowOffset
        confirmBtn.layer.shadowRadius = shadowRadius
        
    }
    
    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ConfirmPassToMain", sender: "")
        showCustomAlertWith(message: "Password Updated", descMsg: "")
    }
    
   
}
