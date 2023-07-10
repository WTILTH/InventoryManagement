//
//  ForgotPasswordConfirmPasswordViewController.swift
//  Framily
//
//  Created by Varun kumar on 10/07/23.
//

import UIKit

class ForgotPasswordConfirmPassViewController: UIViewController {
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var FPConfirmPasswordTxt: UITextField!
    @IBOutlet weak var FPCreatePasswordTxt: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    var iconClick = false
    let imageIcon = UIImageView()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmBtn.layer.cornerRadius=10.0
        confirmBtn.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        imageIcon.image = UIImage(named: "closeEye")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
        
        imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
        FPConfirmPasswordTxt.rightView = contentView
        FPConfirmPasswordTxt.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
        
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
    @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer)
    {
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if iconClick
        {
            iconClick = false
            tappedImage.image = UIImage(named: "openEye")
            FPConfirmPasswordTxt.isSecureTextEntry = false
        }
        
        else {
            
            iconClick = true
            tappedImage.image = UIImage(named: "closeEye")
            FPConfirmPasswordTxt.isSecureTextEntry = true
            
        }
        
        
    }
    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "FPtoMAIN", sender: "")
        showCustomAlertWith(message: "Password Updated", descMsg: "")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func submitButtonTapped() {
        if validatePasswords() {
            errorLabel.isHidden = true
            performSegue(withIdentifier: "FPtoMAIN", sender: nil)
        } else {
            errorLabel.isHidden = false
            errorLabel.text = "Passwords do not match"
            
        }
        func validatePasswords() -> Bool {
            guard let newPassword = FPCreatePasswordTxt.text,
                  let confirmPassword = FPConfirmPasswordTxt.text else {
                return false
            }
            
            if newPassword != confirmPassword {
                return false
            }
            return true
        }
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "FPtoMAIN"{
                
            }
        }
        
    }
}
