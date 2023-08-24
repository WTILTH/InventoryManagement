//
//  LoginViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Tharun kumar on 19/06/23.
//  Module : Login 
import UIKit
import CoreData
import StoreKit
import CryptoKit
import Security
import CommonCrypto
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | UX and Validation
0.2   | 14-Aug-2023  | Tharun Kumar    | API Integration
Changes:
 
 */
class LoginViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailIdText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signUpPopUp: UIView!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext!
    var iconClick = false
    let imageIcon = UIImageView()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentPopUpView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        //self.navigationItem.setHidesBackButton(true, animated: false)
        signUpPopUp.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 200)
        signUpPopUp.layer.cornerRadius = 40.0
       /* printSavedData()
        setupCoreDataStack()*/
        loginBtn.layer.cornerRadius = 10.0
        signUpBtn.layer.cornerRadius = 10.0
        //emailIdText.backgroundColor = UIColor.clear
       emailIdText.borderStyle = .none
       // passwordText.backgroundColor = UIColor.clear
        passwordText.borderStyle = .none
        emailIdText.layer.cornerRadius = 5
        passwordText.layer.cornerRadius = 5
        
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        let startDateString = "2023-07-12"
        let endDateString = "2023-07-12"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let startDate = dateFormatter.date(from: startDateString),
           let endDate = dateFormatter.date(from: endDateString) {
            let currentDate = Date()
            if currentDate >= startDate && currentDate <= endDate {
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([.day], from: currentDate, to: endDate)
                if let numberOfDays = dateComponents.day {
                    let unit = SKProduct.PeriodUnit.day
                    let formattedPeriod = PeriodFormatter.formatSubscriptionPeriod(unit: unit, numberOfUnits: numberOfDays)
                    if let currentUser = getCurrentUser() {
                        
                        let dueAmount = currentUser.dueAmount
                        showAlert(for: formattedPeriod, dueAmount: dueAmount)
                        
                    } else {
                        showAlert(for: formattedPeriod, dueAmount: nil)
                    }
                }
            } else {
                showAlert(for: "Trial Period Expired", dueAmount: nil)
            }
        }

         imageIcon.image = UIImage(named: "closeEye")
               let contentView = UIView()
                contentView.addSubview(imageIcon)
                
              contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
           
               imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
        passwordText.rightView = contentView
        passwordText.rightViewMode = .always
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                imageIcon.isUserInteractionEnabled = true
                imageIcon.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        signUpPopUp?.addGestureRecognizer(tapGestureRecognizer1)
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
        signUpPopUp?.alpha = 1
        UIView.animate(withDuration: 0.3) {
            popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
        }
    }
    // MARK: - dismissPopUpView: Function to dismiss the pop-up view
    func dismissPopUpView(_ popUpView: UIView) {
        signUpPopUp?.alpha = 0
        UIView.animate(withDuration: 0.3) {
            popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 200)
        }
        currentPopUpView = nil
    }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - showPopUpButtonTapped: Function to handle the "Show Pop-Up" button tap
    @IBAction func showPopUpButtonTapped(_ sender: UIButton) {
       if sender == signUpBtn {
            showPopUpView(signUpPopUp)
        }
    }
    // MARK: - dismissPopUpButtonTapped: Function to handle the "Dismiss Pop-Up" button tap
        @IBAction func dismissPopUpButtonTapped(_ sender: UIButton) {
          if sender.superview == signUpPopUp {
                dismissPopUpView(signUpPopUp)
            }
        }
    func showAlert(for subscriptionPeriod: String?, dueAmount: Double?) {
            let message: String
            if let period = subscriptionPeriod, let amount = dueAmount {
                message = "Your subscription period is \(period). Due amount: \(amount)"
            } else if let period = subscriptionPeriod, let amount = dueAmount {
                message = "\(period). Due amount: \(amount)"
            } else {
                message = "Subscription period got over"
            }
            if subscriptionPeriod != nil {
                let alert = UIAlertController(title: "Subscription Alert", message: message, preferredStyle: .alert)
                let payAction = UIAlertAction(title: "Pay Now", style: .default) { [weak self] (_) in
                    self?.navigateToPaymentViewController()
                }
                alert.addAction(payAction)
                if subscriptionPeriod != nil {
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                }
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Subscription Alert", message: message, preferredStyle: .alert)
                let payAction = UIAlertAction(title: "Pay Now", style: .default) { [weak self] (_) in
                    self?.navigateToPaymentViewController()
                }
                alert.addAction(payAction)
                present(alert, animated: true, completion: nil)
            }
        }
    
        func navigateToPaymentViewController() {
            performSegue(withIdentifier: "paymentSegue", sender: nil)
        }
    
    private func getCurrentUser() -> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.fetchLimit = 1
        do {
            let fetchedUsers = try managedObjectContext?.fetch(fetchRequest) as! [User]
            if let currentUser = fetchedUsers.first {
              
                currentUser.dueAmount = 55.99
                try managedObjectContext?.save()
                return currentUser
            }
        } catch let error as NSError {
            print("Failed to fetch user details: \(error), \(error.userInfo)")
        }
        
        return nil
    }
    // MARK: - imageTapped: Function to toggle password visibility when the eye icon is tapped
    @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if iconClick
        {
            iconClick = false
            tappedImage.image = UIImage(named: "openEye")
            passwordText.isSecureTextEntry = false
        }
        else {
            iconClick = true
            tappedImage.image = UIImage(named: "closeEye")
            passwordText.isSecureTextEntry = true
        }
    }
    // MARK: - forgotPasswordBtnPressed: Function to handle the "Forgot Password" button tap
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        guard let inputText = emailIdText.text, !inputText.isEmpty else {
            showCustomAlertWith(message: "Please enter Email Id or Phone Number", descMsg: "")
            return
        }
        if inputText.contains("@"), isValidEmail(inputText) {
            
            print("Sending login request for email: \(inputText)...")
            forgotPasswordAPI(emailID: inputText, phoneNumber: nil)
            
        } else if inputText.rangeOfCharacter(from: .decimalDigits) != nil {
          
            print("Sending login request for phone number: \(inputText)...")
            forgotPasswordAPI(emailID: nil, phoneNumber: inputText)
            
        } else {
            showCustomAlertWith(message: "Invalid login", descMsg: "Please enter a valid email address or phone number.")
        }
    }
    
    
    func forgotPasswordAPI(emailID: String?,phoneNumber:String?) {
        let apiURL = URL(string: "https://192.168.29.7:8080/emailOrPhoneForgotPassword")!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "emailID": emailID,
            "phoneNumber": phoneNumber
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
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let inputText = emailIdText.text, !inputText.isEmpty else {
            showCustomAlertWith(message: "Please enter Email Id or Phone Number", descMsg: "")
            return
        }
        
        guard let password = passwordText.text, !password.isEmpty else {
            showCustomAlertWith(message: "Please enter Password", descMsg: "")
            return
        }
        
        if inputText.contains("@"), isValidEmail(inputText) {
            
            print("Sending login request for email: \(inputText)...")
            loginAPI(emailID: inputText, phoneNumber: nil, password: password)
            
        } else if inputText.rangeOfCharacter(from: .decimalDigits) != nil {
          
            print("Sending login request for phone number: \(inputText)...")
            loginAPI(emailID: nil, phoneNumber: inputText, password: password)
            
        } else {
            showCustomAlertWith(message: "Invalid login", descMsg: "Please enter a valid email address or phone number.")
        }
    }
    // MARK: - loginUser: Function to send a login request to the API
    func loginAPI(emailID: String?,phoneNumber: String?, password: String) {
        
        let apiURL = URL(string: "https://192.168.29.7:8080/emailOrPhoneLogin")!
        var request = URLRequest(url: apiURL)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                         
        let currentDate = Date()
        let dateFormatter = ISO8601DateFormatter()
        let formattedDate = dateFormatter.string(from: currentDate)
                         
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
            "emailID": emailID,
            "phoneNumber": phoneNumber,
            "password": Password,
            "deviceID": deviceID,
            "currentDate": formattedDate + " " + formattedTime
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
                                    self.performSegue(withIdentifier: "loginToOtp", sender: nil)
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

  // MARK: - UIViewController: Extension is for the Custom alert properties
extension UIViewController {
    static var commonAlertImage: UIImage?
    // MARK: - showCustomAlertWith: Function to show custom alert
    func showCustomAlertWith(okButtonAction: (() -> Void)? = nil, message: String, descMsg: String, actions: [[String: () -> Void]]? = nil) {
        let alertVC = CommonAlertVC(nibName: "CommonAlertVC", bundle: nil)
        alertVC.message = message
        alertVC.arrayAction = actions
        alertVC.descriptionMessage = descMsg
        alertVC.imageItem = UIViewController.commonAlertImage
        if let okButtonAction = okButtonAction {
            alertVC.okButtonAct = okButtonAction
        }
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: true, completion: nil)
    }
}
