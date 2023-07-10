//
//  ConfirmPasswordViewController.swift
//  Framily
//
//  Created by Varun kumar on 05/07/23.
//

import UIKit
import CoreData

class ConfirmPasswordViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var newPasswordTxt: UITextField!
    @IBOutlet weak var groupNameTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var customCheckbox: VKCheckbox!
    
    var iconClick = false
    let imageIcon = UIImageView()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
                customCheckbox.line             = .thin
                customCheckbox.bgColorSelected  = UIColor(red: 46/255, green: 119/255, blue: 217/255, alpha: 1)
                customCheckbox.bgColor          = UIColor.gray
                customCheckbox.color            = UIColor.white
                customCheckbox.borderColor      = UIColor.white
                customCheckbox.borderWidth      = 2
                customCheckbox.cornerRadius     = customCheckbox.frame.height / 2
                
                // Handle custom checkbox callback
                customCheckbox.checkboxValueChangedBlock = {
                    isOn in
                    print("Custom checkbox is \(isOn ? "ON" : "OFF")")
                }
            
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func submitButtonTapped() {
        guard let groupName = groupNameTxt.text, !groupName.isEmpty,
              
                let firstName = firstNameTxt.text, !firstName.isEmpty,
              
                let lastName = lastNameTxt.text, !lastName.isEmpty,
              
                let userName = userNameTxt.text,!userName.isEmpty,
              
                let newPassword = newPasswordTxt.text,!newPassword.isEmpty,
              
                let confirmPassword = confirmPasswordTxt.text,!confirmPassword.isEmpty
        else {
            
            errorLbl.text = "All fields must be filled."
            
            return
            
        }
        if validatePasswords() {
            errorLbl.isHidden = true
           performSegue(withIdentifier: "passwordToLogin", sender: nil)
        } else {
            errorLbl.isHidden = false
            errorLbl.text = "Passwords do not match"
           
        }
      /*  let confirmPassword = confirmPasswordTxt.text, confirmPassword
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "confirmPassword == %@",confirmPassword)
        
        do {
            let matchingUsers = try managedContext.fetch(fetchRequest)
            
            if matchingUsers.isEmpty {
                
                let User = User(context: managedContext)
                User.confirmPassword = confirmPassword

                do {
                    try managedContext.save()
                    print("Data saved successfully!")
                    
                    confirmPasswordTxt.text = ""
                    
                    print("confirmPassword: \(User.confirmPassword ?? "")")
        
                } catch let error as NSError {
                    print("Error saving data: \(error), \(error.userInfo)")
                }
          
                
            } else {
               
                confirmPasswordTxt.text = ""
                
            }
            
        } catch let error as NSError {
            print("Error fetching data: \(error), \(error.userInfo)")
        }*/
        
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
        if segue.identifier == "passwordToLogin"{
        
        }
    }
   
}
