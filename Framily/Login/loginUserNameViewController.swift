//
//  signUpUser.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Varun kumar on 21/07/23.
//  Module : Login 
import UIKit
import CoreData
import CryptoKit
import Security
import CommonCrypto
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | UX
0.2   | 14-Aug-2023  | Tharun Kumar    | API Integration
Changes:
 
 */
class loginUserNameViewController: UIViewController, URLSessionDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var signUpUserBtn: UIButton!
    @IBOutlet weak var groupNameTxt: UITextField!
    @IBOutlet weak var signUpUserPopUp: UIView!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var groupNameImage: UIImageView!
    @IBOutlet weak var loginWithEmailPhoneBtn: UIButton!
    
    //var transparentOverlay: UIView?
    var shouldDisableButtons = false
    var managedObjectContext: NSManagedObjectContext!
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var iconClick = false
    let imageIcon = UIImageView()
    var currentPopUpView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //printSavedData()
       // navigationItem.title = ""
       // groupNameImage.isUserInteractionEnabled = false
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        signUpUserPopUp.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 200)
        signUpUserPopUp.layer.cornerRadius = 40.0
        groupNameTxt.layer.cornerRadius = 5
        userNameTxt.layer.cornerRadius = 5
        passwordTxt.layer.cornerRadius = 5
        imageIcon.image = UIImage(named: "closeEye")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "openEye")!.size.width, height: UIImage(named: "openEye")!.size.width)
        
        imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
        passwordTxt.rightView = contentView
        passwordTxt.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
        // transparentOverlay = UIView(frame: view.bounds)
        // transparentOverlay?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // transparentOverlay?.alpha = 0 // Initially transparent
        // view.addSubview(transparentOverlay!)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        signUpUserPopUp?.addGestureRecognizer(tapGestureRecognizer1)
        if shouldDisableButtons {
            loginBtn.isEnabled = false
            signUpUserBtn.isEnabled = false
            forgotPasswordBtn.isEnabled = false
            loginWithEmailPhoneBtn.isEnabled = false
            Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] timer in
                self?.loginBtn.isEnabled = true
                self?.signUpUserBtn.isEnabled = true
                self?.forgotPasswordBtn.isEnabled = true
                self?.loginWithEmailPhoneBtn.isEnabled = true
            }
        }
    }
    // MARK: - handleTap: This function is to handle the pop up view
            @objc func handleTap() {
                view.endEditing(true)
                if let currentPopUpView = currentPopUpView {
                    dismissPopUpView(currentPopUpView)
                }
            }
    //MARK: - showPopUpView: Function to show the pop-up view
    func showPopUpView(_ popUpView: UIView) {
        if let currentPopUpView = currentPopUpView {
            dismissPopUpView(currentPopUpView)
        }
        currentPopUpView = popUpView
        signUpUserPopUp?.alpha = 1
        
        UIView.animate(withDuration: 0.3) {
            popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
        }
    }
    // MARK: - dismissPopUpView: Function to dismiss the pop-up view
            func dismissPopUpView(_ popUpView: UIView) {
                signUpUserPopUp?.alpha = 0

                UIView.animate(withDuration: 0.3) {
                    popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 200)
                }
                currentPopUpView = nil
            }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - imageTapped: Function to toggle password visibility when the eye icon is tapped
    @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer){
   let tappedImage = tapGestureRecognizer.view as! UIImageView
   if iconClick
   {
       iconClick = false
       tappedImage.image = UIImage(named: "openEye")
       passwordTxt.isSecureTextEntry = false
   }
   else {
       iconClick = true
       tappedImage.image = UIImage(named: "closeEye")
       passwordTxt.isSecureTextEntry = true
   }
}
    // MARK: - showPopUpButtonTapped: Function to handle the "Show Pop-Up" button tap
    @IBAction func showPopUpButtonTapped(_ sender: UIButton) {
       if sender == signUpUserBtn {
            showPopUpView(signUpUserPopUp)
        }
    }
    // MARK: - dismissPopUpButtonTapped: Function to handle the "Dismiss Pop-Up" button tap
        @IBAction func dismissPopUpButtonTapped(_ sender: UIButton) {
          if sender.superview == signUpUserPopUp {
                dismissPopUpView(signUpUserPopUp)
            }
        }
    // MARK: - forgotPasswordBtnPressed: Function to handle the "Forgot Password" button tap
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        guard let groupName = groupNameTxt.text, !groupName.isEmpty
        else {
            showCustomAlertWith(message: "Please enter your groupName", descMsg: "")

            return
       }
        guard let userName = userNameTxt.text, !userName.isEmpty
        else {
            showCustomAlertWith(message: "Please enter your user name", descMsg: "")
            return
        }
        forgotPasswordUserAPI(groupName: groupName, userName: userName)
    }
    // MARK: - loginUser: Function to send a forgot Password request to the API
    func forgotPasswordUserAPI(groupName: String, userName: String) {
        let apiURL = URL(string: "https://192.168.29.7:8080/userNameForgotPassword")!
        
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let currentDate = Date()
        let dateFormatter = ISO8601DateFormatter()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let currentTime = Calendar.current.dateComponents([.hour, .minute, .second], from: currentDate)
        let formattedTime = String(format: "%02d:%02d:%02d", currentTime.hour!, currentTime.minute!, currentTime.second!)
        
        let parameters: [String: Any] = [
            "groupName": groupName,
            "userName": userName,
            "currentDate": formattedDate + " " + formattedTime,
            "modifiedDate": formattedDate
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
                        
                        if let responseDict = jsonObject as? [String: Any] {
                            if let success = responseDict["success"] as? Bool, success {
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let otpViewController = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordViewControllers") as! ForgetPasswordViewController
                                    otpViewController.responseData = responseDict
                                    self.navigationController?.pushViewController(otpViewController, animated: true)
                                }
                            } else if let errorMessage = responseDict["errorMessage"] as? String {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Server Error", descMsg: errorMessage)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Server Error", descMsg: "There was a problem with the server. Please try again later.")
                                }
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
                                           self.showCustomAlertWith(message: "An error occurred while processing the response.", descMsg: "")
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
    // MARK: - loginInButtonPressed: Function to handle the "Login" button tap
    @IBAction func loginInButtonPressed(_ sender: Any) {
        guard let groupName = groupNameTxt.text, !groupName.isEmpty else {
            showCustomAlertWith(message: "Please enter groupName", descMsg: "")
            return
        }
        
        guard let userName = userNameTxt.text, !userName.isEmpty else {
            showCustomAlertWith(message: "Please enter userName", descMsg: "")
            return
        }
        
        guard let password = passwordTxt.text, !password.isEmpty else {
            showCustomAlertWith(message: "Please enter password", descMsg: "")
            return
        }
        
        print("Sending signup request to API...")
        loginUser(groupName: groupName, userName: userName, password: password)
    }
    // MARK: - verifyPassword: Function to verify if the entered password matches
    private func verifyPassword(_ password: String, storedHash: String?) -> Bool {
        return password == storedHash
    }
    // MARK: - loginUser: Function to send a login request to the API
    func loginUser(groupName: String, userName: String, password: String) {
        
        let apiURL = URL(string: "https://192.168.29.7:8080/usernameLogin")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let currentDate = Date()
        let dateFormatter = ISO8601DateFormatter()
        let modifiedDate = dateFormatter.string(from: currentDate)
        let currentTime = Calendar.current.dateComponents([.hour, .minute, .second], from: currentDate)
        let formattedTime = String(format: "%02d:%02d:%02d", currentTime.hour!, currentTime.minute!, currentTime.second!)
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        
        let aesKeyHex = "7b4f66379aed7e506ad4c75dc0a78575"
        let ivHex = "03373b15eb9a98ff0279c98b0b5635e5"
        
        guard let aesKeyData = Data(hex: aesKeyHex),
              let ivData = Data(hex: ivHex) else {
            print("Invalid AES key or IV format")
            return
        }
        
        
        let Password: String
        if let encryptedPasswordData = password.data(using: .utf8),
           let encryptedPassword = encryptAES_CBC(data: encryptedPasswordData, key: aesKeyData, iv: ivData) {
            Password = encryptedPassword.base64EncodedString()
        } else {
            print("Password encryption failed")
            return
        }
        
        let parameters: [String: Any] = [
            "groupName": groupName,
            "userName": userName,
            "password": Password,
            "deviceID": deviceID
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
                                    self.performSegue(withIdentifier: "signinToOtp", sender: nil)
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
    // MARK: - prepare: Disable all buttons after the segue from EmailOTPViewController , Where the resend button is clicked more than three times
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewController" {
            loginBtn.isEnabled = false
            signUpUserBtn.isEnabled = false
            forgotPasswordBtn.isEnabled = false
            loginWithEmailPhoneBtn.isEnabled = false
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
extension Data {
    
    init?(hex string: String) {
        var hexSanitized = string.replacingOccurrences(of: " ", with: "")
        hexSanitized = hexSanitized.replacingOccurrences(of: "<", with: "")
        hexSanitized = hexSanitized.replacingOccurrences(of: ">", with: "")
        
        var data = Data(capacity: hexSanitized.count / 2)
        
        var index = hexSanitized.startIndex
        while index < hexSanitized.endIndex {
            let byteString = hexSanitized[index..<hexSanitized.index(index, offsetBy: 2)]
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
            index = hexSanitized.index(index, offsetBy: 2)
        }
        
        self = data
    }
}
/*   override func viewDidLoad() {
        super.viewDidLoad()

        
        PopUpView.layer.cornerRadius = 20.0
           self.navigationItem.setHidesBackButton(true, animated: false)

          PopUpView.bounds = CGRect(x: 0, y: 0, width: 338, height: 397)
           
    }
    @IBAction func iBtn(_ sender: Any) {
        
        animateIn(desiredView: PopUpView)
        
    }
       
    @IBOutlet var PopUpView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func animateIn(desiredView: UIView) {
        
        let backgroundView = self.view!
        
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
        
    }
    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
            
            
        })
    }
    
}*/
