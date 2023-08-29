//
//  ForgotPasswordViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Varun kumar on 10/07/23.
//
//  Module : Login
import UIKit
import CoreData
import CryptoKit
import CommonCrypto
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | Logics
0.2   | 14-Aug-2023  | Tharun Kumar    | UX and Validation
Changes:
 
 */
class ForgetPasswordViewController: UIViewController,UITextFieldDelegate, URLSessionDelegate {
    
    @IBOutlet weak var veriftBtn: UIButton!
    @IBOutlet weak var FPEmailIDTxt: UITextField!
    @IBOutlet weak var FPPhoneNumberTxt: UITextField!
    
    var emailId: String?
    var phoneNumber: String?
    var responseData: [String: Any]?
    //var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(responseData)
        // FPEmailIDTxt.backgroundColor = UIColor.clear
        FPEmailIDTxt.borderStyle = .none
        //FPPhoneNumberTxt.backgroundColor = UIColor.clear
        FPPhoneNumberTxt.borderStyle = .none
        FPEmailIDTxt.layer.cornerRadius = 5
        FPPhoneNumberTxt.layer.cornerRadius = 5
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        veriftBtn.layer.cornerRadius = 10.0
        
        /* if let responseData = responseData, let body = responseData["body"] as? [String: Any] {
         emailID = body["emailID"] as? String ?? ""
         phoneNumber = body["phoneNumber"] as? String ?? ""
         FPEmailIDTxt.text = emailID
         FPPhoneNumberTxt.text = phoneNumber
         
         }*/
        
        if let responseData = responseData, let body = responseData["body"] as? [String: Any] {
            emailId = body["emailId"] as? String ?? ""
            phoneNumber = body["phoneNumber"] as? String ?? ""
            
            FPEmailIDTxt.attributedPlaceholder = NSAttributedString(
                string: emailId!,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
            
            FPPhoneNumberTxt.attributedPlaceholder = NSAttributedString(
                string: phoneNumber!,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
            
            FPEmailIDTxt.placeholder = emailId
            FPPhoneNumberTxt.placeholder = phoneNumber
            
            
            if let defaultEmail = FPEmailIDTxt.placeholder {
                let maskedDefaultEmail = maskEmail(email: defaultEmail)
                FPEmailIDTxt.placeholder = maskedDefaultEmail
            }
            if let defaultPhoneNumber = FPPhoneNumberTxt.placeholder {
                let maskedDefaultPhoneNumber = maskPhoneNumber(phoneNumber: defaultPhoneNumber)
                FPPhoneNumberTxt.placeholder = maskedDefaultPhoneNumber
            }
            
        }
    }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    // MARK: - verifyBtnPressed: Function to handle the "verifyBtnPressed" button tap
    @IBAction func verifyBtnPressed(_ sender: Any) {
        guard let enteredEmailID = FPEmailIDTxt.text, !enteredEmailID.isEmpty else {
            showCustomAlertWith(message: "Please enter your Email ID.", descMsg: "")
            return
        }
        if !isValidEmail(enteredEmailID) {
            showCustomAlertWith(message: "Invalid Email ID", descMsg: "")
            return
        }
        guard let enteredPhoneNumber = FPPhoneNumberTxt.text, !enteredPhoneNumber.isEmpty else {
            showCustomAlertWith(message: "Please enter your phone number.", descMsg: "")
            return
        }
        
        if let responseDataEmail = emailId, let responseDataPhoneNumber = phoneNumber {
            if enteredEmailID == responseDataEmail && enteredPhoneNumber == responseDataPhoneNumber {
                handleOTPVerificationAndNavigate()
            } else {
                if enteredEmailID != responseDataEmail {
                    showCustomAlertWith(message: "Incorrect Email ID", descMsg: "The entered Email ID does not match.")
                } else {
                    showCustomAlertWith(message: "Incorrect Phone Number", descMsg: "The entered phone number does not match.")
                }
            }
        } else {
            showCustomAlertWith(message: "Invalid user", descMsg: "")
        }
    }

// MARK: - handleOTPVerificationAndNavigate: Function to Transfer the data passed from ForgetPasswordViewController to the ForgotPasswordOtpViewController
 func handleOTPVerificationAndNavigate() {
DispatchQueue.main.async {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let ForgotPasswordOtpViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordOtpViewControllers") as! ForgotPasswordOtpViewController
    ForgotPasswordOtpViewController.responseData = self.responseData
    self.navigationController?.pushViewController(ForgotPasswordOtpViewController, animated: true)
}
}
// MARK: - createMaskedString: Function to Mask the string
func createMaskedString(from originalString: String) -> String {
    let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let maskCharacter: Character = "_"
    
    var maskedString = ""
    for char in originalString {
        if allowedCharacterSet.contains(char.unicodeScalars.first!) {
            maskedString.append(maskCharacter)
        } else {
            maskedString.append(char)
        }
    }
    return maskedString
}
// MARK: - isValidEmail: Function to validate an email address using regular expressions
func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}
// MARK: - isValidPhoneNumber: Function to validate a phone number using regular expressions
func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
    let phoneRegex = "[0-9]{10}"
    let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return phonePredicate.evaluate(with: phoneNumber)
}
// MARK: - maskEmail: Function to mask the email
func maskEmail(email: String) -> String {
    let components = email.components(separatedBy: "@")
    guard components.count == 2 else {
        return email
    }
    
    let username = components[0]
    let domainWithExtension = components[1]
    
    var maskedUsername = username
    if username.count >= 4 {
        let startIndex = username.startIndex
        let endIndex = username.index(username.startIndex, offsetBy: 4)
        let rangeToMask = startIndex..<endIndex
        maskedUsername = username.replacingCharacters(in: rangeToMask, with: String(repeating: "*", count: 4))
    } else {
        maskedUsername = String(repeating: "*", count: username.count)
    }
    
    let maskedEmail = maskedUsername + "@" + domainWithExtension
    return maskedEmail
}

// MARK: - maskPhoneNumber: Function to mask the phone number
func maskPhoneNumber(phoneNumber: String) -> String {
    guard phoneNumber.count >= 10 else {
        return phoneNumber
    }
    
    let startIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
    let endIndex = phoneNumber.index(phoneNumber.endIndex, offsetBy: -4)
    let middleDigits = phoneNumber[startIndex..<endIndex]
    
    let maskedPhoneNumber = phoneNumber.prefix(3) + String(repeating: "*", count: middleDigits.count) + phoneNumber.suffix(3)
    
    return String(maskedPhoneNumber)
}

}

