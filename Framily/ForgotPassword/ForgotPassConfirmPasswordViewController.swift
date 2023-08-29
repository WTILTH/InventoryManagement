//
//  ForgotPasswordConfirmPasswordViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Varun kumar on 05/07/23.
//
//  Module : Login
import UIKit
import CoreData
import CryptoKit
import CommonCrypto
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | UX and Validation
0.2   | 14-Aug-2023  | Tharun Kumar    | Logics
Changes:
 
 */
class ForgotPasswordConfirmPassViewController: UIViewController ,UITextFieldDelegate, URLSessionDelegate{
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var FPConfirmPasswordTxt: UITextField!
    @IBOutlet weak var FPCreatePasswordTxt: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var forgotPasswordStrengthProgressView: UIProgressView!
    
    var responseData: [String: Any]?
    var isPasswordValid: Bool = false
    var user: User?
    var iconClick = false
    var modifiedDate: String = ""
    var emailId: String = ""
   // let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEyeIcon(for: FPConfirmPasswordTxt)
        setupEyeIcon(for: FPCreatePasswordTxt)
        FPCreatePasswordTxt.addTarget(self, action: #selector(passwordEditingChanged(_:)), for: .editingChanged)
        FPCreatePasswordTxt.delegate = self
        self.forgotPasswordStrengthProgressView.setProgress(0, animated: true)
        self.errorLabel.textColor = UIColor.red
        self.errorLabel.text = ""
        self.errorLabel.isHidden = true
        
        print(responseData)
        if let responseData = responseData, let body = responseData["body"] as? [String: Any] {
            emailId = body["emailId"] as? String ?? ""
        }
        FPConfirmPasswordTxt.delegate = self
       // FPCreatePasswordTxt.backgroundColor = UIColor.clear
        FPCreatePasswordTxt.borderStyle = .none
       // FPConfirmPasswordTxt.backgroundColor = UIColor.clear
        FPConfirmPasswordTxt.borderStyle = .none
        FPCreatePasswordTxt.layer.cornerRadius = 5
        FPConfirmPasswordTxt.layer.cornerRadius = 5
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        confirmBtn.layer.cornerRadius=10.0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5

    }
    // MARK: - imageTapped: Function to toggle password visibility when the eye icon is tapped
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
            if tappedImage.tag == 0 {
                tappedImage.tag = 1
                tappedImage.image = UIImage(named: "openEye")
                FPConfirmPasswordTxt.isSecureTextEntry = false
            } else {
                tappedImage.tag = 0
                tappedImage.image = UIImage(named: "closeEye")
                FPConfirmPasswordTxt.isSecureTextEntry = true
            }
    }
    //MARK: - setupEyeIcon: Function to set up the eye icon for a text field
    func setupEyeIcon(for textField: UITextField) {
        let imageIcon = UIImageView()
        imageIcon.tag = 0
        imageIcon.image = UIImage(named: "closeEye")

        let contentView = UIView()
        contentView.addSubview(imageIcon)
        contentView.frame = CGRect(x: 0, y: 0, width: imageIcon.image!.size.width, height: imageIcon.image!.size.width)

        imageIcon.frame = CGRect(x: -10, y: 0, width: imageIcon.image!.size.width, height: imageIcon.image!.size.width)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)

        textField.rightView = contentView
        textField.rightViewMode = .always
    }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - passwordInfoBtn: Function for the showing an alert for the password credentials
    @IBAction func passwordInfoBtn(_ sender: Any) {
        let alertController = showCustomAlertWith(message: "Password credentials", descMsg: "Min. 8 to 14 characters long, A combination of uppercase letters, lowercase letters, numbers, and symbols.")
    }
    // MARK: - ConfirmButtonTapped: Function to handle the "Login" button tap
    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        
        guard let newPassword = FPCreatePasswordTxt.text, !newPassword.isEmpty else {
            showCustomAlertWith(message: "Please enter a new password", descMsg: "")
            return
        }
        guard let confirmPassword = FPConfirmPasswordTxt.text, !confirmPassword.isEmpty else {
            showCustomAlertWith(message: "Please enter a confirm Password", descMsg: "")
            return
        }
        
        guard validatePasswords() else {
            showCustomAlertWith(message: "Password must meet validation criteria", descMsg: "")
            return
        }
        
        guard newPassword == confirmPassword else {
            errorLabel.isHidden = false
            errorLabel.text = "Passwords do not match"
            return
        }
       

        print("Sending signup request to API...")
        passwordAPI(emailId: emailId, confirmPassword: confirmPassword, modifiedDate: modifiedDate)
       // performSegue(withIdentifier: "FPtoMAIN", sender: nil)
         
        
    }
    // MARK: - passwordAPI: Function to send a sign-up request to the API
    func passwordAPI(emailId: String, confirmPassword: String, modifiedDate: String) {
        let apiURL = URL(string: "https://192.168.29.7:8080/passwordUpdate")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
       
        let currentDate = Date()
        let dateFormatter = ISO8601DateFormatter()
        let modifiedDate = dateFormatter.string(from: currentDate)
        let currentTime = Calendar.current.dateComponents([.hour, .minute, .second], from: currentDate)
        let formattedTime = String(format: "%02d:%02d:%02d", currentTime.hour!, currentTime.minute!, currentTime.second!)
        
        let aesKeyHex = "7b4f66379aed7e506ad4c75dc0a78575"
        let ivHex = "03373b15eb9a98ff0279c98b0b5635e5"
        
        guard let aesKeyData = Data(hex: aesKeyHex),
              let ivData = Data(hex: ivHex) else {
            print("Invalid AES key or IV format")
            return
        }
        
        
        let password: String
        if let encryptedPasswordData = confirmPassword.data(using: .utf8),
           let encryptedPassword = encryptAES_CBC(data: encryptedPasswordData, key: aesKeyData, iv: ivData) {
            password = encryptedPassword.base64EncodedString()
        } else {
            print("Password encryption failed")
            return
        }
        
        let parameters: [String: Any] = [
            "emailId": emailId,
            "password": password,
            //"modifiedDate": modifiedDate + " " + formattedTime
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
         
        } catch {
            print("Error creating request body: \(error)")
            return
        }
    
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
                         
                            if let responseDict = jsonObject as? [String: Any],
                               let success = responseDict["success"] as? Bool, success {
                             
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "FPtoMAIN", sender: nil)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Server Error", descMsg: "There was a problem with the server. Please try again later.")
                                }
                            }
                            
                        } catch {
                            print("Error parsing response data: \(error)")
                        }
                    }
                } else if (400...499).contains(statusCode) {
                    if let responseData = data {
                        do {
                            
                            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                            print("Response: \(jsonObject)")
                            
                            if let responseDict = jsonObject as? [String: Any], let body = responseDict["body"] as? String {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: body, descMsg: "")
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Client Error", descMsg: "An error occurred while processing the response.")
                                }
                            }
                            
                        } catch {
                            print("Error parsing response data: \(error)")
                            DispatchQueue.main.async {
                                self.showCustomAlertWith(message: "Client Error", descMsg: "An error occurred while processing the response.")
                            }
                        }
                    }
                } else {
                    print("Invalid HTTP response: \(httpResponse)")
                    DispatchQueue.main.async {
                        self.showCustomAlertWith(message: "Server Error", descMsg: "An unknown error occurred.")
                    }
                }
            }
        }
        
        task.resume()
        print("Sending signup request to API...")
    }
    // MARK: - validatePasswords: Function to validate the password
    func validatePasswords() -> Bool {
        guard let newPassword = FPCreatePasswordTxt.text,
              let confirmPassword = FPConfirmPasswordTxt.text else {
            return false
        }
        if newPassword.count < 8 || newPassword.count > 14 {
            showCustomAlertWith(message: "Password length should be between 8 and 14 characters, Should have Upper Case and Lower Case and Special character", descMsg: "")
            return false
        }
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,14}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !passwordPredicate.evaluate(with: newPassword) {
            showCustomAlertWith(message: "Password requirements are not satisfied", descMsg: "")
            return false
        }
        return true
    }
    // MARK: - passwordEditingChanged: Function to show the strenth meter based on the password typed in the the text field
    @objc func passwordEditingChanged(_ textField: UITextField) {
        if textField == FPCreatePasswordTxt {
            if let password = textField.text, !password.isEmpty {
                self.errorLabel.isHidden = false
                self.errorLabel.alpha = 0
                
                let validationId = PasswordStrengthManager.checkValidationWithUniqueCharacter(pass: password, rules: PasswordRules.passwordRule, minLength: PasswordRules.minPasswordLength, maxLength: PasswordRules.maxPasswordLength)
                UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                    self?.errorLabel.alpha = CGFloat(validationId.alpha)
                    self?.errorLabel.text = validationId.text
                })
                
                let progressInfo = PasswordStrengthManager.setProgressView(strength: validationId.strength)
                self.isPasswordValid = progressInfo.shouldValid
                self.forgotPasswordStrengthProgressView.setProgress(progressInfo.percentage, animated: true)
                self.forgotPasswordStrengthProgressView.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
            } else {
                self.errorLabel.isHidden = true
                self.forgotPasswordStrengthProgressView.setProgress(0, animated: false)
            }
        }
    }

    // MARK: - urlSession: Function for SSL Pinning
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
           if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)

                if(errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let cert1 = NSData(bytes: data, length: size)
                        let file_der = Bundle.main.path(forResource: "aarthy", ofType: "cer")

                        if let file = file_der {
                            if let cert2 = NSData(contentsOfFile: file) {
                                if cert1.isEqual(to: cert2 as Data) {
                                    print("SSL Pinning Successful")
                                    
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    
    func encryptAES_CBC(data: Data, key: Data, iv: Data) -> Data? {
        let bufferSize = data.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)

        var numBytesEncrypted: size_t = 0

        let cryptStatus = key.withUnsafeBytes { keyBytes in
            iv.withUnsafeBytes { ivBytes in
                data.withUnsafeBytes { dataBytes in
                    buffer.withUnsafeMutableBytes { bufferBytes in
                        CCCrypt(
                            UInt32(kCCEncrypt),
                            UInt32(kCCAlgorithmAES),
                            UInt32(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, key.count,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress, data.count,
                            bufferBytes.baseAddress, bufferSize,
                            &numBytesEncrypted
                        )
                    }
                }
            }
        }

        if cryptStatus == kCCSuccess {
            buffer.count = numBytesEncrypted
            return buffer
        }

        return nil
    }

    func decryptAES_CBC(data: Data, key: Data, iv: Data) -> Data? {
        let bufferSize = data.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)

        var numBytesDecrypted: size_t = 0

        let cryptStatus = key.withUnsafeBytes { keyBytes in
            iv.withUnsafeBytes { ivBytes in
                data.withUnsafeBytes { dataBytes in
                    buffer.withUnsafeMutableBytes { bufferBytes in
                        CCCrypt(
                            UInt32(kCCDecrypt),
                            UInt32(kCCAlgorithmAES),
                            UInt32(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, key.count,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress, data.count,
                            bufferBytes.baseAddress, bufferSize,
                            &numBytesDecrypted
                        )
                    }
                }
            }
        }

        if cryptStatus == kCCSuccess {
            buffer.count = numBytesDecrypted
            return buffer
        }

        return nil
    }

}
