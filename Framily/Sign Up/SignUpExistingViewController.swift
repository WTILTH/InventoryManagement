//
//  SignUpExistingViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/1
//  Created by Varun kumar on 25/07/23.
//
//  Module : Sign Up
import UIKit
import CoreData
import DialCountries
import CryptoKit
import CommonCrypto
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | Validations
0.2   | 14-Aug-2-23  | Tharun Kumar    | UX
Changes:
 
 */
class SignUpExistingViewController: UIViewController, URLSessionDelegate  {
    
    var countryCodes = [[String]]()
    @IBOutlet weak var existingGroupNameTxt: UITextField!
    @IBOutlet weak var existingCountryCodeTxt: UITextField!
    @IBOutlet weak var existingPhoneNumberTxt: UITextField!
    @IBOutlet weak var existingEmailIDTxt: UITextField!
    @IBOutlet weak var existingGroupNameStatusLabel: UILabel!
    @IBOutlet weak var existingCountryCodeTxtStatusLabel: UILabel!
    @IBOutlet weak var existingEmailIDStatusLabel: UILabel!
    @IBOutlet weak var existingNextBtn: UIButton!

  //  let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDialCountriesController))
        existingCountryCodeTxt.addGestureRecognizer(tapGesture)
        existingCountryCodeTxt.isUserInteractionEnabled = true
        existingCountryCodeTxt.text = "+91"
        //self.navigationController?.navigationBar.topItem?.title = "Sign Up"
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        existingGroupNameTxt.layer.cornerRadius = 5
        existingCountryCodeTxt.layer.cornerRadius = 5
        existingPhoneNumberTxt.layer.cornerRadius = 5
        existingEmailIDTxt.layer.cornerRadius = 5
        existingCountryCodeTxt.isUserInteractionEnabled = true
       // existingGroupNameTxt.backgroundColor = UIColor.clear
       existingGroupNameTxt.borderStyle = .none
       // existingCountryCodeTxt.backgroundColor = UIColor.clear
       existingCountryCodeTxt.borderStyle = .none
      //  existingPhoneNumberTxt.backgroundColor = UIColor.clear
       existingPhoneNumberTxt.borderStyle = .none
      //  existingEmailIDTxt.backgroundColor = UIColor.clear
       existingEmailIDTxt.borderStyle = .none
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: existingCountryCodeTxt.frame.height))
        existingCountryCodeTxt.leftView = paddingView
        existingCountryCodeTxt.leftViewMode = .always
    }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - showDialCountriesController: Function to handle tap on the country code text field
    @objc func showDialCountriesController() {
        let cv = DialCountriesController(locale: Locale(identifier: "en"))
        cv.delegate = self
        cv.show(vc: self)
    }
    // MARK: - signUpButtonTapped: Function to handle the "Sign Up" button tap
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let groupName = existingGroupNameTxt.text, !groupName.isEmpty else {
            existingGroupNameStatusLabel.text = "Please enter Group name"
            existingCountryCodeTxtStatusLabel.text = ""
            existingEmailIDStatusLabel.text = ""
            return
        }
        
        guard let emailID = existingEmailIDTxt.text, !emailID.isEmpty else {
            existingGroupNameStatusLabel.text = ""
            existingCountryCodeTxtStatusLabel.text = ""
            existingEmailIDStatusLabel.text = "Please enter email ID"
            return
        }
        
        if !isValidEmail(emailID) {
            existingEmailIDStatusLabel.text = "Invalid email"
            return
        }
        guard let countryCode = existingCountryCodeTxt.text, !countryCode.isEmpty else {
            existingGroupNameStatusLabel.text = ""
            existingCountryCodeTxtStatusLabel.text = "Please enter Country Code"
            existingEmailIDStatusLabel.text = ""
            return
        }
        guard let phoneNumber = existingPhoneNumberTxt.text, !phoneNumber.isEmpty else {
            existingGroupNameStatusLabel.text = ""
            existingCountryCodeTxtStatusLabel.text = "Please enter phone number"
            existingEmailIDStatusLabel.text = ""
            return
        }
        resetStatusLabels()
        if !isValidPhoneNumber(phoneNumber) {
            existingCountryCodeTxtStatusLabel.text = "Invalid phone number"
            return
        }
 
        print("Sending signup request to API...")
        signUpExistingUserAPI(groupName: groupName, countryCode: countryCode, phoneNumber: phoneNumber, emailID: emailID)
        
    }
    // MARK: - signUpExistingUserAPI: Function to send a sign-up request to the API
    func signUpExistingUserAPI(groupName: String, countryCode: String, phoneNumber: String, emailID: String) {
        let apiURL = URL(string: "https://192.168.29.7:8080/existCompanyRegister")!
    
    var request = URLRequest(url: apiURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let currentDate = Date()
        let dateFormatter = ISO8601DateFormatter()
        let formattedDate = dateFormatter.string(from: currentDate)
    
    let parameters: [String: Any] = [
        "groupName": groupName,
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "emailID": emailID
        
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
                                        let otpViewController = storyboard.instantiateViewController(withIdentifier: "EmailOTPViewControllers") as! EmailOTPViewController
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
                              
                                    
                                    let jsonObject = try JSONSerialization.jsonObject(with: responseData/*decryptedData*/, options: [])
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
    // MARK: - prepare: Function to prepare for segue to EmailOTPViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpToEmailOTP" {
            if let otpVC = segue.destination as? EmailOTPViewController {
                let newUser = sender as? User
                otpVC.user = newUser
            }
        }

    }
    // MARK: - resetStatusLabels: Function to reset the status labels for input validation
    func resetStatusLabels() {
        existingGroupNameStatusLabel.text = ""
        existingCountryCodeTxtStatusLabel.text = ""
        existingEmailIDStatusLabel.text = ""
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
    
  }
    
/*extension SignUpExistingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UIPickerView Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let code = countryCodes[row]
        return "\(code[0]) +\(code[1])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let code = countryCodes[row]
        existingCountryCodeTxt.text = "+\(code[1])"
    }
}*/
    // MARK: - This class is for third party country code selector: DialCountries
extension SignUpExistingViewController: DialCountriesControllerDelegate {
    func didSelected(with country: Country) {
        existingCountryCodeTxt.text = country.dialCode
    }
}
