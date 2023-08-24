//
//  ForgotPasswordOTPViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Varun kumar on 05/07/23.
//
//  Module : Login
import UIKit
import UserNotifications
import CoreData
import CryptoKit
/*Version History
Draft|| Date        || Author         || Description
 0.1   | 14-Aug-2023  | Varun Kumar     | Validations
 0.2   | 14-Aug-2023  | Tharun Kumar    | UX
Changes:
 
 */
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
    @IBOutlet weak var FPOTPnextBtn: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var responseData: [String: Any]?
    var shouldDisableButtons = false
    var resendAttempts = 0
    var timer: Timer?
        var timeRemaining = 10
    var correctOTP1: String = ""
    var otpDigits1: [String] = []
    var user: User?
    var correctOTP2: String = ""
    var otpDigits2: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(responseData)
        startTimer()
       
        view.backgroundColor = BackgroundManager.shared.backgroundColor

        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        generateOtp1.layer.cornerRadius = 10
        generateOtp2.layer.cornerRadius = 10
        continueBtn.layer.cornerRadius = 10
        FPOTPnextBtn.layer.cornerRadius = 10.0
        
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
        
        FPEOtpTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        FPEOtpTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        FPEOtpTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        FPPOtpTxt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        FPPOtpTxt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        FPPOtpTxt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
       /* let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(firstTextFieldTapped))
        FPEOtpTxt1.addGestureRecognizer(tapGesture1)*/
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(secondTextFieldTapped))
        FPPOtpTxt1.addGestureRecognizer(tapGesture2)
        
        otpDigits1 = Array(arrayLiteral: String(correctOTP1))
        
    }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - handleOTPVerificationAndNavigate: Function to Transfer the data passed from ForgotPasswordOtpViewcontroller to the ForgotPasswordConfirmPassViewController
    func handleOTPVerificationAndNavigate() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ForgotPasswordConfirmPassViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordConfirmPassViewControllers") as! ForgotPasswordConfirmPassViewController
            ForgotPasswordConfirmPassViewController.responseData = self.responseData
            self.navigationController?.pushViewController(ForgotPasswordConfirmPassViewController, animated: true)
        }
    }
    // MARK: - startTimer: Function to Start the OTP timer
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        resendButton.isEnabled = false
    }
    // MARK: - updateTimer: Function to Update the timer label every second
    @objc func updateTimer() {
        timeRemaining -= 1
        timerLabel.text = "\(timeRemaining) seconds remaining"
        if timeRemaining <= 0 {
            timer?.invalidate()
            resendButton.isEnabled = true
        }
    }
    // MARK: - resendButtonTapped: Function to Resend the OTP and disable the buttons in login page
    @IBAction func resendButtonTapped(_ sender: UIButton) {
        if resendAttempts < 3 {
            timeRemaining = 10
            startTimer()
            resendAttempts += 1
            resendButton.isEnabled = false
            shouldDisableButtons = true
        } else {
            showCustomAlertWith(okButtonAction: {
                self.performSegue(withIdentifier: "FPOTPToLogin", sender: nil)
            }, message: "Please contact the admin.", descMsg: "", actions: nil)
        }
    }
    // MARK: - prepare: Function to segue to the login page and disable the buttons
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FPOTPToLogin" {
            
            if let loginViewController = segue.destination as? loginUserNameViewController {
                loginViewController.shouldDisableButtons = shouldDisableButtons
            }
        }
    }
    // MARK: - generateOTP1ButtonPressed: Function to generate Email OTP after pressing the button
    @IBAction func generateOTP1ButtonPressed(_ sender: UIButton) {
        generateOTP1()
      //  autofillOTP1()
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
          //  clearAllTextFields()
            return
        }
        guard !enteredOTP2().isEmpty && enteredOTP2() == correctOTP2 else {
            showCustomAlertWith(message: "Incorrect Phone number OTP. Please try again.", descMsg: "", actions: nil)
           // clearAllTextFields()
            return
        }
        handleOTPVerificationAndNavigate()
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
            if textField == FPEOtpTxt1 {
                FPEOtpTxt2.becomeFirstResponder()
            } else if textField == FPEOtpTxt2 {
                FPEOtpTxt3.becomeFirstResponder()
            } else if textField == FPEOtpTxt3 {
                FPEOtpTxt3.resignFirstResponder()
            } else if textField == FPPOtpTxt1 {
                FPPOtpTxt2.becomeFirstResponder()
            } else if textField == FPPOtpTxt2 {
                FPPOtpTxt3.becomeFirstResponder()
            } else if textField == FPPOtpTxt3 {
                FPPOtpTxt3.resignFirstResponder()
            }
        } else if textField.text?.isEmpty ?? false {
            if textField == FPEOtpTxt2 {
                FPEOtpTxt1.becomeFirstResponder()
            } else if textField == FPEOtpTxt3 {
                FPEOtpTxt2.becomeFirstResponder()
            } else if textField == FPPOtpTxt2 {
                FPPOtpTxt1.becomeFirstResponder()
            } else if textField == FPPOtpTxt3 {
                FPPOtpTxt2.becomeFirstResponder()
            }
        }
    }
    
   /* @objc func firstTextFieldTapped() {
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
  
  /*  func autofillOTP1() {
        guard correctOTP1.count == 3 else {
            
            return
        }
        
        FPEOtpTxt1.text = String(correctOTP1[correctOTP1.startIndex])
        FPEOtpTxt2.text = String(correctOTP1[correctOTP1.index(after: correctOTP1.startIndex)])
        FPEOtpTxt3.text = String(correctOTP1[correctOTP1.index(correctOTP1.startIndex, offsetBy: 2)])
    }*/
    // MARK: - getEnteredOTP1: Function to Function to get the entered OTP for Email
    func getEnteredOTP1() -> String {
        let enteredOTP = [FPEOtpTxt1.text, FPEOtpTxt2.text, FPEOtpTxt3.text]
        return enteredOTP.compactMap { $0 }.joined()
    }
    
    /*func clearAllTextFields() {
        FPEOtpTxt1.text = ""
        FPEOtpTxt2.text = ""
        FPEOtpTxt3.text = ""
        FPPOtpTxt1.text = ""
        FPPOtpTxt2.text = ""
        FPPOtpTxt3.text = ""
        
        FPEOtpTxt1.becomeFirstResponder()
    }*/
  /*  func fillOTPFields1(with otp: String) {
        let otpArray = Array(otp)
        
        FPEOtpTxt1.text = String(otpArray[0])
        FPEOtpTxt2.text = String(otpArray[1])
        FPEOtpTxt3.text = String(otpArray[2])
       
    }*/
    // MARK: - autofillOTP2: Function to autofill the OTP for phone number OTP
    func autofillOTP2() {
        guard correctOTP2.count == 3 else {
            return
        }
        FPPOtpTxt1.text = String(correctOTP2[correctOTP2.startIndex])
        FPPOtpTxt2.text = String(correctOTP2[correctOTP2.index(after: correctOTP2.startIndex)])
        FPPOtpTxt3.text = String(correctOTP2[correctOTP2.index(correctOTP2.startIndex, offsetBy: 2)])
    }
    // MARK: - getEnteredOTP2: Function to get the entered OTP for Phone Number
    func getEnteredOTP2() -> String {
        let enteredOTP = [FPPOtpTxt1.text, FPPOtpTxt2.text, FPPOtpTxt3.text]
        return enteredOTP.compactMap { $0 }.joined()
    }
    // MARK: - clearAllTextFields2: Function to Function to clear all the OTP text fields
    func clearAllTextFields2() {
        FPPOtpTxt1.text = ""
        FPPOtpTxt2.text = ""
        FPPOtpTxt3.text = ""
        FPEOtpTxt1.becomeFirstResponder()
    }
    // MARK: - fillOTPFields2: Function to fill the Phone number OTP
    func fillOTPFields2(with otp: String) {
        let otpArray = Array(otp)
        FPPOtpTxt1.text = String(otpArray[0])
        FPPOtpTxt2.text = String(otpArray[1])
        FPPOtpTxt3.text = String(otpArray[2])
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
