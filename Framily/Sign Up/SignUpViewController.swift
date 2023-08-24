//
//  SignUpViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/1
//  Created by Tharun kumar on 04/07/23.
//
//  Module : Sign Up
import UIKit
import Foundation
import CoreData
import DialCountries
import CryptoKit
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | UX
0.2   | 14-Aug-2-23  | Tharun Kumar    | Validations
Changes:
 
 */
class SignUpViewController: UIViewController, URLSessionDelegate  {
    
    var countryCodes = [[String]]()
    @IBOutlet weak var phoneNoTxt: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var countryCodeTxtField: UITextField!
    @IBOutlet weak var companyNameTxt: UITextField!
    @IBOutlet weak var emailIDTxt: UITextField!
    @IBOutlet weak var companyNameStatusLabel: UILabel!
    @IBOutlet weak var phoneNumberStatusLabel: UILabel!
    @IBOutlet weak var emailIdStatusLabel: UILabel!
    
   // let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: countryCodeTxtField.frame.height))
                countryCodeTxtField.leftView = paddingView
                countryCodeTxtField.leftViewMode = .always
        /*let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: phoneNoTxt.frame.height))
                phoneNoTxt.leftView = paddingView
                phoneNoTxt.leftViewMode = .always
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: countryCodeTxtField.frame.height))
               // countryCodeTxtField.leftView = paddingView
                countryCodeTxtField.leftViewMode = .always
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailIDTxt.frame.height))
              //  emailIDTxt.leftView = paddingView
                emailIDTxt.leftViewMode = .always*/
        countryCodeTxtField.text = "+91"
        //self.navigationController?.navigationBar.topItem?.title = "Sign Up"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDialCountriesController))
        countryCodeTxtField.addGestureRecognizer(tapGesture)
        countryCodeTxtField.isUserInteractionEnabled = true
       // signUpView.layer.cornerRadius = 20.0
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        companyNameTxt.layer.cornerRadius = 5
        countryCodeTxtField.layer.cornerRadius = 5
        phoneNoTxt.layer.cornerRadius = 5
        emailIDTxt.layer.cornerRadius = 5
        countryCodeTxtField.isUserInteractionEnabled = true
       //companyNameTxt.backgroundColor = UIColor.clear
       companyNameTxt.borderStyle = .none
      // countryCodeTxtField.backgroundColor = UIColor.clear
       countryCodeTxtField.borderStyle = .none
       //phoneNoTxt.backgroundColor = UIColor.clear
       phoneNoTxt.borderStyle = .none
      // emailIDTxt.backgroundColor = UIColor.clear
       emailIDTxt.borderStyle = .none
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        /*nextBtn.layer.shadowColor = shadowColor
        nextBtn.layer.shadowOpacity = shadowOpacity
       nextBtn.layer.shadowOffset = shadowOffset
        nextBtn.layer.shadowRadius = shadowRadius*/
       /* let underlineLayer = CALayer()
        underlineLayer.frame = CGRect(x: 0, y: companyNameTxt.frame.size.height - 1, width: companyNameTxt.frame.size.width, height: 1)
        underlineLayer.backgroundColor = UIColor.white.cgColor
        companyNameTxt.layer.addSublayer(underlineLayer)
        let underlineLayer4 = CALayer()
        underlineLayer4.frame = CGRect(x: 0, y: countryCodeTxtField.frame.size.height - 1, width: countryCodeTxtField.frame.size.width, height: 1)
        underlineLayer4.backgroundColor = UIColor.white.cgColor
        countryCodeTxtField.layer.addSublayer(underlineLayer4)
        let underlineLayer3 = CALayer()
        underlineLayer3.frame = CGRect(x: 0, y: phoneNoTxt.frame.size.height - 1, width: phoneNoTxt.frame.size.width, height: 1)
        underlineLayer3.backgroundColor = UIColor.white.cgColor
        phoneNoTxt.layer.addSublayer(underlineLayer3)
        let underlineLayer2 = CALayer()
        underlineLayer2.frame = CGRect(x: 0, y: emailIDTxt.frame.size.height - 1, width: emailIDTxt.frame.size.width, height: 1)
        underlineLayer2.backgroundColor = UIColor.white.cgColor
        emailIDTxt.layer.addSublayer(underlineLayer2)*/
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
        guard let companyName = companyNameTxt.text, !companyName.isEmpty else {
            companyNameStatusLabel.text = "Please enter company name"
            phoneNumberStatusLabel.text = ""
            emailIdStatusLabel.text = ""
            return
        }
        guard let emailID = emailIDTxt.text, !emailID.isEmpty else {
            companyNameStatusLabel.text = ""
            phoneNumberStatusLabel.text = ""
            emailIdStatusLabel.text = "Please enter email ID"
            return
        }
        resetStatusLabels()
        if !isValidEmail(emailID) {
            emailIdStatusLabel.text = "Invalid email"
            return
        }
        guard let countryCode = countryCodeTxtField.text, !countryCode.isEmpty else {
            companyNameStatusLabel.text = ""
            phoneNumberStatusLabel.text = "Please enter Country Code"
            emailIdStatusLabel.text = ""
            return
        }
        guard let phoneNumber = phoneNoTxt.text, !phoneNumber.isEmpty else {
            companyNameStatusLabel.text = ""
            phoneNumberStatusLabel.text = "Please enter phone number"
            emailIdStatusLabel.text = ""
            return
        }
        if !isValidPhoneNumber(phoneNumber) {
            phoneNumberStatusLabel.text = "Invalid phone number"
            return
        }
        
        print("Sending signup request to API...")
        signUpUserAPI(companyName: companyName, countryCode: countryCode, phoneNumber: phoneNumber, emailID: emailID)
    }
    // MARK: - signUpUserAPI: Function to send a sign-up request to the API
    func signUpUserAPI(companyName: String, countryCode: String, phoneNumber: String, emailID: String) {
        let apiURL = URL(string: "https://192.168.29.7:8080/newCompanyRegister")!
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let currentDate = Date()
        let dateFormatter = ISO8601DateFormatter()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let parameters: [String: Any] = [
            "companyName": companyName,
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
                        print("Response Data: \(responseData)")
                                           
                        do {
  
                                    let jsonObject = try JSONSerialization.jsonObject(with: responseData/*decryptedData*/, options: [])
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
    
    // MARK: - resetStatusLabels: Function to reset the status labels for input validation
    func resetStatusLabels() {
        companyNameStatusLabel.text = ""
        phoneNumberStatusLabel.text = ""
        emailIdStatusLabel.text = ""
    }
    // MARK: - isValidEmail: Function to validate an email address using regular expressions
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
   // MARK: - This class is for third party country code selector: DialCountries
extension SignUpViewController: DialCountriesControllerDelegate {
    func didSelected(with country: Country) {
        countryCodeTxtField.text = country.dialCode
    }
}
