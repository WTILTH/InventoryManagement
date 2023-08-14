//
//  OtpViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Tharun kumar on 05/07/23.
//
//  Module : Login 
import UIKit
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | Validations
0.2   | 14-Aug-2023  | Tharun Kumar    | UX
Changes:
 
 */
class OtpViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var generateOtpBtn: UIButton!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var loginUserTimerLabel: UILabel!
    @IBOutlet weak var loginUserResendBtn: UIButton!
    var shouldDisableButtons = false
    var correctOTP: String = ""
    var otpDigits: [String] = []
    var resendAttempts = 0
    var timer: Timer?
    var timeRemaining = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        self.navigationItem.setHidesBackButton(true, animated: false)
        startTimer()
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 1.5
        let shadowOffset = CGSize(width: 0, height: 2)
        let shadowRadius: CGFloat = 4
        
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
    }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - startTimer: Function to start the timer for resending OTP
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        loginUserResendBtn.isEnabled = false
    }
    // MARK: - updateTimer: Function to Update the timer label every second
    @objc func updateTimer() {
        timeRemaining -= 1
        loginUserTimerLabel.text = "\(timeRemaining) seconds remaining"
        if timeRemaining <= 0 {
            timer?.invalidate()
            loginUserResendBtn.isEnabled = true
        }
    }
    // MARK: - resendButtonTapped: Function to Resend the OTP and disable the buttons in login page
    @IBAction func resendButtonTapped(_ sender: UIButton) {
        if resendAttempts < 3 {
            timeRemaining = 10
            startTimer()
            resendAttempts += 1
            loginUserResendBtn.isEnabled = false
            // Set the flag to true when the resend button is tapped
            shouldDisableButtons = true
        } else {
            showCustomAlertWith(okButtonAction: {
                self.performSegue(withIdentifier: "OTPToLoginViewController", sender: nil)
            }, message: "Please contact the admin.", descMsg: "", actions: nil)
        }
    }
    // MARK: - prepare: Function to segue to the login page and disable the buttons
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OTPToLoginViewController" {
            // Pass the shouldDisableButtons flag to loginUserNameViewController
            if let loginViewController = segue.destination as? loginUserNameViewController {
                loginViewController.shouldDisableButtons = shouldDisableButtons
            }
        }
    }
    // MARK: - generateOTPButtonPressed: Function to generate a new OTP and auto fill for phone number OTP
    @IBAction func generateOTPButtonPressed(_ sender: UIButton) {
        generateOTP()
        autofillOTP()
        showCustomAlertWith(message: "Generated OTP: \(correctOTP)", descMsg: "", actions: nil)
        //showAlert(message:  "Generated OTP: \(correctOTP)")
        showOTPNotification()
    }
    // MARK: - LoginButtonPressed: Function to Continue button action to verify OTPs and proceed to the next screen
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        let enteredOTP = getEnteredOTP()
        guard !enteredOTP.isEmpty && enteredOTP == correctOTP else {
            showCustomAlertWith(message: "Incorrect OTP. Please try again.", descMsg: "", actions: nil)
           // showAlert(message: "Incorrect OTP. Please try again.")
            clearAllTextFields()
            return
        }
        performSegue(withIdentifier: "OtpToMain", sender: nil)
    }
    // MARK: - generateOTP: Function to generate a new OTP
    func generateOTP() {
        let otpDigits = (0..<4).map { _ in String(Int.random(in: 0...9)) }
        correctOTP = otpDigits.joined()
    }
    // MARK: - textField: Function to limit the input length of OTP text fields to one digit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 1
    }
    // MARK: - textFieldDidChange: Function to handle changes in OTP text fields
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
    // MARK: - showOTPNotification: Function to show a notification with the generated OTP
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
    // MARK: - firstTextFieldTapped: Function for thr autofill
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
    // MARK: - autofillOTP: Function to autofill OTP text fields with the correct OTP
    func autofillOTP() {
        guard correctOTP.count == 4 else {
            return
        }
        otpTextField1.text = String(correctOTP[correctOTP.startIndex])
        otpTextField2.text = String(correctOTP[correctOTP.index(after: correctOTP.startIndex)])
        otpTextField3.text = String(correctOTP[correctOTP.index(correctOTP.startIndex, offsetBy: 2)])
        otpTextField4.text = String(correctOTP[correctOTP.index(correctOTP.startIndex, offsetBy: 3)])
    }
    // MARK: - getEnteredOTP: Function to get the entered OTP from the text fields
    func getEnteredOTP() -> String {
        let enteredOTP = [otpTextField1.text, otpTextField2.text, otpTextField3.text, otpTextField4.text]
        return enteredOTP.compactMap { $0 }.joined()
    }
    // MARK: - clearAllTextFields: Function to clear all OTP text fields
    func clearAllTextFields() {
        otpTextField1.text = ""
        otpTextField2.text = ""
        otpTextField3.text = ""
        otpTextField4.text = ""
        
        otpTextField1.becomeFirstResponder()
    }
    // MARK: - fillOTPFields: Function to clear all OTP text fields
    func fillOTPFields(with otp: String) {
        let otpArray = Array(otp)
        
        otpTextField1.text = String(otpArray[0])
        otpTextField2.text = String(otpArray[1])
        otpTextField3.text = String(otpArray[2])
        otpTextField4.text = String(otpArray[3])
    }
    
}
