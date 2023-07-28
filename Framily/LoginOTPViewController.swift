//
//  LoginOTPViewController.swift
//  Framily
//
//  Created by Varun kumar on 25/07/23.
//

import UIKit
import UserNotifications

class LoginOTPViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var LoginEmailOTPTxt1: UITextField!
    @IBOutlet weak var LoginEmailOTPTxt2: UITextField!
    @IBOutlet weak var LoginEmailOTPTxt3: UITextField!
    @IBOutlet weak var LoginPhoneNumberTxt1: UITextField!
    @IBOutlet weak var LoginPhoneNumberTxt2: UITextField!
    @IBOutlet weak var LoginPhoneNumberTxt3: UITextField!
    @IBOutlet weak var LoginEmailOTPBtn: UIButton!
    @IBOutlet weak var LoginPhoneNumberOTPBtn: UIButton!
    @IBOutlet weak var LoginTimerLabel: UILabel!
    @IBOutlet weak var LoginResendButton: UIButton!
    @IBOutlet weak var LoginNextBtn: UIButton!
    @IBOutlet weak var LoginEmailOTPView: UIView!
    var shouldDisableButtons = false
    var resendAttempts = 0
    var timer: Timer?
    var timeRemaining = 10
    var user: User?
    var correctOTP1: String = ""
    var otpDigits1: [String] = []
    var correctOTP2: String = ""
    var otpDigits2: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        LoginEmailOTPView.layer.cornerRadius = 20.0
        LoginEmailOTPTxt1.backgroundColor = UIColor.clear
        LoginEmailOTPTxt1.borderStyle = .none
        LoginEmailOTPTxt2.backgroundColor = UIColor.clear
        LoginEmailOTPTxt2.borderStyle = .none
        LoginEmailOTPTxt3.backgroundColor = UIColor.clear
        LoginEmailOTPTxt3.borderStyle = .none
        LoginPhoneNumberTxt1.backgroundColor = UIColor.clear
        LoginPhoneNumberTxt1.borderStyle = .none
        LoginPhoneNumberTxt2.backgroundColor = UIColor.clear
        LoginPhoneNumberTxt2.borderStyle = .none
        LoginPhoneNumberTxt3.backgroundColor = UIColor.clear
        LoginPhoneNumberTxt3.borderStyle = .none
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        LoginNextBtn.layer.shadowColor = shadowColor
        LoginNextBtn.layer.shadowOpacity = shadowOpacity
        LoginNextBtn.layer.shadowOffset = shadowOffset
        LoginNextBtn.layer.shadowRadius = shadowRadius
        LoginEmailOTPView.layer.shadowColor = shadowColor
        LoginEmailOTPView.layer.shadowOpacity = shadowOpacity
        LoginEmailOTPView.layer.shadowOffset = shadowOffset
        LoginEmailOTPView.layer.shadowRadius = shadowRadius
        LoginEmailOTPTxt1.layer.shadowColor = shadowColor
        LoginEmailOTPTxt1.layer.shadowOpacity = shadowOpacity
        LoginEmailOTPTxt1.layer.shadowOffset = shadowOffset
        LoginEmailOTPTxt1.layer.shadowRadius = shadowRadius
        LoginEmailOTPTxt2.layer.shadowColor = shadowColor
        LoginEmailOTPTxt2.layer.shadowOpacity = shadowOpacity
        LoginEmailOTPTxt2.layer.shadowOffset = shadowOffset
        LoginEmailOTPTxt2.layer.shadowRadius = shadowRadius
        LoginEmailOTPTxt3.layer.shadowColor = shadowColor
        LoginEmailOTPTxt3.layer.shadowOpacity = shadowOpacity
        LoginEmailOTPTxt3.layer.shadowOffset = shadowOffset
        LoginEmailOTPTxt3.layer.shadowRadius = shadowRadius
        LoginPhoneNumberTxt1.layer.shadowColor = shadowColor
        LoginPhoneNumberTxt1.layer.shadowOpacity = shadowOpacity
        LoginPhoneNumberTxt1.layer.shadowOffset = shadowOffset
        LoginPhoneNumberTxt1.layer.shadowRadius = shadowRadius
        LoginPhoneNumberTxt2.layer.shadowColor = shadowColor
        LoginPhoneNumberTxt2.layer.shadowOpacity = shadowOpacity
        LoginPhoneNumberTxt2.layer.shadowOffset = shadowOffset
        LoginPhoneNumberTxt2.layer.shadowRadius = shadowRadius
        LoginPhoneNumberTxt3.layer.shadowColor = shadowColor
        LoginPhoneNumberTxt3.layer.shadowOpacity = shadowOpacity
        LoginPhoneNumberTxt3.layer.shadowOffset = shadowOffset
        LoginPhoneNumberTxt3.layer.shadowRadius = shadowRadius
        
        LoginEmailOTPTxt1.delegate = self
        LoginEmailOTPTxt2.delegate = self
        LoginEmailOTPTxt3.delegate = self
        LoginPhoneNumberTxt1.delegate = self
        LoginPhoneNumberTxt2.delegate = self
        LoginPhoneNumberTxt3.delegate = self
        
      /*  emailOTPTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        emailOTPTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        emailOTPTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)*/
        
        LoginPhoneNumberTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        LoginPhoneNumberTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        LoginPhoneNumberTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
      /*  let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(firstTextFieldTapped))
        
        emailOTPTxt1.addGestureRecognizer(tapGesture1)*/
        
        
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(secondTextFieldTapped))
        
        LoginPhoneNumberTxt1.addGestureRecognizer(tapGesture2)
        
        
        
        otpDigits1 = Array(arrayLiteral: String(correctOTP1))
       
        startTimer()
        let underlineLayer = CALayer()
        underlineLayer.frame = CGRect(x: 0, y: LoginEmailOTPTxt1.frame.size.height - 1, width: LoginEmailOTPTxt1.frame.size.width, height: 1)
        underlineLayer.backgroundColor = UIColor.white.cgColor
        LoginEmailOTPTxt1.layer.addSublayer(underlineLayer)
        let underlineLayer1 = CALayer()
        underlineLayer1.frame = CGRect(x: 0, y: LoginEmailOTPTxt2.frame.size.height - 1, width: LoginEmailOTPTxt2.frame.size.width, height: 1)
        underlineLayer1.backgroundColor = UIColor.white.cgColor
        LoginEmailOTPTxt2.layer.addSublayer(underlineLayer1)
        let underlineLayer2 = CALayer()
        underlineLayer2.frame = CGRect(x: 0, y: LoginEmailOTPTxt3.frame.size.height - 1, width: LoginEmailOTPTxt3.frame.size.width, height: 1)
        underlineLayer2.backgroundColor = UIColor.white.cgColor
        LoginEmailOTPTxt3.layer.addSublayer(underlineLayer2)
        let underlineLayer3 = CALayer()
        underlineLayer3.frame = CGRect(x: 0, y: LoginPhoneNumberTxt1.frame.size.height - 1, width: LoginPhoneNumberTxt1.frame.size.width, height: 1)
        underlineLayer3.backgroundColor = UIColor.white.cgColor
        LoginPhoneNumberTxt1.layer.addSublayer(underlineLayer3)
        let underlineLayer4 = CALayer()
        underlineLayer4.frame = CGRect(x: 0, y: LoginPhoneNumberTxt2.frame.size.height - 1, width: LoginPhoneNumberTxt2.frame.size.width, height: 1)
        underlineLayer4.backgroundColor = UIColor.white.cgColor
        LoginPhoneNumberTxt2.layer.addSublayer(underlineLayer4)
        let underlineLayer5 = CALayer()
        underlineLayer5.frame = CGRect(x: 0, y: LoginPhoneNumberTxt3.frame.size.height - 1, width: LoginPhoneNumberTxt3.frame.size.width, height: 1)
        underlineLayer5.backgroundColor = UIColor.white.cgColor
        LoginPhoneNumberTxt3.layer.addSublayer(underlineLayer5)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func startTimer() {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        LoginResendButton.isEnabled = false
    }
    @objc func updateTimer() {
        timeRemaining -= 1
        LoginTimerLabel.text = "\(timeRemaining) seconds remaining"
        if timeRemaining <= 0 {
            
            timer?.invalidate()
            
            LoginResendButton.isEnabled = true
        }
    }
    
    @IBAction func resendButtonTapped(_ sender: UIButton) {
        if resendAttempts < 3 {
            timeRemaining = 10
            startTimer()
            resendAttempts += 1
            LoginResendButton.isEnabled = false
            shouldDisableButtons = true
        } else {
            showCustomAlertWith(okButtonAction: {
                self.performSegue(withIdentifier: "EmailPhoneOTPToLogin", sender: nil)
            }, message: "Please contact the admin.", descMsg: "", actions: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmailPhoneOTPToLogin" {
            // Pass the shouldDisableButtons flag to loginUserNameViewController
            if let loginViewController = segue.destination as? loginUserNameViewController {
                loginViewController.shouldDisableButtons = shouldDisableButtons
            }
        }
    }

    //EmailPhoneOTPToLogin
    @IBAction func generateOTP1ButtonPressed(_ sender: UIButton) {
        
        generateOTP1()
        
        //autofillOTP1()
        
        showCustomAlertWith(message: "Generated OTP: \(correctOTP1)", descMsg: "", actions: nil)
        
        showOTPNotification1()
        
    }
    
    
    
    @IBAction func generateOTP2ButtonPressed(_ sender: UIButton) {
        
        generateOTP2()
        
        autofillOTP2()
        
        showCustomAlertWith(message: "Generated OTP: \(correctOTP2)", descMsg: "", actions: nil)
        
        showOTPNotification2()
        
    }
    
    @IBAction func ContinueButtonPressed(_ sender: Any) {
        
        let enteredOTP1 = getEnteredOTP1
        
        let enteredOTP2 = getEnteredOTP2
      
        guard !enteredOTP1().isEmpty && enteredOTP1() == correctOTP1 else {
            
            showCustomAlertWith(message: "Incorrect Email OTP. Please try again.", descMsg: "", actions: nil)
            
            clearAllTextFields()
            
            return
            
        }
        
        guard !enteredOTP2().isEmpty && enteredOTP2() == correctOTP2 else {
            
            showCustomAlertWith(message: "Incorrect Phone number OTP. Please try again.", descMsg: "", actions: nil)
            clearAllTextFields()
            return
        }
        performSegue(withIdentifier: "LoginOTPToHome", sender: nil)
    }
    
    func generateOTP1() {
        
        let otpDigits = (0..<3).map { _ in String(Int.random(in: 0...9)) }
        
        correctOTP1 = otpDigits.joined()
        
    }
    
    
    func generateOTP2() {
        
        let otpDigits = (0..<3).map { _ in String(Int.random(in: 0...9)) }
        
        correctOTP2 = otpDigits.joined()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            guard let text = textField.text else { return true }

            let newLength = text.count + string.count - range.length

            

            if newLength <= 1 {

                // Check if the entered character is a number (you can adjust this condition as needed)

                if let char = string.cString(using: String.Encoding.utf8) {
                    
                    let isBackSpace = strcmp(char, "\\b")
                    
                    if isBackSpace == -92 { // Backspace was pressed, allow the text change
                        
                        return true
                        
                    } else if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
                        
                        // If it's a number, move to the next text field
                        
                        switch textField {
                            
                        case LoginEmailOTPTxt1:
                            
                            LoginEmailOTPTxt2.becomeFirstResponder()
                            
                        case LoginEmailOTPTxt2:
                            
                            LoginEmailOTPTxt3.becomeFirstResponder()
                            
                        case LoginEmailOTPTxt3:
                            
                            LoginEmailOTPTxt3.resignFirstResponder()
                            
                        default:
                            
                            break
                            
                        }
                        
                        textField.text = string // Manually set the text field with the entered character
                        
                        return false // Return false to prevent the default behavior of shouldChangeCharactersIn
                        
                     }
                   }
                }
        return false
        }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if text.count == 1 {
            switch textField {
            case LoginEmailOTPTxt1:
                
                LoginEmailOTPTxt2.becomeFirstResponder()
                
            case LoginEmailOTPTxt2:
                
                LoginEmailOTPTxt3.becomeFirstResponder()
                
            case LoginEmailOTPTxt3:
                
                LoginPhoneNumberTxt1.becomeFirstResponder()
                
            case LoginPhoneNumberTxt1:
                
                LoginPhoneNumberTxt2.becomeFirstResponder()
                
            case LoginPhoneNumberTxt2:
                
                LoginPhoneNumberTxt3.becomeFirstResponder()
                
            case LoginPhoneNumberTxt3:
                
                LoginPhoneNumberTxt3.resignFirstResponder()
                
            default:
                
                break
                
            }
            
        } else if text.isEmpty {
            
            switch textField {
                
            case LoginEmailOTPTxt2:
                
                LoginEmailOTPTxt1.becomeFirstResponder()
                
            case LoginEmailOTPTxt3:
                
                LoginEmailOTPTxt2.becomeFirstResponder()
                
            case LoginPhoneNumberTxt2:
                
                LoginPhoneNumberTxt1.becomeFirstResponder()
                
            case LoginPhoneNumberTxt3:
                
                LoginPhoneNumberTxt2.becomeFirstResponder()
                
            default:
                
                break
                
            }
            
        }
        
    }
    
 /*   @objc func firstTextFieldTapped() {
        
        guard let firstDigit = correctOTP1.first else { return }
        
        emailOTPTxt1.text = String(firstDigit)
        
        guard correctOTP1.count >= 2 else { return }
        
        let secondIndex = correctOTP1.index(correctOTP1.startIndex, offsetBy: 1)
        
        let secondDigit = correctOTP1[secondIndex]
        
        emailOTPTxt2.text = String(secondDigit)
        
        guard correctOTP1.count >= 3 else { return }
        
        let thirdIndex = correctOTP1.index(correctOTP1.startIndex, offsetBy: 2)
        
        let thirdDigit = correctOTP1[thirdIndex]
        
        emailOTPTxt3.text = String(thirdDigit)
        
        
        
        emailOTPTxt2.becomeFirstResponder()
        
    }*/
    
    func showOTPNotification1() {
       
        let content = UNMutableNotificationContent()
        
        content.title = "Generated OTP"
        
        content.body = "Your OTP: \(correctOTP1)"
        
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "OTPNotification", content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                
                print("Error adding notification request: \(error)")
                
            }
            
        }
        
    }
    
 /*   func autofillOTP1() {
        
        guard correctOTP1.count == 3 else {
            
            return
            
        }
        
        
        emailOTPTxt1.text = String(correctOTP1[correctOTP1.startIndex])
        
        emailOTPTxt2.text = String(correctOTP1[correctOTP1.index(after: correctOTP1.startIndex)])
        
        emailOTPTxt3.text = String(correctOTP1[correctOTP1.index(correctOTP1.startIndex, offsetBy: 2)])
        
    }*/
    
    
    func getEnteredOTP1() -> String {
        
        let enteredOTP = [LoginEmailOTPTxt1.text, LoginEmailOTPTxt2.text, LoginEmailOTPTxt3.text]
        
        return enteredOTP.compactMap { $0 }.joined()
    
    }
    
    func clearAllTextFields() {
        
        LoginEmailOTPTxt1.text = ""
        
        LoginEmailOTPTxt2.text = ""
        
        LoginEmailOTPTxt3.text = ""
        
        LoginPhoneNumberTxt1.text = ""
        
        LoginPhoneNumberTxt2.text = ""
        
        LoginPhoneNumberTxt3.text = ""
        LoginPhoneNumberTxt1.becomeFirstResponder()
        
    }
    
  /*  func fillOTPFields1(with otp: String) {
        
        let otpArray = Array(otp)
        
        emailOTPTxt1.text = String(otpArray[0])
        
        emailOTPTxt2.text = String(otpArray[1])
        
        emailOTPTxt3.text = String(otpArray[2])
        
        
        
    }*/
    
    func autofillOTP2() {
        
        guard correctOTP2.count == 3 else {
            
            return
            
        }
        
        LoginPhoneNumberTxt1.text = String(correctOTP2[correctOTP2.startIndex])
        
        LoginPhoneNumberTxt2.text = String(correctOTP2[correctOTP2.index(after: correctOTP2.startIndex)])
        
        LoginPhoneNumberTxt3.text = String(correctOTP2[correctOTP2.index(correctOTP2.startIndex, offsetBy: 2)])
        
    }
    
    func getEnteredOTP2() -> String {
        
        let enteredOTP = [LoginPhoneNumberTxt1.text, LoginPhoneNumberTxt2.text, LoginPhoneNumberTxt3.text]
        
        return enteredOTP.compactMap { $0 }.joined()
        
    }
    
    func clearAllTextFields2() {
        
        LoginPhoneNumberTxt1.text = ""
        
        LoginPhoneNumberTxt2.text = ""
        
        LoginPhoneNumberTxt3.text = ""
        
        LoginEmailOTPTxt1.becomeFirstResponder()
        
    }
    
    func fillOTPFields2(with otp: String) {
        
        let otpArray = Array(otp)
        
        LoginPhoneNumberTxt1.text = String(otpArray[0])
        
        LoginPhoneNumberTxt2.text = String(otpArray[1])
        
        LoginPhoneNumberTxt3.text = String(otpArray[2])
        
    }
    
    
    
    func showOTPNotification2() {
        
        
        
        let content = UNMutableNotificationContent()
        
        content.title = "Generated OTP"
        
        content.body = "Your OTP: \(correctOTP2)"
        
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "OTPNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                
                print("Error adding notification request: \(error)")
                
            }
            
        }
        
    }
    
    @objc func secondTextFieldTapped() {
        
        guard let firstDigit = correctOTP2.first else { return }
        
        LoginPhoneNumberTxt1.text = String(firstDigit)
        
        guard correctOTP2.count >= 2 else { return }
        
        let secondIndex = correctOTP2.index(correctOTP2.startIndex, offsetBy: 1)
        
        let secondDigit = correctOTP2[secondIndex]
        
        LoginPhoneNumberTxt2.text = String(secondDigit)
        
        guard correctOTP2.count >= 3 else { return }
        
        let thirdIndex = correctOTP2.index(correctOTP2.startIndex, offsetBy: 2)
        
        let thirdDigit = correctOTP2[thirdIndex]
        
        LoginPhoneNumberTxt3.text = String(thirdDigit)
        
        LoginPhoneNumberTxt2.becomeFirstResponder()
        
        
    }
}
