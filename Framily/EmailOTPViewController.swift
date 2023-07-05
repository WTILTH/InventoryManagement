//
//  EmailOTPViewController.swift
//  Framily
//
//  Created by Varun kumar on 05/07/23.
//

import UIKit

class EmailOTPViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailOTPTxt1: UITextField!
    @IBOutlet weak var emailOTPTxt2: UITextField!
    @IBOutlet weak var emailOTPTxt3: UITextField!
    @IBOutlet weak var phoneNumberTxt1: UITextField!
    @IBOutlet weak var phoneNumberTxt2: UITextField!
    @IBOutlet weak var phoneNumberTxt3: UITextField!
    var correctOTP: String = ""
    var otpDigits: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 1.5
        let shadowOffset = CGSize(width: 0, height: 2)
        let shadowRadius: CGFloat = 4
        
        
        emailOTPTxt1.layer.shadowColor = shadowColor
        emailOTPTxt1.layer.shadowOpacity = shadowOpacity
        emailOTPTxt1.layer.shadowOffset = shadowOffset
        emailOTPTxt1.layer.shadowRadius = shadowRadius
        emailOTPTxt2.layer.shadowColor = shadowColor
        emailOTPTxt2.layer.shadowOpacity = shadowOpacity
        emailOTPTxt2.layer.shadowOffset = shadowOffset
        emailOTPTxt2.layer.shadowRadius = shadowRadius
        emailOTPTxt3.layer.shadowColor = shadowColor
        emailOTPTxt3.layer.shadowOpacity = shadowOpacity
        emailOTPTxt3.layer.shadowOffset = shadowOffset
        emailOTPTxt3.layer.shadowRadius = shadowRadius
        phoneNumberTxt1.layer.shadowColor = shadowColor
        phoneNumberTxt1.layer.shadowOpacity = shadowOpacity
        phoneNumberTxt1.layer.shadowOffset = shadowOffset
        phoneNumberTxt1.layer.shadowRadius = shadowRadius
        phoneNumberTxt2.layer.shadowColor = shadowColor
        phoneNumberTxt2.layer.shadowOpacity = shadowOpacity
        phoneNumberTxt2.layer.shadowOffset = shadowOffset
        phoneNumberTxt2.layer.shadowRadius = shadowRadius
        phoneNumberTxt3.layer.shadowColor = shadowColor
        phoneNumberTxt3.layer.shadowOpacity = shadowOpacity
        phoneNumberTxt3.layer.shadowOffset = shadowOffset
        phoneNumberTxt3.layer.shadowRadius = shadowRadius
        
        emailOTPTxt1.delegate = self
        emailOTPTxt2.delegate = self
        emailOTPTxt3.delegate = self
        phoneNumberTxt1.delegate = self
        phoneNumberTxt2.delegate = self
        phoneNumberTxt3.delegate = self
        
        emailOTPTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailOTPTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       phoneNumberTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            phoneNumberTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(firstTextFieldTapped))
        emailOTPTxt1.addGestureRecognizer(tapGesture)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(firstTextFieldTapped))
        phoneNumberTxt1.addGestureRecognizer(tapGesture1)
        otpDigits = Array(arrayLiteral: String(correctOTP))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func generateOTP(_ sender: Any) {
        generateOTP()
        autofillOTP()
        
        showCustomAlertWith(message: "Generated OTP: \(correctOTP)", descMsg: "", actions: nil)
        
        showOTPNotification()
        
    }
    
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        let enteredOTP = getEnteredOTP()
        
        guard !enteredOTP.isEmpty && enteredOTP == correctOTP else {
            showCustomAlertWith(message: "Incorrect OTP. Please try again.", descMsg: "", actions: nil)
           
            clearAllTextFields()
            return
        }
        
        performSegue(withIdentifier: "OTPToConfirmPassword", sender: nil)
    }
        
    
    func generateOTP() {
        
        let otpDigits = (0..<3).map { _ in String(Int.random(in: 0...9)) }
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
            case phoneNumberTxt1:
                phoneNumberTxt2.becomeFirstResponder()
            case phoneNumberTxt2:
                phoneNumberTxt3.becomeFirstResponder()
            case phoneNumberTxt3:
                phoneNumberTxt3.resignFirstResponder()
            default:
                break
            }
        } else if text.isEmpty {
            switch textField {
            case phoneNumberTxt2:
                phoneNumberTxt1.becomeFirstResponder()
            case phoneNumberTxt3:
               phoneNumberTxt2.becomeFirstResponder()
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
        
        phoneNumberTxt1.text = String(firstDigit)
        
        guard correctOTP.count >= 2 else { return }
        let secondIndex = correctOTP.index(correctOTP.startIndex, offsetBy: 1)
        let secondDigit = correctOTP[secondIndex]
        phoneNumberTxt2.text = String(secondDigit)
        
        guard correctOTP.count >= 3 else { return }
        let thirdIndex = correctOTP.index(correctOTP.startIndex, offsetBy: 2)
        let thirdDigit = correctOTP[thirdIndex]
        phoneNumberTxt3.text = String(thirdDigit)
        
        phoneNumberTxt2.becomeFirstResponder()
    }
    func autofillOTP() {
        guard correctOTP.count == 3 else {
            
            return
        }
        
        phoneNumberTxt1.text = String(correctOTP[correctOTP.startIndex])
        phoneNumberTxt2.text = String(correctOTP[correctOTP.index(after: correctOTP.startIndex)])
        phoneNumberTxt3.text = String(correctOTP[correctOTP.index(correctOTP.startIndex, offsetBy: 2)])
        
    }
    func getEnteredOTP() -> String {
        let enteredOTP = [phoneNumberTxt1.text, phoneNumberTxt2.text, phoneNumberTxt3.text]
        return enteredOTP.compactMap { $0 }.joined()
    }
    
    func clearAllTextFields() {
        phoneNumberTxt1.text = ""
        phoneNumberTxt2.text = ""
        phoneNumberTxt3.text = ""
        phoneNumberTxt1.becomeFirstResponder()
    }
    
    func fillOTPFields(with otp: String) {
        let otpArray = Array(otp)
        
        phoneNumberTxt1.text = String(otpArray[0])
        phoneNumberTxt2.text = String(otpArray[1])
        phoneNumberTxt3.text = String(otpArray[2])
        
    }
    func showAlert(message: String) {
    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
  present(alert, animated: true, completion: nil)
 }
}
