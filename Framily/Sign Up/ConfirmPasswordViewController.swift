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
    @IBOutlet weak var strengthProgressView : UIProgressView!
    
    var responseData1: [String: Any]?
    var responseData: [String: Any]?
    var usernameCounter = 1
    var isPasswordValid: Bool = false
    var deviceID: String?
    var sessionID: String?
    var devicePlatform: String?
  //  var companyName: String?
  //  var phoneNumber: String?
   // var countryCode: String?
   // var emailID: String?
    var groupName: String?
    var iconClick = false
    let imageIcon = UIImageView()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(responseData as Any,"hi")
        
        if let responseData = responseData, let body = responseData["body"] as? [String: Any] {
            groupName = body["groupName"] as? String ?? ""
            groupNameTxt.text = groupName
        }
        firstNameTxt.delegate = self
        newPasswordTxt.addTarget(self, action: #selector(passwordEditingChanged(_:)), for: .editingChanged)
        newPasswordTxt.delegate = self
        self.strengthProgressView.setProgress(0, animated: true)
        self.errorLbl.textColor = UIColor.red
        self.errorLbl.text = ""
        self.errorLbl.isHidden = true
        
        confirmPasswordTxt.delegate = self
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        groupNameTxt.layer.cornerRadius = 5
        firstNameTxt.layer.cornerRadius = 5
        lastNameTxt.layer.cornerRadius = 5
        userNameTxt.layer.cornerRadius = 5
        newPasswordTxt.layer.cornerRadius = 5
        confirmPasswordTxt.layer.cornerRadius = 5
       // groupNameTxt.backgroundColor = UIColor.clear
        groupNameTxt.borderStyle = .none
      //  firstNameTxt.backgroundColor = UIColor.clear
        firstNameTxt.borderStyle = .none
       // lastNameTxt.backgroundColor = UIColor.clear
        lastNameTxt.borderStyle = .none
      //  userNameTxt.backgroundColor = UIColor.clear
        userNameTxt.borderStyle = .none
       // newPasswordTxt.backgroundColor = UIColor.clear
        newPasswordTxt.borderStyle = .none
       // confirmPasswordTxt.backgroundColor = UIColor.clear
        confirmPasswordTxt.borderStyle = .none
       /* if let user = user {
            
            let phoneNumber = user.phoneNumber
            let countryCode = user.countryCode
            let companyName = user.companyName
            let emailID = user.emailID
            let deviceID = user.deviceID
            let sessionID = user.sessionID
            let groupName = user.groupName
        }*/
        
        if newPasswordTxt.text?.isEmpty ?? true {
            self.strengthProgressView.setProgress(0, animated: false)
        }
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 1.5
        let shadowOffset = CGSize(width: 0, height: 2)
        let shadowRadius: CGFloat = 4
        loginBtn.layer.shadowColor = shadowColor
        loginBtn.layer.shadowOpacity = shadowOpacity
        loginBtn.layer.shadowOffset = shadowOffset
        loginBtn.layer.shadowRadius = shadowRadius
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
       /* let underlineLayer = CALayer()
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
        confirmPasswordTxt.layer.addSublayer(underlineLayer5)*/
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
        
        
        customCheckbox.checkboxValueChangedBlock = {
            isOn in
            print("Custom checkbox is \(isOn ? "ON" : "OFF")")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func infoUserNameBtnPressed(_ sender: Any) {
        let alert = showCustomAlertWith(message: "User Name", descMsg: "The user name can be edited.")
        
    }
    @IBAction func infoPasswordBtnPressed(_ sender: Any) {
        let alertController = showCustomAlertWith(message: "Password credentials", descMsg: "Min. 8 to 14 characters long, A combination of uppercase letters, lowercase letters, numbers, and symbols.")
        
    }
    @objc func submitButtonTapped() {
        errorLbl.text = ""
        errorLbl.isHidden = false
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
            
            guard let password = newPasswordTxt.text, !password.isEmpty else {
                errorLbl.text = "Please enter new Password"
                return
            }
            
            guard let confirmPassword = confirmPasswordTxt.text, !confirmPassword.isEmpty else {
                errorLbl.text = "Please enter confirm Password"
                return
            }
            
         //   guard let user = user else {
          //      errorLbl.text = "All fields must be filled."
          //      return
          //  }
            
            // Check if passwords match
            if password == confirmPassword {
                
                if validatePasswords() {
                    
                    if !customCheckbox.isOn {
                        errorLbl.isHidden = false
                        errorLbl.text = "Please read and accept the terms and conditions."
                        return
                    }
                    
                 /*   // Save the user details
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
                        
                        printSavedData()*/
                    print("Sending signup request to API...")
                    signUpUser(groupName: groupName, firstName: firstName, lastName: lastName, userName: userName, password: password, responseData: responseData)
                      /*  let alertController = UIAlertController(title: "Success", message: "Successfully created an account.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            self.performSegue(withIdentifier: "passwordToLogin", sender: nil)
                        }
                        alertController.addAction(okAction)
                        present(alertController, animated: true, completion: nil)
                        
                    } catch let error as NSError {
                        print("Error saving data: \(error), \(error.userInfo)")
                    }*/
                } else {
                    errorLbl.isHidden = false
                    errorLbl.text = "Passwords do not match the criteria."
                }
                
            } else {
                errorLbl.isHidden = false
                errorLbl.text = "Passwords do not match."
            }
        }
    func signUpUser(groupName: String, firstName: String, lastName: String,userName: String,password: String, responseData: [String: Any]?) {
                let apiURL = URL(string: "http://192.168.29.7:8080/userRegister")!
            
                var request = URLRequest(url: apiURL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        let sessionID = UUID().uuidString
        let platform = UIDevice.current.model
        
        var emailID: String = ""
        var phoneNumber: String = ""
        if let responseData = responseData, let body = responseData["body"] as? [String: Any] {
            emailID = body["emailID"] as? String ?? ""
            phoneNumber = body["phoneNumber"] as? String ?? ""
        }

        let userRegistrationRequest: [String: Any] = [
            "emailID": emailID,
            "phoneNumber": phoneNumber,
            "groupName": groupName,
            "firstName": firstName,
            "lastName": lastName,
            "userName": userName,
            "password": password,
        ]

        let deviceRegistrationRequest: [String: Any] = [
            "sessionID": sessionID,
            "platform": platform,
            "deviceID": deviceID,
        ]

        let requestData: [String: Any] = [
                "userRegistrationRequest": userRegistrationRequest,
                "deviceRegistrationRequest": deviceRegistrationRequest,
            ]
      
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData, options: [])
        } catch {
            print("Error creating request body: \(error)")
            return
        }
        if let dataString = String(data: request.httpBody ?? Data(), encoding: .utf8) {
            print("Data being sent to the API: \(dataString)")
        }
                let credentials = "arun:arun1"
                    let credentialsData = credentials.data(using: .utf8)!
                    let base64Credentials = credentialsData.base64EncodedString()
                    request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
                    let session = URLSession.shared
                    let task = session.dataTask(with: request) { data, response, error in
                        if let error = error {
                            print("Error: \(error)")
                            
                            return
                        }
                        
                        if let httpResponse = response as? HTTPURLResponse,
                           (200...299).contains(httpResponse.statusCode) {
                            
                            if let responseData = data {
                                do {
                                    let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                                    print("Response: \(jsonObject)")
                                 
                                    if let responseDict = jsonObject as? [String: Any],
                                       let success = responseDict["success"] as? Bool, success {
                                       
                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "passwordToLogin", sender: nil)
                                        }
                                    } else {
                                        
                                        DispatchQueue.main.async {
                                                        
                                            self.showCustomAlertWith(message:" Server Error", descMsg: "There was a problem with the server. Please try again later.")
                                                    }
                                    }
                                    
                                }catch {
                                    print("Error parsing response data: \(error)")
                                }
                            }
                        } else {
                            print("Invalid HTTP response: \(response?.description ?? "")")
                            
                        }
                    }
                    task.resume()
                print("Sending signup request to API...")
                }
    
    func validatePasswords() -> Bool {
        guard let newPassword = newPasswordTxt.text,
              let confirmPassword = confirmPasswordTxt.text else {
            return false
        }
        
        if newPassword.count < 8 || newPassword.count > 14 {
            showCustomAlertWith(message: "Password length should be between 8 and 14 characters, Should have Upper Case and Lower Case and Special character", descMsg: "")
            return false
        }
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,14}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !passwordPredicate.evaluate(with: newPassword) {
            showCustomAlertWith(message: "Password requirements are not satisfied", descMsg: "")
            return false
        }
        
        return true
    }
    
    @IBAction func confirmPssword(_ sender: Any) {
    }
    @objc func passwordEditingChanged(_ textField: UITextField) {
        if textField == newPasswordTxt {
            if let password = textField.text, !password.isEmpty {
                self.errorLbl.isHidden = false
                self.errorLbl.alpha = 0
                
                let validationId = PasswordStrengthManager.checkValidationWithUniqueCharacter(pass: password, rules: PasswordRules.passwordRule, minLength: PasswordRules.minPasswordLength, maxLength: PasswordRules.maxPasswordLength)
                UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                    self?.errorLbl.alpha = CGFloat(validationId.alpha)
                    self?.errorLbl.text = validationId.text
                })
                
                let progressInfo = PasswordStrengthManager.setProgressView(strength: validationId.strength)
                self.isPasswordValid = progressInfo.shouldValid
                self.strengthProgressView.setProgress(progressInfo.percentage, animated: true)
                self.strengthProgressView.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
            } else {
                self.errorLbl.isHidden = true
                self.strengthProgressView.setProgress(0, animated: false)
            }
        }
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "passwordToLogin"{
                
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == firstNameTxt {
                
                DispatchQueue.main.async {
                    self.generateUsername()
                }
            }
            if textField == newPasswordTxt {
                if let currentText = textField.text,
                   let range = Range(range, in: currentText) {
                    let updatedText = currentText.replacingCharacters(in: range, with: string)
                    if !updatedText.isEmpty {
                        self.errorLbl.isHidden = false
                        self.errorLbl.alpha = 0
                        
                        let validationId = PasswordStrengthManager.checkValidationWithUniqueCharacter(pass: updatedText, rules: PasswordRules.passwordRule, minLength: PasswordRules.minPasswordLength, maxLength: PasswordRules.maxPasswordLength)
                        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                            self?.errorLbl.alpha = CGFloat(validationId.alpha)
                            self?.errorLbl.text = validationId.text
                        })
                        
                        let progressInfo = PasswordStrengthManager.setProgressView(strength: validationId.strength)
                        self.isPasswordValid = progressInfo.shouldValid
                        self.strengthProgressView.setProgress(progressInfo.percentage, animated: true)
                        self.strengthProgressView.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
                    } else {
                        self.errorLbl.isHidden = true
                        self.strengthProgressView.setProgress(0, animated: false)
                    }
                }
            }
            
            return true
        }
    func generateUsername() {
            if let firstName = firstNameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines), !firstName.isEmpty {
                
                let randomNumber = String(format: "%02d", Int(arc4random_uniform(100)))
                let username = "\(firstName)\(randomNumber)"
         
                userNameTxt.text = username
            } else {
                
                userNameTxt.text = ""
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
