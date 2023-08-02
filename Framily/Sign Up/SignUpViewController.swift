//
//  SignUpViewController.swift
//  Framily
//
//  Created by Tharun kumar on 04/07/23.
//
// sign up 1
import UIKit
import Foundation
import CoreData
import DialCountries

class SignUpViewController: UIViewController {
    
    var countryCodes = [[String]]()
    @IBOutlet weak var phoneNoTxt: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var countryCodeTxtField: UITextField!
    @IBOutlet weak var companyNameTxt: UITextField!
    @IBOutlet weak var emailIDTxt: UITextField!
    @IBOutlet weak var companyNameStatusLabel: UILabel!
    @IBOutlet weak var phoneNumberStatusLabel: UILabel!
    @IBOutlet weak var emailIdStatusLabel: UILabel!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /* let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: companyNameTxt.frame.height))
                companyNameTxt.leftView = paddingView
                companyNameTxt.leftViewMode = .always
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: phoneNoTxt.frame.height))
                phoneNoTxt.leftView = paddingView
                phoneNoTxt.leftViewMode = .always
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: countryCodeTxtField.frame.height))
               // countryCodeTxtField.leftView = paddingView
                countryCodeTxtField.leftViewMode = .always
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailIDTxt.frame.height))
              //  emailIDTxt.leftView = paddingView
                emailIDTxt.leftViewMode = .always*/
        countryCodeTxtField.text = "  +91"
        self.navigationController?.navigationBar.topItem?.title = "Sign Up"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDialCountriesController))
        countryCodeTxtField.addGestureRecognizer(tapGesture)
        countryCodeTxtField.isUserInteractionEnabled = true
       // signUpView.layer.cornerRadius = 20.0
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        self.countryCodes = getAllCountryCodes()
        picker()
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
        
        nextBtn.layer.shadowColor = shadowColor
        nextBtn.layer.shadowOpacity = shadowOpacity
       nextBtn.layer.shadowOffset = shadowOffset
        nextBtn.layer.shadowRadius = shadowRadius
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func showDialCountriesController() {
        let cv = DialCountriesController(locale: Locale(identifier: "en"))
        cv.delegate = self
        cv.show(vc: self)
    }
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
        signUpUser(companyName: companyName, countryCode: countryCode, phoneNumber: phoneNumber, emailID: emailID)
    }
    func signUpUser(companyName: String, countryCode: String, phoneNumber: String, emailID: String) {
            let apiURL = URL(string: "http://192.168.29.7:8080/companyRegister")!
        
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // afer api checking
            let parameters: [String: Any] = [
                "companyName": companyName,
                "countryCode": countryCode,
                "phoneNumber": phoneNumber,
                "emailID": emailID
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                print("Error creating request body: \(error)")
                return
            }
        let credentials = "arun:arun1"
            let credentialsData = credentials.data(using: .utf8)!
            let base64Credentials = credentialsData.base64EncodedString()
            request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) {
                    
                    if let responseData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                            print("Response: \(jsonObject)")
                            
                            if let responseDict = jsonObject as? [String: Any],
                               let success = responseDict["success"] as? Bool, success {
                               
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let otpViewController = storyboard.instantiateViewController(withIdentifier: "EmailOTPViewControllers") as! EmailOTPViewController
                                    otpViewController.responseData = responseDict
                                    self.navigationController?.pushViewController(otpViewController, animated: true)
                                }
                            } else {
                                
                                DispatchQueue.main.async {
                                                
                                    self.showCustomAlertWith(message:" Server Error", descMsg: "There was a problem with the server. Please try again later.")
                                            }
                            }
                            
                        }catch {
                            print("Error parsing response data: \(error)")
                        }
                    }
                } else {
                    print("Invalid HTTP response: \(response?.description ?? "")")
                    
                }
            }
            task.resume()
        print("Sending signup request to API...")
        }
 
    
    func getAllCountryCodes() -> [[String]] {
        var countrys = [[String]]()
        let countryList = GlobalConstants.Constants.codePrefixes
        for item in countryList {
            countrys.append(item.value)
        }
        let sorted = countrys.sorted(by: {$0[0] < $1[0]})
        return sorted
    }
    // MARK: - Create UIPickerView
    func picker(){
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        countryCodeTxtField.inputView = picker
        picker.selectRow(0, inComponent: 0, animated: true)
    }
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpToEmailOTP" {
            if let otpVC = segue.destination as? EmailOTPViewController {
                let newUser = sender as? User
                otpVC.user = newUser
            }
        }
        else if segue.identifier == "OTPToConfirmPassword" {
            if let confirmPasswordVC = segue.destination as? ConfirmPasswordViewController {
                let newUser = sender as? User
                confirmPasswordVC.user = newUser
                confirmPasswordVC.companyName = newUser?.companyName
                confirmPasswordVC.phoneNumber = newUser?.phoneNumber
                confirmPasswordVC.countryCode = newUser?.countryCode
                confirmPasswordVC.emailID = newUser?.emailID
        
            }
        }
    }*/
    func resetStatusLabels() {

        companyNameStatusLabel.text = ""

        phoneNumberStatusLabel.text = ""

        emailIdStatusLabel.text = ""


    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }


    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
            let phoneRegex = "[0-9]{10}"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phonePredicate.evaluate(with: phoneNumber)
        }
    
  }
extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        countryCodeTxtField.text = "+\(code[1])"
    }
}
extension SignUpViewController: DialCountriesControllerDelegate {
    func didSelected(with country: Country) {
        // Update the text field with the selected country code
        countryCodeTxtField.text = country.dialCode
    }
}
