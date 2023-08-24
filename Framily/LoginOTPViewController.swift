//
//  LoginOTPViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Varun kumar on 25/07/23.
//
//  Module : Login 
import UIKit
import UserNotifications
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | UX
0.2   | 14-Aug-2023  | Tharun Kumar    | Validations
Changes:
 
 */
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
    
        
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        LoginEmailOTPTxt1.delegate = self
        LoginEmailOTPTxt2.delegate = self
        LoginEmailOTPTxt3.delegate = self
        
        LoginPhoneNumberTxt1.delegate = self
        LoginPhoneNumberTxt2.delegate = self
        LoginPhoneNumberTxt3.delegate = self
        
        LoginEmailOTPTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        LoginEmailOTPTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        LoginEmailOTPTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        LoginPhoneNumberTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        LoginPhoneNumberTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        LoginPhoneNumberTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
      /*  let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(firstTextFieldTapped))
        
        emailOTPTxt1.addGestureRecognizer(tapGesture1)*/
        
        
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(secondTextFieldTapped))
        LoginPhoneNumberTxt1.addGestureRecognizer(tapGesture2)
        otpDigits1 = Array(arrayLiteral: String(correctOTP1))
       
        startTimer()
        
    }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - startTimer: Function to Start the OTP timer
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        LoginResendButton.isEnabled = false
    }
    // MARK: - updateTimer: Function to Update the timer label every second
    @objc func updateTimer() {
        timeRemaining -= 1
        LoginTimerLabel.text = "\(timeRemaining) seconds remaining"
        if timeRemaining <= 0 {
            timer?.invalidate()
            LoginResendButton.isEnabled = true
        }
    }
    // MARK: - resendButtonTapped: Function to Resend the OTP and disable the buttons in login page
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
    // MARK: - prepare: Function to segue to the login page and disable the buttons
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmailPhoneOTPToLogin" {
            // Pass the shouldDisableButtons flag to loginUserNameViewController
            if let loginViewController = segue.destination as? loginUserNameViewController {
                loginViewController.shouldDisableButtons = shouldDisableButtons
            }
        }
    }
    // MARK: - generateOTP1ButtonPressed: Function to generate Email OTP after pressing the button
    @IBAction func generateOTP1ButtonPressed(_ sender: UIButton) {
        generateOTP1()
        //autofillOTP1()
        showCustomAlertWith(message: "Generated OTP: \(correctOTP1)", descMsg: "", actions: nil)
        showOTPNotification1()
    }
    // MARK: - generateOTP2ButtonPressed: Function to generate Phone number OTP after pressing the button
    @IBAction func generateOTP2ButtonPressed(_ sender: UIButton) {
        generateOTP2()
        autofillOTP2()
        showCustomAlertWith(message: "Generated OTP: \(correctOTP2)", descMsg: "", actions: nil)
        showOTPNotification2()
        
    }
    // MARK: - ContinueButtonPressed: Function to Continue button action to verify OTPs and proceed to the next screen
    @IBAction func ContinueButtonPressed(_ sender: Any) {
        let enteredOTP1 = getEnteredOTP1
        let enteredOTP2 = getEnteredOTP2
        guard !enteredOTP1().isEmpty && enteredOTP1() == correctOTP1 else {
            showCustomAlertWith(message: "Incorrect Email OTP. Please try again.", descMsg: "", actions: nil)
            //clearAllTextFields()
            return
        }
        guard !enteredOTP2().isEmpty && enteredOTP2() == correctOTP2 else {
            showCustomAlertWith(message: "Incorrect Phone number OTP. Please try again.", descMsg: "", actions: nil)
           // clearAllTextFields()
            return
        }
        performSegue(withIdentifier: "LoginOTPToHome", sender: nil)
    }
    // MARK: - generateOTP1: Function to Generate OTP for Email
    func generateOTP1() {
        let otpDigits = (0..<3).map { _ in String(Int.random(in: 0...9)) }
        correctOTP1 = otpDigits.joined()
    }
    // MARK: - generateOTP2: Function to Generate OTP for Phone Number
    func generateOTP2() {
        let otpDigits = (0..<3).map { _ in String(Int.random(in: 0...9)) }
        correctOTP2 = otpDigits.joined()
    }
    // MARK: - textField: Function to Limit each OTP text field to allow only one character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1

        if string.isEmpty {
            return true
        }

        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        return newLength <= maxLength
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - textFieldDidChange: Function to Handle text field editing to navigate between OTP text fields
    @objc func textFieldDidChange(_ textField: UITextField) {
        let maxLength = 1

        if let text = textField.text, text.count >= maxLength {
            if textField == LoginEmailOTPTxt1 {
                LoginEmailOTPTxt2.becomeFirstResponder()
            } else if textField == LoginEmailOTPTxt2 {
                LoginEmailOTPTxt3.becomeFirstResponder()
            } else if textField == LoginEmailOTPTxt3 {
                LoginEmailOTPTxt3.resignFirstResponder()
            } else if textField == LoginPhoneNumberTxt1 {
                LoginPhoneNumberTxt2.becomeFirstResponder()
            } else if textField == LoginPhoneNumberTxt2 {
                LoginPhoneNumberTxt3.becomeFirstResponder()
            } else if textField == LoginPhoneNumberTxt3 {
                LoginPhoneNumberTxt3.resignFirstResponder()
            }
        } else if textField.text?.isEmpty ?? false {
            if textField == LoginEmailOTPTxt2 {
                LoginEmailOTPTxt1.becomeFirstResponder()
            } else if textField == LoginEmailOTPTxt3 {
                LoginEmailOTPTxt2.becomeFirstResponder()
            } else if textField == LoginPhoneNumberTxt2 {
                LoginPhoneNumberTxt1.becomeFirstResponder()
            } else if textField == LoginPhoneNumberTxt3 {
                LoginPhoneNumberTxt2.becomeFirstResponder()
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
    // MARK: - showOTPNotification1: Function to Function to show the notification with the generated OTP for Email
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
    // MARK: - getEnteredOTP1: Function to Function to get the entered OTP for Email
    func getEnteredOTP1() -> String {
        let enteredOTP = [LoginEmailOTPTxt1.text, LoginEmailOTPTxt2.text, LoginEmailOTPTxt3.text]
        return enteredOTP.compactMap { $0 }.joined()
    }
    /*func clearAllTextFields() {
        LoginEmailOTPTxt1.text = ""
        LoginEmailOTPTxt2.text = ""
        LoginEmailOTPTxt3.text = ""
        LoginPhoneNumberTxt1.text = ""
        LoginPhoneNumberTxt2.text = ""
        LoginPhoneNumberTxt3.text = ""
        LoginPhoneNumberTxt1.becomeFirstResponder()
    }*/
    
  /*  func fillOTPFields1(with otp: String) {
        
        let otpArray = Array(otp)
        
        emailOTPTxt1.text = String(otpArray[0])
        
        emailOTPTxt2.text = String(otpArray[1])
        
        emailOTPTxt3.text = String(otpArray[2])
        
        
        
    }*/
    // MARK: - autofillOTP2: Function to autofill the OTP for phone number OTP
    func autofillOTP2() {
        guard correctOTP2.count == 3 else {
            return
        }
        LoginPhoneNumberTxt1.text = String(correctOTP2[correctOTP2.startIndex])
        LoginPhoneNumberTxt2.text = String(correctOTP2[correctOTP2.index(after: correctOTP2.startIndex)])
        LoginPhoneNumberTxt3.text = String(correctOTP2[correctOTP2.index(correctOTP2.startIndex, offsetBy: 2)])
        
    }
    // MARK: - getEnteredOTP2: Function to get the entered OTP for Phone Number
    func getEnteredOTP2() -> String {
        let enteredOTP = [LoginPhoneNumberTxt1.text, LoginPhoneNumberTxt2.text, LoginPhoneNumberTxt3.text]
        return enteredOTP.compactMap { $0 }.joined()
    }
    // MARK: - clearAllTextFields2: Function to Function to clear all the OTP text fields
    func clearAllTextFields2() {
        LoginPhoneNumberTxt1.text = ""
        LoginPhoneNumberTxt2.text = ""
        LoginPhoneNumberTxt3.text = ""
        LoginEmailOTPTxt1.becomeFirstResponder()
    }
    // MARK: - fillOTPFields2: Function to fill the Phone number OTP
    func fillOTPFields2(with otp: String) {
        let otpArray = Array(otp)
        LoginPhoneNumberTxt1.text = String(otpArray[0])
        LoginPhoneNumberTxt2.text = String(otpArray[1])
        LoginPhoneNumberTxt3.text = String(otpArray[2])
    }
    // MARK: - showOTPNotification2: Function to show OTP notifications
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
    // MARK: - secondTextFieldTapped: Function to go to next text field after entering
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
