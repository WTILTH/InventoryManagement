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
    @IBOutlet weak var confirmPasswordView: UIView!
    var companyName: String?
    var phoneNumber: String?
    var countryCode: String?
    var emailID: String?
    var iconClick = false
    let imageIcon = UIImageView()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        confirmPasswordView.layer.cornerRadius = 20.0
        groupNameTxt.backgroundColor = UIColor.clear
       groupNameTxt.borderStyle = .none
        firstNameTxt.backgroundColor = UIColor.clear
       firstNameTxt.borderStyle = .none
        lastNameTxt.backgroundColor = UIColor.clear
       lastNameTxt.borderStyle = .none
        userNameTxt.backgroundColor = UIColor.clear
       userNameTxt.borderStyle = .none
        newPasswordTxt.backgroundColor = UIColor.clear
       newPasswordTxt.borderStyle = .none
        confirmPasswordTxt.backgroundColor = UIColor.clear
       confirmPasswordTxt.borderStyle = .none
        if let user = user {
          
            let phoneNumber = user.phoneNumber
            let countryCode = user.countryCode
            let companyName = user.companyName
            let emailID = user.emailID
            let deviceID = user.deviceID
            let sessionID = user.sessionID
        }
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 1.5
        let shadowOffset = CGSize(width: 0, height: 2)
        let shadowRadius: CGFloat = 4
        loginBtn.layer.shadowColor = shadowColor
       loginBtn.layer.shadowOpacity = shadowOpacity
        loginBtn.layer.shadowOffset = shadowOffset
        loginBtn.layer.shadowRadius = shadowRadius
        confirmPasswordView.layer.shadowColor = shadowColor
        confirmPasswordView.layer.shadowOpacity = shadowOpacity
        confirmPasswordView.layer.shadowOffset = shadowOffset
        confirmPasswordView.layer.shadowRadius = shadowRadius
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
        let underlineLayer = CALayer()
        underlineLayer.frame = CGRect(x: 0, y: groupNameTxt.frame.size.height - 1, width: groupNameTxt.frame.size.width, height: 1)
        underlineLayer.backgroundColor = UIColor.white.cgColor
        groupNameTxt.layer.addSublayer(underlineLayer)
        let underlineLayer1 = CALayer()
        underlineLayer1.frame = CGRect(x: 0, y: firstNameTxt.frame.size.height - 1, width: firstNameTxt.frame.size.width, height: 1)
        underlineLayer1.backgroundColor = UIColor.white.cgColor
        firstNameTxt.layer.addSublayer(underlineLayer1)
        let underlineLayer4 = CALayer()
        underlineLayer4.frame = CGRect(x: 0, y: lastNameTxt.frame.size.height - 1, width: lastNameTxt.frame.size.width, height: 1)
        underlineLayer4.backgroundColor = UIColor.white.cgColor
        lastNameTxt.layer.addSublayer(underlineLayer4)
        let underlineLayer2 = CALayer()
        underlineLayer2.frame = CGRect(x: 0, y: userNameTxt.frame.size.height - 1, width: userNameTxt.frame.size.width, height: 1)
        underlineLayer2.backgroundColor = UIColor.white.cgColor
        userNameTxt.layer.addSublayer(underlineLayer2)
        let underlineLayer3 = CALayer()
        underlineLayer3.frame = CGRect(x: 0, y: newPasswordTxt.frame.size.height - 1, width: newPasswordTxt.frame.size.width, height: 1)
        underlineLayer3.backgroundColor = UIColor.white.cgColor
        newPasswordTxt.layer.addSublayer(underlineLayer3)
        let underlineLayer5 = CALayer()
        underlineLayer5.frame = CGRect(x: 0, y: confirmPasswordTxt.frame.size.height - 1, width: confirmPasswordTxt.frame.size.width, height: 1)
        underlineLayer5.backgroundColor = UIColor.white.cgColor
        confirmPasswordTxt.layer.addSublayer(underlineLayer5)
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
        
        guard let groupName = groupNameTxt.text, !groupName.isEmpty else {

                    errorLbl.text = "Please enter group Name"

                    return

                }

                guard let firstName = firstNameTxt.text, !firstName.isEmpty else {

                    errorLbl.text = "Please enter first Name"

                    return

                }

                guard let lastName = lastNameTxt.text, !lastName.isEmpty else {

                    errorLbl.text = "Please enter last Name"

                    return

                }

                guard let userName = userNameTxt.text, !userName.isEmpty else {

                    errorLbl.text = "Please enter user Name"

                    return

                }

                guard let newPassword = newPasswordTxt.text, !newPassword.isEmpty else {

                    errorLbl.text = "Please enter new Password"

                    return

                }

                guard let confirmPassword = confirmPasswordTxt.text, !confirmPassword.isEmpty else {

                    errorLbl.text = "Please enter confirm Password"

                    return

                }

                

                guard let user = user else {

                    errorLbl.text = "All fields must be filled."

                    return

                }

                

                if validatePasswords() {

                    if !customCheckbox.isOn {

                        errorLbl.isHidden = false

                        errorLbl.text = "Please read and accept the terms and conditions."

                        return

                    }

                    

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

                        

                        let alertController = UIAlertController(title: "Success", message: "Successfully created an account.", preferredStyle: .alert)

                        

                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in

                            self.performSegue(withIdentifier: "passwordToLogin", sender: nil)

                        }

                        alertController.addAction(okAction)

                        

                        present(alertController, animated: true, completion: nil)

                    } catch let error as NSError {

                        print("Error saving data: \(error), \(error.userInfo)")

                    }

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

