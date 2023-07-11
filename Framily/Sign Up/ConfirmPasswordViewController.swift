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
    @IBOutlet weak var infoPasswordBtn: UIButton!
    var companyName: String?
    var phoneNumber: String?
    var emailID: String?
    var iconClick = false
    let imageIcon = UIImageView()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
          
            let phoneNumber = user.phoneNumber
            let companyName = user.companyName
            let emailID = user.emailID
            let deviceID = user.deviceID
            let sessionID = user.sessionID
        }
        
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
    
    @IBAction func infoPasswordBtnPressed(_ sender: Any) {
            let alertController = UIAlertController(title: "Required", message: "Min. 8 to 14 characters long, A combination of uppercase letters, lowercase letters, numbers, and symbols.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        
        
    }
    @objc func submitButtonTapped() {
        guard let groupName = groupNameTxt.text, !groupName.isEmpty,
        let firstName = firstNameTxt.text, !firstName.isEmpty,
        let lastName = lastNameTxt.text, !lastName.isEmpty,
        let userName = userNameTxt.text, !userName.isEmpty,
        let newPassword = newPasswordTxt.text, !newPassword.isEmpty,
        let confirmPassword = confirmPasswordTxt.text, !confirmPassword.isEmpty,
        let user = user
        else {
      
      errorLbl.text = "All fields must be filled."
      return
  }
  
  if !customCheckbox.isOn {
      errorLbl.isHidden = false
      errorLbl.text = "Please read and accept the terms and conditions."
      return
  }
  
  if validatePasswords() {
      errorLbl.isHidden = true
      user.groupName = groupName
      user.firstName = firstName
      user.lastName = lastName
      user.userName = userName
      user.password = newPassword

      do {
          try managedContext.save()
          print("Data saved successfully!")
          confirmPasswordTxt.text = ""
          userNameTxt.text = ""
          newPasswordTxt.text = ""
          lastNameTxt.text = ""
          firstNameTxt.text = ""
          groupNameTxt.text = ""

          printSavedData()
      } catch let error as NSError {
          print("Error saving data: \(error), \(error.userInfo)")
      }
      let alertController = UIAlertController(title: "Success", message: "Successfully created an account.", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                  self.performSegue(withIdentifier: "passwordToLogin", sender: nil)
              }
              alertController.addAction(okAction)
              
              present(alertController, animated: true, completion: nil)
      
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
       
      //  if newPassword.count < 8 || newPassword.count > 14 {
        //    return false
       // }
       // let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,14}$"
        //let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
       // if !passwordPredicate.evaluate(with: newPassword) {
       //     return false
       // }
        
        if newPassword != confirmPassword {
            return false
        }
        
        return true
    }

        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passwordToLogin"{
        
        }
    }
    func printSavedData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let savedUsers = try managedContext.fetch(fetchRequest)
            for user in savedUsers {
               
                print("Group Name: \(user.groupName ?? "")")
                print("First Name: \(user.firstName ?? "")")
                print("Last Name: \(user.lastName ?? "")")
                print("User Name: \(user.userName ?? "")")
                print("Password: \(user.password ?? "")")
                
              
            }
        } catch let error as NSError {
            print("Error fetching data: \(error), \(error.userInfo)")
        }
    }
   
}

