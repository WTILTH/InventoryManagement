//
//  ConfirmPasswordViewController.swift
//  Framily
//
//  Created by Varun kumar on 05/07/23.
//

import UIKit

class ConfirmPasswordViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var newPasswordTxt: UITextField!
    
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var iconClick = false
    let imageIcon = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius=10.0
        loginBtn.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        imageIcon.image = UIImage(named: "closeEye")
                let contentView = UIView()
                contentView.addSubview(imageIcon)
                
                contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
                
                imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
                confirmPasswordTxt.rightView = contentView
                confirmPasswordTxt.rightViewMode = .always
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                imageIcon.isUserInteractionEnabled = true
                imageIcon.addGestureRecognizer(tapGestureRecognizer)
                
            }
            
            
            @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer)
            {
                
                let tappedImage = tapGestureRecognizer.view as! UIImageView
                
                if iconClick
                {
                    iconClick = false
                    tappedImage.image = UIImage(named: "openEye")
                    confirmPasswordTxt.isSecureTextEntry = false
                }
                
                else {
                    
                    iconClick = true
                    tappedImage.image = UIImage(named: "closeEye")
                    confirmPasswordTxt.isSecureTextEntry = true
                    
                }
                
            
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func submitButtonTapped() {
        if validatePasswords() {
            errorLbl.isHidden = true
           performSegue(withIdentifier: "credentialToPasswordUpdated", sender: nil)
        } else {
            errorLbl.isHidden = false
            errorLbl.text = "Passwords do not match"
           
        }
    }
   
    func validatePasswords() -> Bool {
        guard let newPassword = newPasswordTxt.text,
              let confirmPassword = confirmPasswordTxt.text else {
            return false
        }
        
        if newPassword != confirmPassword {
            return false
        }
        return true
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "credentialToPasswordUpdated"{
        
        }
    }
   
}
