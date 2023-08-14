//
//  ForgotPasswordConfirmPasswordViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Varun kumar on 05/07/23.
//
//  Module : Login
import UIKit
import CoreData
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | UX and Validation
0.2   | 14-Aug-2023  | Tharun Kumar    | Logics
Changes:
 
 */
class ForgotPasswordConfirmPassViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var FPConfirmPasswordTxt: UITextField!
    @IBOutlet weak var FPCreatePasswordTxt: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var forgotPasswordStrengthProgressView: UIProgressView!
    
    var responseData: [String: Any]?
    var isPasswordValid: Bool = false
    var user: User?
    var iconClick = false
    let imageIcon = UIImageView()
    var modifiedDate: String = ""
    var emailID: String = ""
   // let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FPCreatePasswordTxt.addTarget(self, action: #selector(passwordEditingChanged(_:)), for: .editingChanged)
        FPCreatePasswordTxt.delegate = self
        self.forgotPasswordStrengthProgressView.setProgress(0, animated: true)
        self.errorLabel.textColor = UIColor.red
        self.errorLabel.text = ""
        self.errorLabel.isHidden = true
        
        print(responseData)
        if let responseData = responseData, let body = responseData["body"] as? [String: Any] {
            emailID = body["emailID"] as? String ?? ""
        }
        FPConfirmPasswordTxt.delegate = self
       // FPCreatePasswordTxt.backgroundColor = UIColor.clear
        FPCreatePasswordTxt.borderStyle = .none
       // FPConfirmPasswordTxt.backgroundColor = UIColor.clear
        FPConfirmPasswordTxt.borderStyle = .none
        FPCreatePasswordTxt.layer.cornerRadius = 5
        FPConfirmPasswordTxt.layer.cornerRadius = 5
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        confirmBtn.layer.cornerRadius=10.0
        
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
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
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
        /*let underlineLayer = CALayer()
        underlineLayer.frame = CGRect(x: 0, y: FPCreatePasswordTxt.frame.size.height - 1, width: FPCreatePasswordTxt.frame.size.width, height: 1)
        underlineLayer.backgroundColor = UIColor.white.cgColor
        FPCreatePasswordTxt.layer.addSublayer(underlineLayer)
        let underlineLayer1 = CALayer()
        underlineLayer1.frame = CGRect(x: 0, y: FPConfirmPasswordTxt.frame.size.height - 1, width: FPConfirmPasswordTxt.frame.size.width, height: 1)
        underlineLayer1.backgroundColor = UIColor.white.cgColor
        FPConfirmPasswordTxt.layer.addSublayer(underlineLayer1)*/
    }
    // MARK: - imageTapped: Function to toggle password visibility when the eye icon is tapped
    @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer){
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
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - passwordInfoBtn: Function for the showing an alert for the password credentials
    @IBAction func passwordInfoBtn(_ sender: Any) {
        let alertController = showCustomAlertWith(message: "Password credentials", descMsg: "Min. 8 to 14 characters long, A combination of uppercase letters, lowercase letters, numbers, and symbols.")
    }
    // MARK: - ConfirmButtonTapped: Function to handle the "Login" button tap
    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        
        guard let newPassword = FPCreatePasswordTxt.text, !newPassword.isEmpty else {
            showCustomAlertWith(message: "Please enter a new password", descMsg: "")
            return
        }
        guard let confirmPassword = FPConfirmPasswordTxt.text, !confirmPassword.isEmpty else {
            showCustomAlertWith(message: "Please enter a confirm Password", descMsg: "")
            return
        }
        
        guard validatePasswords() else {
            errorLabel.isHidden = false
            errorLabel.text = "Passwords do not match"
            return
        }
        print("Sending signup request to API...")
        passwordAPI(emailID: emailID, confirmPassword: confirmPassword, modifiedDate: modifiedDate)
       // performSegue(withIdentifier: "FPtoMAIN", sender: nil)
       //     showCustomAlertWith(message: "Password Updated", descMsg: "")
        
    }
    // MARK: - passwordAPI: Function to send a sign-up request to the API
    func passwordAPI(emailID: String, confirmPassword: String, modifiedDate: String) {
        let apiURL = URL(string: "https://192.168.29.7:8080/passwordUpdate")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
       
        let currentDate = Date()
        let dateFormatter = ISO8601DateFormatter()
        let modifiedDate = dateFormatter.string(from: currentDate)
        
        let parameters: [String: Any] = [
            "emailID": emailID,
            "password": confirmPassword,
            "modifiedDate": modifiedDate
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error creating request body: \(error)")
            return
        }
        
        let credentials = "arun:arun1"
        let credentialsData = credentials.data(using: .utf8)!
        let base64Credentials = credentialsData.base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                // Handle network error appropriately
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("HTTP Status Code: \(statusCode)")
                
                if (200...299).contains(statusCode) {
                    if let responseData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                            print("Response: \(jsonObject)")
                         
                            if let responseDict = jsonObject as? [String: Any],
                               let success = responseDict["success"] as? Bool, success {
                               
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "FPtoMAIN", sender: nil)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Server Error", descMsg: "There was a problem with the server. Please try again later.")
                                }
                            }
                            
                        } catch {
                            print("Error parsing response data: \(error)")
                        }
                    }
                } else if (400...499).contains(statusCode) {
                    if let responseData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                            print("Response: \(jsonObject)")
                            
                            if let responseDict = jsonObject as? [String: Any], let body = responseDict["body"] as? String {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: body, descMsg: "")
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Client Error", descMsg: "An error occurred while processing the response.")
                                }
                            }
                            
                        } catch {
                            print("Error parsing response data: \(error)")
                            DispatchQueue.main.async {
                                self.showCustomAlertWith(message: "Client Error", descMsg: "An error occurred while processing the response.")
                            }
                        }
                    }
                } else {
                    print("Invalid HTTP response: \(httpResponse)")
                    DispatchQueue.main.async {
                        self.showCustomAlertWith(message: "Server Error", descMsg: "An unknown error occurred.")
                    }
                }
            }
        }
        
        task.resume()
        print("Sending signup request to API...")
    }
    // MARK: - validatePasswords: Function to validate the password
    func validatePasswords() -> Bool {
        guard let newPassword = FPCreatePasswordTxt.text,
              let confirmPassword = FPConfirmPasswordTxt.text else {
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
    // MARK: - passwordEditingChanged: Function to show the strenth meter based on the password typed in the the text field
    @objc func passwordEditingChanged(_ textField: UITextField) {
        if textField == FPCreatePasswordTxt {
            if let password = textField.text, !password.isEmpty {
                self.errorLabel.isHidden = false
                self.errorLabel.alpha = 0
                
                let validationId = PasswordStrengthManager.checkValidationWithUniqueCharacter(pass: password, rules: PasswordRules.passwordRule, minLength: PasswordRules.minPasswordLength, maxLength: PasswordRules.maxPasswordLength)
                UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                    self?.errorLabel.alpha = CGFloat(validationId.alpha)
                    self?.errorLabel.text = validationId.text
                })
                
                let progressInfo = PasswordStrengthManager.setProgressView(strength: validationId.strength)
                self.isPasswordValid = progressInfo.shouldValid
                self.forgotPasswordStrengthProgressView.setProgress(progressInfo.percentage, animated: true)
                self.forgotPasswordStrengthProgressView.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
            } else {
                self.errorLabel.isHidden = true
                self.forgotPasswordStrengthProgressView.setProgress(0, animated: false)
            }
        }
    }
    /*@IBAction func updateButtonTapped(_ sender: Any) {
     if validatePasswords() {
     errorLabel.isHidden = true
     
     guard let newPassword = FPConfirmPasswordTxt.text,
     let user = user else {
     return
     }
     
     
     guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
     return
     }
     
     let managedContext = appDelegate.persistentContainer.viewContext
     let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
     
     do {
     let users = try managedContext.fetch(fetchRequest)
     
     
     let passwordExists = users.contains { $0.password == newPassword }
     
     if passwordExists {
     showCustomAlertWith(message: "Password Already Exists", descMsg: "Please choose a different password.")
     } else {
     
     user.password = newPassword
     
     do {
     try managedContext.save()
     
     performSegue(withIdentifier: "FPtoMAIN", sender: nil)
     showCustomAlertWith(message: "Password Updated", descMsg: "")
     } catch {
     print("Failed to update password: \(error)")
     }
     }
     } catch {
     print("Failed to fetch user data: \(error)")
     }
     } else {
     errorLabel.isHidden = false
     errorLabel.text = "Passwords do not match"
     }
     }*/
}
