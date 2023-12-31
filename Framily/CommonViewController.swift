//
//  CommonViewController.swift
//  Framily
//
//  Created by Tharun kumar on 04/07/23.
//

/*import UIKit
import CoreData
import StoreKit

class CommonViewController: UIViewController {
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreDataStack()
 self.navigationItem.setHidesBackButton(true, animated: false)
        let startDateString = "2023-07-03"
        let endDateString = "2023-07-05"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let startDate = dateFormatter.date(from: startDateString),
           let endDate = dateFormatter.date(from: endDateString) {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
            
            if let numberOfDays = dateComponents.day {
                let unit = SKProduct.PeriodUnit.day
                let formattedPeriod = PeriodFormatter.formatSubscriptionPeriod(unit: unit, numberOfUnits: numberOfDays)
                
                if let currentUser = getCurrentUser() {
                    let dueAmount = currentUser.dueAmount
                    showAlert(for: formattedPeriod, dueAmount: dueAmount)
                } else {
                    showAlert(for: formattedPeriod, dueAmount: nil)
                }
            }
        }
    }
    
    func showAlert(for subscriptionPeriod: String?, dueAmount: Double?) {
        let message: String
        if let period = subscriptionPeriod, let amount = dueAmount {
            message = "Your subscription period is \(period). Due amount: \(amount)"
        } else if let period = subscriptionPeriod {
            message = "Your subscription period is \(period). Due amount: N/A"
        } else {
            message = "Invalid subscription period"
        }
        
        let alert = UIAlertController(title: "Subscription Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupCoreDataStack() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
    }
}

    /*  private func getUserCredentials(username: String, password: String) -> UserCredentials? {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        let sessionID = UUID().uuidString
        let users = [
            UserCredentials(username: "Tharun", password: "pass1", phoneNumber: "9655643522", trialDays: 2, deviceID: deviceID!, sessionID: sessionID, dueAmount: 50),
            UserCredentials(username: "Guhan", password: "pass2", phoneNumber: "1234567890", trialDays: 2, deviceID: deviceID!, sessionID: sessionID, dueAmount: 0),
            UserCredentials(username: "Varun", password: "pass3", phoneNumber: "1234567899", trialDays: 2, deviceID: deviceID!, sessionID: sessionID, dueAmount: 10)
        ]

        return users.first(where: { $0.username == username && $0.password == password })
    }

    private func storeUserDetails(username: String, password: String, phoneNumber: String, trialDays: Int, deviceID: String?, sessionID: String, dueAmount: Double) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        user.setValue(username, forKey: "username")
        user.setValue(password, forKey: "password")
        user.setValue(phoneNumber, forKey: "phoneNumber")
        user.setValue(trialDays, forKey: "trialDays")
        user.setValue(deviceID, forKey: "deviceID")
        user.setValue(sessionID, forKey: "sessionID")
        user.setValue(dueAmount, forKey: "dueAmount")

        do {
            try managedObjectContext?.save()
            print("User details saved")
            printStoredUserDetails()
        } catch let error as NSError {
            print("Failed to save user details: \(error), \(error.userInfo)")
        }
    }

    private func updateDeviceID(_ newDeviceID: String) {
        guard let managedContext = managedObjectContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "deviceID != %@", newDeviceID)
        
        do {
            let users = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for user in users {
                user.setValue(newDeviceID, forKey: "deviceID")
            }
            try managedContext.save()
            print("Device ID updated for \(users.count) users")
        } catch let error as NSError {
            print("Failed to update device ID: \(error), \(error.userInfo)")
        }
    }
    
 
    private func getCurrentUser() -> User? {
       
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchedUsers = try managedObjectContext?.fetch(fetchRequest) as! [User]
            return fetchedUsers.first
        } catch let error as NSError {
            print("Failed to fetch user details: \(error), \(error.userInfo)")
            return nil
        }
    }


    private func printStoredUserDetails() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

        do {
            let fetchedUsers = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
            for user in fetchedUsers {
                print("Stored User Details:")
                print("Username: \(user.value(forKey: "username") ?? "")")
                print("Password: \(user.value(forKey: "password") ?? "")")
                print("Phone Number: \(user.value(forKey: "phoneNumber") ?? "")")
                print("Trial Days: \(user.value(forKey: "trialDays") ?? "")")
                print("Session ID: \(user.value(forKey: "sessionID") ?? "")")
                print("Device ID: \(user.value(forKey: "deviceID") ?? "")")
                print("Due Amount: \(user.value(forKey: "dueAmount") ?? "")")
            }
        } catch let error as NSError {
            print("Failed to fetch user details: \(error), \(error.userInfo)")
        }
    }
}

struct UserCredentials {
    let username: String
    let password: String
    let phoneNumber: String
    let trialDays: Int
    let deviceID: String
    let sessionID: String
    let dueAmount: Double
}//
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {  //OTPViewControllerSegue
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
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTxt.text else { return }

       
        let characterSet = CharacterSet.decimalDigits
        let phoneNumberDigits = phoneNumber.unicodeScalars.filter { characterSet.contains($0) }

        if phoneNumberDigits.count == 10 {
            
            let deviceID = UIDevice.current.identifierForVendor?.uuidString
            let sessionID = UUID().uuidString
            let platform = "iOS"

            let userRef = Database.database().reference().child("users")

            userRef.observeSingleEvent(of: .value) { [weak self] (snapshot, error) in
                if let error = error {
                   
                    print("Error retrieving data: \(error)")
                    return
                }

                var phoneNumberExists = false
                var existingDeviceRef: DatabaseReference?

                if let users = snapshot.value as? [String: Any] {
                    for (key, value) in users {
                        if let userData = value as? [String: Any],
                           let registeredPhoneNumber = userData["phoneNumber"] as? String,
                           let registeredDeviceID = userData["deviceID"] as? String {

                            if registeredPhoneNumber == phoneNumber {
                                phoneNumberExists = true
                                existingDeviceRef = userRef.child(key).child("deviceID")
                                break
                            }
                        }
                    }
                }

                if phoneNumberExists {
                   
                    if let existingDeviceRef = existingDeviceRef {
                        existingDeviceRef.observeSingleEvent(of: .value) { [weak self] (snapshot, error) in
                            if let error = error {
                                
                                print("Error retrieving existing device ID: \(error)")
                                return
                            }

                            if let existingDeviceID = snapshot.value as? String {
                                if existingDeviceID == deviceID {
                                    if let self = self {
                                                self.performSegue(withIdentifier: "OTPViewControllerSegue", sender: nil)
                                            }
                                        } else {
                                    
                                    let actions: [[String: () -> Void]] = [
                                        ["Log Out": { [weak self] in
                                            guard let self = self else { return }
                                           
                                            print("Existing Device ID: \(existingDeviceID)")
                                            existingDeviceRef.setValue(deviceID)
                                            print("Replaced Device ID: \(deviceID)")
                                           
                                            self.performSegue(withIdentifier: "OTPViewControllerSegue", sender: nil)
                                        }],
                                        ["Cancel": {
                                            
                                        }]
                                    ]
                                    self?.showCustomAlertWith(message: "Phone number is already registered with a different device. Do you want to log out from the existing device?", descMsg: "", actions: actions)
                                }
                            }
                        }
                    }
                } else {
                    
                    let newUserRef = userRef.childByAutoId()
                    newUserRef.setValue(["phoneNumber": phoneNumber,
                                         "deviceID": deviceID,
                                         "sessionID": sessionID,
                                         "platform": platform]) { (error, ref) in
                        if let error = error {
                            print("Error storing data: \(error)")
                        } else {
                            print("Data stored successfully!")
                           
                            self?.performSegue(withIdentifier: "OTPViewControllerSegue", sender: nil)
                        }
                    }
                }
            }
        } else {
           
            let actions: [[String: () -> Void]] = [
                ["OK": {
                   
                }]
            ]
            self.showCustomAlertWith(message: "Invalid Phone Number", descMsg: "Please enter a 10-digit phone number.", actions: actions)
        }
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }//
     }*/*/
/*import UIKit
 import UserNotifications
 
 class OTPViewController: UIViewController, UITextFieldDelegate {
 
 @IBOutlet weak var OTPVerifyBtn: UIButton!
 @IBOutlet weak var otpTextField1: UITextField!
 @IBOutlet weak var otpTextField2: UITextField!
 @IBOutlet weak var otpTextField3: UITextField!
 @IBOutlet weak var generateOtpBtn: UIButton!
 @IBOutlet weak var otpTextField4: UITextField!
 
 var correctOTP: String = ""
 var otpDigits: [String] = []
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 
 
 
 let shadowColor = UIColor.black.cgColor
 let shadowOpacity: Float = 1.5
 let shadowOffset = CGSize(width: 0, height: 2)
 let shadowRadius: CGFloat = 4
 
 
 
 generateOtpBtn.layer.shadowColor = shadowColor
 generateOtpBtn.layer.shadowOpacity = shadowOpacity
 generateOtpBtn.layer.shadowOffset = shadowOffset
 generateOtpBtn.layer.shadowRadius = shadowRadius
 
 OTPVerifyBtn.layer.shadowColor = shadowColor
 OTPVerifyBtn.layer.shadowOpacity = shadowOpacity
 OTPVerifyBtn.layer.shadowOffset = shadowOffset
 OTPVerifyBtn.layer.shadowRadius = shadowRadius
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
 OTPVerifyBtn.layer.cornerRadius = 10
 
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
 
 @IBAction func verifyButtonPressed(_ sender: UIButton) {
 let enteredOTP = getEnteredOTP()
 
 guard !enteredOTP.isEmpty && enteredOTP == correctOTP else {
 showCustomAlertWith(message: "Incorrect OTP. Please try again.", descMsg: "", actions: nil)
 // showAlert(message: "Incorrect OTP. Please try again.")
 clearAllTextFields()
 return
 }
 
 performSegue(withIdentifier: "Next", sender: nil)
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
 2nd
 /*  @IBAction func loginBtnverifyButtonPressed(_ sender: UIButton) {
  let enteredOTP = getEnteredOTP()
  
  guard !enteredOTP.isEmpty && enteredOTP == correctOTP else {
  showCustomAlertWith(message: "Incorrect OTP. Please try again.", descMsg: "", actions: nil)
  // showAlert(message: "Incorrect OTP. Please try again.")
  clearAllTextFields()
  return
  }
  
  performSegue(withIdentifier: "MainSegue", sender: nil)
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
  let newUser = User(context: managedContext)
  newUser.phoneNumber = phoneNumber
  newUser.deviceID = deviceID
  newUser.sessionID = sessionID
  newUser.platform = platform
  
  try managedContext.save()
  print("Data stored successfully!")
  printSavedData()
  
  
  self.performSegue(withIdentifier: "MainSegue", sender: nil)
  }
  } catch let error as NSError {
  print("Error retrieving/storing data: \(error), \(error.userInfo)")
  }
  
  
  printSavedData()
  } else {
  let actions: [[String: () -> Void]] = [
  ["OK": { }]
  ]
  showCustomAlertWith(message: "Invalid Phone Number", descMsg: "Please enter a 10-digit phone number.", actions: actions)
  }
  }//
  
  */
 code for phone number device id validation and for otp
 
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
 }//
 
 colour changing for all the viewcontroller:
 
 extension UIViewController {
 static let swizzleViewDidLoad: Void = {
 let originalSelector = #selector(viewDidLoad)
 let swizzledSelector = #selector(swizzledViewDidLoad)
 guard
 let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
 let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
 else {
 return
 }
 
 method_exchangeImplementations(originalMethod, swizzledMethod)
 }()
 
 @objc private func swizzledViewDidLoad() {
 // Call the original viewDidLoad implementation
 swizzledViewDidLoad()
 
 if let backgroundColor = UIColor(named: "BackGroundColour") {
 view.backgroundColor = backgroundColor
 }
 }
 }
 
 in app delegate
 UIViewController.swizzleViewDidLoad
 
 in viewcontrollers
 view.backgroundColor = BackgroundManager.shared.backgroundColor
 //
 
 for phone number(digit) and email valdation (letter)
 
 /*    @IBAction func loginButtonTapped(_ sender: UIButton) {
  guard let email = emailIdText.text, !email.isEmpty else {
  showCustomAlertWith(message: "Please enter Email Id or Phone number", descMsg: "Please enter your login.")
  return
  }
  
  guard let password = passwordText.text, !password.isEmpty else {
  showCustomAlertWith(message: "Please enter password", descMsg: "Please enter your password.")
  return
  }
  
  if email.rangeOfCharacter(from: .letters) != nil {
  // Email validation
  if !isValidEmail(email) {
  showCustomAlertWith(message: "Invalid email format", descMsg: "Please enter a valid email address.")
  return
  }
  } else if email.rangeOfCharacter(from: .decimalDigits) != nil {
  // Phone number validation
  if !isValidPhoneNumber(email) {
  showCustomAlertWith(message: "Invalid phone number", descMsg: "Please enter a valid phone number.")
  return
  }
  } else {
  // Invalid login format
  showCustomAlertWith(message: "Invalid login", descMsg: "Please enter a valid email address or phone number.")
  return
  }
  
  // CoreData login authentication
  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
  return
  }
  
  let managedContext = appDelegate.persistentContainer.viewContext
  let fetchRequest = NSFetchRequest<User>(entityName: "User")
  fetchRequest.predicate = NSPredicate(format: "password == %@", password)
  
  do {
  let result = try managedContext.fetch(fetchRequest)
  let filteredUsers = result.compactMap { $0 as? User }.filter {
  $0.emailID == email || $0.phoneNumber == email
  }
  
  if let user = filteredUsers.first {
  if user.password == password {
  performSegue(withIdentifier: "loginToOtp", sender: nil)
  } else {
  showCustomAlertWith(message: "Invalid password", descMsg: "The password you entered is incorrect.")
  }
  } else {
  showCustomAlertWith(message: "Invalid email or Phone number. Please Sign up", descMsg: "The email you entered is incorrect.")
  }
  } catch {
  showCustomAlertWith(message: "An error occurred during login", descMsg: "An error occurred during login.")
  }
  }//
  */
 */
/*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "SignUpToEmailOTP" {
           if let otpVC = segue.destination as? EmailOTPViewController {
               let newUser = sender as? User
               otpVC.user = newUser
           }
       }
       else if segue.identifier == "OTPToConfirmPassword" {
           if let confirmPasswordVC = segue.destination as? ConfirmPasswordViewController {
               let newUser = sender as? User
               confirmPasswordVC.user = newUser
               confirmPasswordVC.companyName = newUser?.companyName
               confirmPasswordVC.phoneNumber = newUser?.phoneNumber
               confirmPasswordVC.countryCode = newUser?.countryCode
               confirmPasswordVC.emailID = newUser?.emailID
       
           }
       }
   }*/
/* func printSavedData() {
     let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

     do {
         let savedUsers = try managedContext.fetch(fetchRequest)
         for user in savedUsers {
             print("User Data:")
         print("Phone Number: \(user.phoneNumber ?? "")")
             print("Country Code: \(user.countryCode ?? "")")
     print("Company Name: \(user.companyName ?? "")")
         print("Email ID: \(user.emailID ?? "")")
         print("Device ID: \(user.deviceID ?? "")")
         print("Session ID: \(user.sessionID ?? "")")
         print("Group Name: \(user.groupName ?? "")")
         print("First Name: \(user.firstName ?? "")")
         print("Last Name: \(user.lastName ?? "")")
         print("User Name: \(user.userName ?? "")")
         print("Password: \(user.password ?? "")")
             print("--*------*-----*-----*---")
         }
     } catch let error as NSError {
         print("Error fetching data: \(error), \(error.userInfo)")
     }
 }*/
/* private func setupCoreDataStack() {
     guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
         return
     }
     managedObjectContext = appDelegate.persistentContainer.viewContext
     
 }*/
/*let underlineLayer = CALayer()
 underlineLayer.frame = CGRect(x: 0, y: emailIdText.frame.size.height - 1, width: emailIdText.frame.size.width, height: 1)
 underlineLayer.backgroundColor = UIColor.white.cgColor
 emailIdText.layer.addSublayer(underlineLayer)
 let underlineLayer1 = CALayer()
 underlineLayer1.frame = CGRect(x: 0, y: passwordText.frame.size.height - 1, width: passwordText.frame.size.width, height: 1)
 underlineLayer1.backgroundColor = UIColor.white.cgColor
 passwordText.layer.addSublayer(underlineLayer1)*/
/*@objc func submitButtonTapped() {
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
             confirmPasswordAPI(groupName: groupName, firstName: firstName, lastName: lastName, userName: userName, password: password, responseData: responseData)
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
 }*/
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
// MARK: - GET Method in api
/*func getUserInfoAPI() {
    let apiURL = URL(string: "http://192.168.29.7:8082/activeVendor")!
    
    var request = URLRequest(url: apiURL)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let credentials = "arun:arun1"
    let credentialsData = credentials.data(using: .utf8)!
    let base64Credentials = credentialsData.base64EncodedString()
    request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
    
    let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
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
                        
                        if let responseDict = jsonObject as? [String: Any] {
                            if let success = responseDict["success"] as? Bool, success {
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let otpViewController = storyboard.instantiateViewController(withIdentifier: "ViewControllers") as! ViewController
                                    otpViewController.responseData = responseDict
                                    self.navigationController?.pushViewController(otpViewController, animated: true)
                                }
                            } else if let errorMessage = responseDict["errorMessage"] as? String {
                                DispatchQueue.main.async {
                                    self.showAlert(title: "Server Error", message: errorMessage)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showAlert(title: "Server Error", message: "There was a problem with the server. Please try again later.")
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                               self.showAlert(title: "Server Error", message: "There was a problem with the server. Please try again later.")
                            }
                        }
                        
                    } catch {
                        print("Error parsing response data: \(error)")
                    }
                }
            } else if (400...499).contains(statusCode) {
                if let responseData = data {
                    do {
                          
                                
                                let jsonObject = try JSONSerialization.jsonObject(with: responseData/*decryptedData*/, options: [])
                                print("Response: \(jsonObject)")
                        
                        if let responseDict = jsonObject as? [String: Any], let body = responseDict["body"] as? String {
                            DispatchQueue.main.async {
                                self.showAlert(title: body, message: "")
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(title: "Client Error", message: "An error occurred while processing the response.")
                            }
                        }
                        
                    } catch {
                        print("Error parsing response data: \(error)")
                        DispatchQueue.main.async {
                            self.showAlert(title: "Client Error", message: "An error occurred while processing the response.")
                        }
                    }
                }
            } else {
                print("Invalid HTTP response: \(httpResponse)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Server Error", message: "An unknown error occurred.")
                }
            }
        }
    }
    
    task.resume()
    print("Sending signup request to API...")
}*/
