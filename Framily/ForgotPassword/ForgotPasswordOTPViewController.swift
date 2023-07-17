//
//  ForgotPasswordOTPViewController.swift
//  Framily
//
//  Created by Varun kumar on 10/07/23.
//

import UIKit
import UserNotifications
import CoreData

class ForgotPasswordOtpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var FPEOtpTxt1: UITextField!
    @IBOutlet weak var FPEOtpTxt2: UITextField!
    @IBOutlet weak var FPEOtpTxt3: UITextField!
    @IBOutlet weak var generateOtp1: UIButton!
    @IBOutlet weak var FPPOtpTxt1: UITextField!
    @IBOutlet weak var FPPOtpTxt2: UITextField!
    @IBOutlet weak var FPPOtpTxt3: UITextField!
    @IBOutlet weak var generateOtp2: UIButton!
    @IBOutlet weak var ForgotPasswordOTPView: UIView!
    @IBOutlet weak var FPOTPnextBtn: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer: Timer?
        var timeRemaining = 10
    var correctOTP1: String = ""
    var otpDigits1: [String] = []
    var user: User?
    var correctOTP2: String = ""
    var otpDigits2: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ForgotPasswordOTPView.layer.cornerRadius = 20.0
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        FPEOtpTxt1.backgroundColor = UIColor.clear
       FPEOtpTxt1.borderStyle = .none
        FPEOtpTxt2.backgroundColor = UIColor.clear
       FPEOtpTxt2.borderStyle = .none
        FPEOtpTxt3.backgroundColor = UIColor.clear
       FPEOtpTxt3.borderStyle = .none
        FPPOtpTxt1.backgroundColor = UIColor.clear
       FPPOtpTxt1.borderStyle = .none
        FPPOtpTxt2.backgroundColor = UIColor.clear
       FPPOtpTxt2.borderStyle = .none
        FPPOtpTxt3.backgroundColor = UIColor.clear
       FPPOtpTxt3.borderStyle = .none
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        ForgotPasswordOTPView.layer.shadowColor = shadowColor
        ForgotPasswordOTPView.layer.shadowOpacity = shadowOpacity
       ForgotPasswordOTPView.layer.shadowOffset = shadowOffset
        ForgotPasswordOTPView.layer.shadowRadius = shadowRadius
        
        generateOtp1.layer.shadowColor = shadowColor
        generateOtp1.layer.shadowOpacity = shadowOpacity
        generateOtp1.layer.shadowOffset = shadowOffset
        generateOtp1.layer.shadowRadius = shadowRadius
        
        generateOtp2.layer.shadowColor = shadowColor
        generateOtp2.layer.shadowOpacity = shadowOpacity
        generateOtp2.layer.shadowOffset = shadowOffset
        generateOtp2.layer.shadowRadius = shadowRadius
        
        continueBtn.layer.shadowColor = shadowColor
        continueBtn.layer.shadowOpacity = shadowOpacity
        continueBtn.layer.shadowOffset = shadowOffset
        continueBtn.layer.shadowRadius = shadowRadius
        
        FPEOtpTxt1.layer.shadowColor = shadowColor
        FPEOtpTxt1.layer.shadowOpacity = shadowOpacity
        FPEOtpTxt1.layer.shadowOffset = shadowOffset
        FPEOtpTxt1.layer.shadowRadius = shadowRadius
        
        FPEOtpTxt2.layer.shadowColor = shadowColor
        FPEOtpTxt2.layer.shadowOpacity = shadowOpacity
        FPEOtpTxt2.layer.shadowOffset = shadowOffset
        FPEOtpTxt2.layer.shadowRadius = shadowRadius
        
        FPEOtpTxt3.layer.shadowColor = shadowColor
        FPEOtpTxt3.layer.shadowOpacity = shadowOpacity
        FPEOtpTxt3.layer.shadowOffset = shadowOffset
        FPEOtpTxt3.layer.shadowRadius = shadowRadius
        
        FPPOtpTxt1.layer.shadowColor = shadowColor
        FPPOtpTxt1.layer.shadowOpacity = shadowOpacity
        FPPOtpTxt1.layer.shadowOffset = shadowOffset
        FPPOtpTxt1.layer.shadowRadius = shadowRadius
        
        FPPOtpTxt2.layer.shadowColor = shadowColor
        FPPOtpTxt2.layer.shadowOpacity = shadowOpacity
        FPPOtpTxt2.layer.shadowOffset = shadowOffset
        FPPOtpTxt2.layer.shadowRadius = shadowRadius
        
        FPPOtpTxt3.layer.shadowColor = shadowColor
        FPPOtpTxt3.layer.shadowOpacity = shadowOpacity
        FPPOtpTxt3.layer.shadowOffset = shadowOffset
        FPPOtpTxt3.layer.shadowRadius = shadowRadius
        
        generateOtp1.layer.cornerRadius = 10
        generateOtp2.layer.cornerRadius = 10
        continueBtn.layer.cornerRadius = 10
        
        FPEOtpTxt1.delegate = self
        FPEOtpTxt2.delegate = self
        FPEOtpTxt3.delegate = self
        FPPOtpTxt1.delegate = self
        FPPOtpTxt2.delegate = self
        FPPOtpTxt3.delegate = self
        
        FPEOtpTxt1.keyboardType = .numberPad
        FPEOtpTxt2.keyboardType = .numberPad
        FPEOtpTxt3.keyboardType = .numberPad
        FPPOtpTxt1.keyboardType = .numberPad
        FPPOtpTxt2.keyboardType = .numberPad
        FPPOtpTxt3.keyboardType = .numberPad
        FPOTPnextBtn.layer.cornerRadius = 10.0
        FPEOtpTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        FPEOtpTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        FPEOtpTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        FPPOtpTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        FPPOtpTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        FPPOtpTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(firstTextFieldTapped))
        FPEOtpTxt1.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(secondTextFieldTapped))
        FPPOtpTxt1.addGestureRecognizer(tapGesture2)
        
        otpDigits1 = Array(arrayLiteral: String(correctOTP1))
        
        let underlineLayer = CALayer()
        underlineLayer.frame = CGRect(x: 0, y: FPEOtpTxt1.frame.size.height - 1, width: FPEOtpTxt1.frame.size.width, height: 1)
        underlineLayer.backgroundColor = UIColor.white.cgColor
        FPEOtpTxt1.layer.addSublayer(underlineLayer)
        let underlineLayer1 = CALayer()
        underlineLayer1.frame = CGRect(x: 0, y: FPEOtpTxt2.frame.size.height - 1, width: FPEOtpTxt2.frame.size.width, height: 1)
        underlineLayer1.backgroundColor = UIColor.white.cgColor
        FPEOtpTxt2.layer.addSublayer(underlineLayer1)
        let underlineLayer2 = CALayer()
        underlineLayer2.frame = CGRect(x: 0, y: FPEOtpTxt3.frame.size.height - 1, width: FPEOtpTxt3.frame.size.width, height: 1)
        underlineLayer2.backgroundColor = UIColor.white.cgColor
        FPEOtpTxt3.layer.addSublayer(underlineLayer2)
        let underlineLayer3 = CALayer()
        underlineLayer3.frame = CGRect(x: 0, y: FPPOtpTxt1.frame.size.height - 1, width: FPPOtpTxt1.frame.size.width, height: 1)
        underlineLayer3.backgroundColor = UIColor.white.cgColor
        FPPOtpTxt1.layer.addSublayer(underlineLayer3)
        let underlineLayer4 = CALayer()
        underlineLayer4.frame = CGRect(x: 0, y: FPPOtpTxt2.frame.size.height - 1, width: FPPOtpTxt2.frame.size.width, height: 1)
        underlineLayer4.backgroundColor = UIColor.white.cgColor
        FPPOtpTxt2.layer.addSublayer(underlineLayer4)
        let underlineLayer5 = CALayer()
        underlineLayer5.frame = CGRect(x: 0, y: FPPOtpTxt3.frame.size.height - 1, width: FPPOtpTxt3.frame.size.width, height: 1)
        underlineLayer5.backgroundColor = UIColor.white.cgColor
        FPPOtpTxt3.layer.addSublayer(underlineLayer5)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func startTimer() {
       
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        timeRemaining -= 1
        timerLabel.text = "\(timeRemaining) seconds remaining"
        if timeRemaining <= 0 {
        
            timer?.invalidate()
            
            resendButton.isHidden = false
        }
    }

    @IBAction func resendButtonTapped(_ sender: UIButton) {
       
        timeRemaining = 10
        resendButton.isHidden = true

        startTimer()
    }
    
    @IBAction func generateOTP1ButtonPressed(_ sender: UIButton) {
        generateOTP1()
        autofillOTP1()
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
            showCustomAlertWith(message: "Incorrect OTP. Please try again.", descMsg: "", actions: nil)
            clearAllTextFields()
            return
        }

        guard !enteredOTP2().isEmpty && enteredOTP2() == correctOTP2 else {
            showCustomAlertWith(message: "Incorrect OTP. Please try again.", descMsg: "", actions: nil)
            clearAllTextFields()
            return
        }

        performSegue(withIdentifier: "FPOtpToConfirmPass", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FPOtpToConfirmPass" {
            if let confirmPassViewController = segue.destination as? ForgotPasswordConfirmPassViewController,
                let validatedUser = user {
                confirmPassViewController.user = validatedUser
            }
        }
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
        return newLength <= 1
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count == 1 {
            switch textField {
            case FPEOtpTxt1:
                FPEOtpTxt2.becomeFirstResponder()
            case FPEOtpTxt2:
                FPEOtpTxt3.becomeFirstResponder()
            case FPEOtpTxt3:
                FPPOtpTxt1.becomeFirstResponder()
            case FPPOtpTxt1:
                FPPOtpTxt2.becomeFirstResponder()
            case FPPOtpTxt2:
                FPPOtpTxt3.becomeFirstResponder()
            case FPPOtpTxt3:
                FPPOtpTxt3.resignFirstResponder()
            default:
                break
              }
            } else if text.isEmpty {
                switch textField {
                case FPEOtpTxt2:
                    FPEOtpTxt1.becomeFirstResponder()
                case FPEOtpTxt3:
                    FPEOtpTxt2.becomeFirstResponder()
                case FPPOtpTxt2:
                    FPPOtpTxt1.becomeFirstResponder()
                case FPPOtpTxt3:
                    FPPOtpTxt2.becomeFirstResponder()
                default:
                    break
                }
            }
        }
    
    @objc func firstTextFieldTapped() {
        guard let firstDigit = correctOTP1.first else { return }
        
        FPEOtpTxt1.text = String(firstDigit)
        
        guard correctOTP1.count >= 2 else { return }
        let secondIndex = correctOTP1.index(correctOTP1.startIndex, offsetBy: 1)
        let secondDigit = correctOTP1[secondIndex]
        FPEOtpTxt2.text = String(secondDigit)
        
        guard correctOTP1.count >= 3 else { return }
        let thirdIndex = correctOTP1.index(correctOTP1.startIndex, offsetBy: 2)
        let thirdDigit = correctOTP1[thirdIndex]
        FPEOtpTxt3.text = String(thirdDigit)
        
        FPEOtpTxt2.becomeFirstResponder()
    }
    

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
  
    func autofillOTP1() {
        guard correctOTP1.count == 3 else {
            
            return
        }
        
        FPEOtpTxt1.text = String(correctOTP1[correctOTP1.startIndex])
        FPEOtpTxt2.text = String(correctOTP1[correctOTP1.index(after: correctOTP1.startIndex)])
        FPEOtpTxt3.text = String(correctOTP1[correctOTP1.index(correctOTP1.startIndex, offsetBy: 2)])
    }
    
    
    func getEnteredOTP1() -> String {
        let enteredOTP = [FPEOtpTxt1.text, FPEOtpTxt2.text, FPEOtpTxt3.text]
        return enteredOTP.compactMap { $0 }.joined()
    }
    
    func clearAllTextFields() {
        FPEOtpTxt1.text = ""
        FPEOtpTxt2.text = ""
        FPEOtpTxt3.text = ""
        FPPOtpTxt1.text = ""
        FPPOtpTxt2.text = ""
        FPPOtpTxt3.text = ""
        
        FPEOtpTxt1.becomeFirstResponder()
    }
    func fillOTPFields1(with otp: String) {
        let otpArray = Array(otp)
        
        FPEOtpTxt1.text = String(otpArray[0])
        FPEOtpTxt2.text = String(otpArray[1])
        FPEOtpTxt3.text = String(otpArray[2])
       
    }
    func autofillOTP2() {
        guard correctOTP2.count == 3 else {
            
            return
        }
        
        FPPOtpTxt1.text = String(correctOTP2[correctOTP2.startIndex])
        FPPOtpTxt2.text = String(correctOTP2[correctOTP2.index(after: correctOTP2.startIndex)])
        FPPOtpTxt3.text = String(correctOTP2[correctOTP2.index(correctOTP2.startIndex, offsetBy: 2)])
    }
    
    
    func getEnteredOTP2() -> String {
        let enteredOTP = [FPPOtpTxt1.text, FPPOtpTxt2.text, FPPOtpTxt3.text]
        return enteredOTP.compactMap { $0 }.joined()
    }
    
    func clearAllTextFields2() {
        FPPOtpTxt1.text = ""
        FPPOtpTxt2.text = ""
        FPPOtpTxt3.text = ""
        
        
        FPEOtpTxt1.becomeFirstResponder()
    }
    func fillOTPFields2(with otp: String) {
        let otpArray = Array(otp)
        
        FPPOtpTxt1.text = String(otpArray[0])
        FPPOtpTxt2.text = String(otpArray[1])
        FPPOtpTxt3.text = String(otpArray[2])
       
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
        
        FPPOtpTxt1.text = String(firstDigit)
        
        guard correctOTP2.count >= 2 else { return }
        let secondIndex = correctOTP2.index(correctOTP2.startIndex, offsetBy: 1)
        let secondDigit = correctOTP2[secondIndex]
        FPPOtpTxt2.text = String(secondDigit)
        
        guard correctOTP2.count >= 3 else { return }
        let thirdIndex = correctOTP2.index(correctOTP2.startIndex, offsetBy: 2)
        let thirdDigit = correctOTP2[thirdIndex]
        FPPOtpTxt3.text = String(thirdDigit)
        
        FPPOtpTxt2.becomeFirstResponder()
    }
}
