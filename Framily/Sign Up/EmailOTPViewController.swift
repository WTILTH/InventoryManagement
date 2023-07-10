//
//  EmailOTPViewController.swift
//  Framily
//
//  Created by Varun kumar on 05/07/23.
//

import UIKit
import UserNotifications
import CoreData

class EmailOTPViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailOTPTxt1: UITextField!
    @IBOutlet weak var emailOTPTxt2: UITextField!
    @IBOutlet weak var emailOTPTxt3: UITextField!
    @IBOutlet weak var phoneNumberTxt1: UITextField!
    @IBOutlet weak var phoneNumberTxt2: UITextField!
    @IBOutlet weak var phoneNumberTxt3: UITextField!
    @IBOutlet weak var emailOTPBtn: UIButton!
    @IBOutlet weak var phoneNumberOTPBtn: UIButton!
    
    var correctOTP1: String = ""
    var otpDigits1: [String] = []
    var correctOTP2: String = ""
    var otpDigits2: [String] = []
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
        
        emailOTPTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        emailOTPTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        phoneNumberTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        phoneNumberTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        phoneNumberTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(firstTextFieldTapped))

                emailOTPTxt1.addGestureRecognizer(tapGesture1)

                

                let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(secondTextFieldTapped))

                phoneNumberTxt1.addGestureRecognizer(tapGesture2)

                

                otpDigits1 = Array(arrayLiteral: String(correctOTP1))

            }

            

            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

                self.view.endEditing(true)

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




                performSegue(withIdentifier: "OTPToConfirmPassword", sender: nil)

                

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

                    case emailOTPTxt1:

                       emailOTPTxt2.becomeFirstResponder()

                    case emailOTPTxt2:

                        emailOTPTxt3.becomeFirstResponder()

                    case emailOTPTxt3:

                        phoneNumberTxt1.becomeFirstResponder()

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

                        case emailOTPTxt2:

                            emailOTPTxt1.becomeFirstResponder()

                        case emailOTPTxt3:

                            emailOTPTxt2.becomeFirstResponder()

                        case phoneNumberTxt2:

                            phoneNumberTxt1.becomeFirstResponder()

                        case phoneNumberTxt3:

                            phoneNumberTxt2.becomeFirstResponder()

                        default:

                            break

                        }

                    }

                }

            

            @objc func firstTextFieldTapped() {

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

                

                emailOTPTxt1.text = String(correctOTP1[correctOTP1.startIndex])

                emailOTPTxt2.text = String(correctOTP1[correctOTP1.index(after: correctOTP1.startIndex)])

                emailOTPTxt3.text = String(correctOTP1[correctOTP1.index(correctOTP1.startIndex, offsetBy: 2)])

            }

            

            

            func getEnteredOTP1() -> String {

                let enteredOTP = [emailOTPTxt1.text, emailOTPTxt2.text, emailOTPTxt3.text]

                return enteredOTP.compactMap { $0 }.joined()

            }

            

            func clearAllTextFields() {

                emailOTPTxt1.text = ""

                emailOTPTxt2.text = ""

                emailOTPTxt3.text = ""

                phoneNumberTxt1.text = ""

                phoneNumberTxt2.text = ""

                phoneNumberTxt3.text = ""

                

                phoneNumberTxt1.becomeFirstResponder()

            }

            func fillOTPFields1(with otp: String) {

                let otpArray = Array(otp)

                

                emailOTPTxt1.text = String(otpArray[0])

                emailOTPTxt2.text = String(otpArray[1])

                emailOTPTxt3.text = String(otpArray[2])

               

            }

            func autofillOTP2() {

                guard correctOTP2.count == 3 else {

                    

                    return

                }

                

                phoneNumberTxt1.text = String(correctOTP2[correctOTP2.startIndex])

                phoneNumberTxt2.text = String(correctOTP2[correctOTP2.index(after: correctOTP2.startIndex)])

                phoneNumberTxt3.text = String(correctOTP2[correctOTP2.index(correctOTP2.startIndex, offsetBy: 2)])

            }

            

            

            func getEnteredOTP2() -> String {

                let enteredOTP = [phoneNumberTxt1.text, phoneNumberTxt2.text, phoneNumberTxt3.text]

                return enteredOTP.compactMap { $0 }.joined()

            }

            

            func clearAllTextFields2() {

                phoneNumberTxt1.text = ""

                phoneNumberTxt2.text = ""

                phoneNumberTxt3.text = ""

                

                

                emailOTPTxt1.becomeFirstResponder()

            }

            func fillOTPFields2(with otp: String) {

                let otpArray = Array(otp)

                

                phoneNumberTxt1.text = String(otpArray[0])

                phoneNumberTxt2.text = String(otpArray[1])

                phoneNumberTxt3.text = String(otpArray[2])

               

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

                

               phoneNumberTxt1.text = String(firstDigit)

                

                guard correctOTP2.count >= 2 else { return }

                let secondIndex = correctOTP2.index(correctOTP2.startIndex, offsetBy: 1)

                let secondDigit = correctOTP2[secondIndex]

                phoneNumberTxt2.text = String(secondDigit)

                

                guard correctOTP2.count >= 3 else { return }

                let thirdIndex = correctOTP2.index(correctOTP2.startIndex, offsetBy: 2)

                let thirdDigit = correctOTP2[thirdIndex]

                phoneNumberTxt3.text = String(thirdDigit)

                

                phoneNumberTxt2.becomeFirstResponder()

            }

        }