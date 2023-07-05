//
//  LoginViewController.swift
//  Framily
//
//  Created by Tharun kumar on 19/06/23.
//
import UIKit
import CoreData
import StoreKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var generateOtpBtn: UIButton!
    @IBOutlet weak var otpTextField4: UITextField!
    
    var correctOTP: String = ""
    var otpDigits: [String] = []
    
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationItem.setHidesBackButton(true, animated: false)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        loginBtn.layer.cornerRadius = 10.0
        
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 1.5
        let shadowOffset = CGSize(width: 0, height: 2)
        let shadowRadius: CGFloat = 4
        loginBtn.layer.shadowColor = shadowColor
        loginBtn.layer.shadowOpacity = shadowOpacity
        loginBtn.layer.shadowOffset = shadowOffset
        loginBtn.layer.shadowRadius = shadowRadius
        phoneNumberTxt.layer.shadowColor = shadowColor
        phoneNumberTxt.layer.shadowOpacity = shadowOpacity
        phoneNumberTxt.layer.shadowOffset = shadowOffset
        phoneNumberTxt.layer.shadowRadius = shadowRadius
  
        generateOtpBtn.layer.shadowColor = shadowColor
        generateOtpBtn.layer.shadowOpacity = shadowOpacity
        generateOtpBtn.layer.shadowOffset = shadowOffset
        generateOtpBtn.layer.shadowRadius = shadowRadius
        
        loginBtn.layer.shadowColor = shadowColor
        loginBtn.layer.shadowOpacity = shadowOpacity
        loginBtn.layer.shadowOffset = shadowOffset
        loginBtn.layer.shadowRadius = shadowRadius
        otpTextField1.layer.shadowColor = shadowColor
        otpTextField1.layer.shadowOpacity = shadowOpacity
        otpTextField1.layer.shadowOffset = shadowOffset
        otpTextField1.layer.shadowRadius = shadowRadius
        
        otpTextField2.layer.shadowColor = shadowColor
        otpTextField2.layer.shadowOpacity = shadowOpacity
        otpTextField2.layer.shadowOffset = shadowOffset
        otpTextField2.layer.shadowRadius = shadowRadius
        
        otpTextField3.layer.shadowColor = shadowColor
        otpTextField3.layer.shadowOpacity = shadowOpacity
        otpTextField3.layer.shadowOffset = shadowOffset
        otpTextField3.layer.shadowRadius = shadowRadius
        
        otpTextField4.layer.shadowColor = shadowColor
        otpTextField4.layer.shadowOpacity = shadowOpacity
        otpTextField4.layer.shadowOffset = shadowOffset
        otpTextField4.layer.shadowRadius = shadowRadius
        
        generateOtpBtn.layer.cornerRadius = 10
        loginBtn.layer.cornerRadius = 10
        
        otpTextField1.delegate = self
        otpTextField2.delegate = self
        otpTextField3.delegate = self
        otpTextField4.delegate = self
        
        
        otpTextField1.keyboardType = .numberPad
        otpTextField2.keyboardType = .numberPad
        otpTextField3.keyboardType = .numberPad
        otpTextField4.keyboardType = .numberPad
        
        
        otpTextField1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpTextField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpTextField3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpTextField4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(firstTextFieldTapped))
        otpTextField1.addGestureRecognizer(tapGesture)
        otpDigits = Array(arrayLiteral: String(correctOTP))
        printAllData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func generateOTPButtonPressed(_ sender: UIButton) {
        generateOTP()
        autofillOTP()
        
        showCustomAlertWith(message: "Generated OTP: \(correctOTP)", descMsg: "", actions: nil)
        //showAlert(message:  "Generated OTP: \(correctOTP)")
        showOTPNotification()
        
    }
    func printAllData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            
            for user in users {
                print("Company Name: \(user.companyName ?? "")")
                print("Phone Number: \(user.phoneNumber ?? "")")
                print("Device ID: \(user.deviceID ?? "")")
                print("Session ID: \(user.sessionID ?? "")")
                print("Platform: \(user.platform ?? "")")
               
            }
        } catch let error as NSError {
            print("Error fetching data: \(error), \(error.userInfo)")
        }
    }

    


    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTxt.text else { return }
        
        let characterSet = CharacterSet.decimalDigits
        let phoneNumberDigits = phoneNumber.unicodeScalars.filter { characterSet.contains($0) }
        
        if phoneNumberDigits.count == 10 {
            let deviceID = UIDevice.current.identifierForVendor?.uuidString
            let sessionID = UUID().uuidString
            let platform = "iOS"
            
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
            
            do {
                let users = try managedContext.fetch(fetchRequest)
                
                if let existingUser = users.first {
                    if existingUser.deviceID == deviceID {
                        let enteredOTP = getEnteredOTP()
                        
                        guard !enteredOTP.isEmpty && enteredOTP == correctOTP else {
                            showCustomAlertWith(message: "Incorrect OTP. Please try again.", descMsg: "")
                            clearAllTextFields()
                            return
                        }
                        
                     
                        self.performSegue(withIdentifier: "MainSegue", sender: nil)
                    } else {
                        let actions: [[String: () -> Void]] = [
                            ["Log Out": { [weak self] in
                                existingUser.deviceID = deviceID
                                existingUser.sessionID = sessionID
                                try? self?.managedContext.save()
                                
                                self?.performSegue(withIdentifier: "MainSegue", sender: nil)
                            }],
                            ["Cancel": { }]
                        ]
                        showCustomAlertWith(message: "Phone number is already registered with a different device. Do you want to log out from the existing device?", descMsg: "", actions: actions)
                    }
                } else {
                    let actions: [[String: () -> Void]] = [
                        ["OK": { }]
                    ]
                    showCustomAlertWith(message: "Phone number not found.", descMsg: "Please register with the provided phone number.", actions: actions)
                }
            } catch let error as NSError {
                print("Error retrieving/storing data: \(error), \(error.userInfo)")
            }
        } else {
            let actions: [[String: () -> Void]] = [
                ["OK": { }]
            ]
            showCustomAlertWith(message: "Invalid Phone Number", descMsg: "Please enter a 10-digit phone number.", actions: actions)
        }
    }


    func generateOTP() {
        
        let otpDigits = (0..<4).map { _ in String(Int.random(in: 0...9)) }
        correctOTP = otpDigits.joined()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        return newLength <= 1
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count == 1 {
            switch textField {
            case otpTextField1:
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField4.resignFirstResponder()
            default:
                break
            }
        } else if text.isEmpty {
            switch textField {
            case otpTextField2:
                otpTextField1.becomeFirstResponder()
            case otpTextField3:
                otpTextField2.becomeFirstResponder()
            case otpTextField4:
                otpTextField3.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    func showOTPNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Generated OTP"
        content.body = "Your OTP: \(correctOTP)"
        content.sound = UNNotificationSound.default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: "OTPNotification", content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error)")
            }
        }
    }
    
    
    @objc func firstTextFieldTapped() {
        guard let firstDigit = correctOTP.first else { return }
        
        otpTextField1.text = String(firstDigit)
        
        guard correctOTP.count >= 2 else { return }
        let secondIndex = correctOTP.index(correctOTP.startIndex, offsetBy: 1)
        let secondDigit = correctOTP[secondIndex]
        otpTextField2.text = String(secondDigit)
        
        guard correctOTP.count >= 3 else { return }
        let thirdIndex = correctOTP.index(correctOTP.startIndex, offsetBy: 2)
        let thirdDigit = correctOTP[thirdIndex]
        otpTextField3.text = String(thirdDigit)
        
        guard correctOTP.count >= 4 else { return }
        let fourthIndex = correctOTP.index(correctOTP.startIndex, offsetBy: 3)
        let fourthDigit = correctOTP[fourthIndex]
        otpTextField4.text = String(fourthDigit)
        
        otpTextField2.becomeFirstResponder()
    }
    func autofillOTP() {
        guard correctOTP.count == 4 else {
            
            return
        }
        
        otpTextField1.text = String(correctOTP[correctOTP.startIndex])
        otpTextField2.text = String(correctOTP[correctOTP.index(after: correctOTP.startIndex)])
        otpTextField3.text = String(correctOTP[correctOTP.index(correctOTP.startIndex, offsetBy: 2)])
        otpTextField4.text = String(correctOTP[correctOTP.index(correctOTP.startIndex, offsetBy: 3)])
    }
    
    
    func getEnteredOTP() -> String {
        let enteredOTP = [otpTextField1.text, otpTextField2.text, otpTextField3.text, otpTextField4.text]
        return enteredOTP.compactMap { $0 }.joined()
    }
    
    func clearAllTextFields() {
        otpTextField1.text = ""
        otpTextField2.text = ""
        otpTextField3.text = ""
        otpTextField4.text = ""
        
        otpTextField1.becomeFirstResponder()
    }
    func fillOTPFields(with otp: String) {
        let otpArray = Array(otp)
        
        otpTextField1.text = String(otpArray[0])
        otpTextField2.text = String(otpArray[1])
        otpTextField3.text = String(otpArray[2])
        otpTextField4.text = String(otpArray[3])
    }
    
    
      func showAlert(message: String) {
      let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
   }
    
}
extension UIViewController {
    static var commonAlertImage: UIImage?
    
    func showCustomAlertWith(okButtonAction: (() -> Void)? = nil, message: String, descMsg: String, actions: [[String: () -> Void]]? = nil) {
        let alertVC = CommonAlertVC(nibName: "CommonAlertVC", bundle: nil)
        alertVC.message = message
        alertVC.arrayAction = actions
        alertVC.descriptionMessage = descMsg
        alertVC.imageItem = UIViewController.commonAlertImage
        
        if let okButtonAction = okButtonAction {
            alertVC.okButtonAct = okButtonAction
        }
        
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: true, completion: nil)
    }
}
