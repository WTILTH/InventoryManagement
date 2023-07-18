//
//  SignUpViewController.swift
//  Framily
//
//  Created by Tharun kumar on 04/07/23.
//

import UIKit
import CoreData
import DialCountries

class SignUpViewController: UIViewController {
    
    var countryCodes = [[String]]()
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var phoneNoTxt: UITextField!
    @IBOutlet weak var signUpView: UIView!
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDialCountriesController))
        countryCodeTxtField.addGestureRecognizer(tapGesture)
        countryCodeTxtField.isUserInteractionEnabled = true
        signUpView.layer.cornerRadius = 20.0
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        self.countryCodes = getAllCountryCodes()
        picker()
        countryCodeTxtField.isUserInteractionEnabled = true
        companyNameTxt.backgroundColor = UIColor.clear
       companyNameTxt.borderStyle = .none
        countryCodeTxtField.backgroundColor = UIColor.clear
       countryCodeTxtField.borderStyle = .none
        phoneNoTxt.backgroundColor = UIColor.clear
       phoneNoTxt.borderStyle = .none
        emailIDTxt.backgroundColor = UIColor.clear
       emailIDTxt.borderStyle = .none
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        nextBtn.layer.shadowColor = shadowColor
        nextBtn.layer.shadowOpacity = shadowOpacity
       nextBtn.layer.shadowOffset = shadowOffset
        nextBtn.layer.shadowRadius = shadowRadius
        signUpView.layer.shadowColor = shadowColor
        signUpView.layer.shadowOpacity = shadowOpacity
        signUpView.layer.shadowOffset = shadowOffset
        signUpView.layer.shadowRadius = shadowRadius
        let underlineLayer = CALayer()
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
        emailIDTxt.layer.addSublayer(underlineLayer2)
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
        guard let company_Name = companyNameTxt.text, !company_Name.isEmpty else {
            companyNameStatusLabel.text = "Please enter company name"
            phoneNumberStatusLabel.text = ""
            emailIdStatusLabel.text = ""
            return
        }
        guard let country_Code = countryCodeTxtField.text, !country_Code.isEmpty else {
            companyNameStatusLabel.text = ""
            phoneNumberStatusLabel.text = "Please enter Country Code"
            emailIdStatusLabel.text = ""
            return
        }
        guard let phone_Number = phoneNoTxt.text, !phone_Number.isEmpty else {
            companyNameStatusLabel.text = ""
            phoneNumberStatusLabel.text = "Please enter phone number"
            emailIdStatusLabel.text = ""
            return
        }
        
        if !isValidPhoneNumber(phone_Number) {
            phoneNumberStatusLabel.text = "Invalid phone number"
            return
        }
        
        guard let email_ID = emailIDTxt.text, !email_ID.isEmpty else {
            companyNameStatusLabel.text = ""
            phoneNumberStatusLabel.text = ""
            emailIdStatusLabel.text = "Please enter email ID"
            return
        }
        
        resetStatusLabels()
        
        
        if !isValidEmail(email_ID) {
            emailIdStatusLabel.text = "Invalid email"
            return
        }
        let newUser = User(context: managedContext)
        newUser.phone_Number = phone_Number
        newUser.country_Code = country_Code
        newUser.company_Name = company_Name
        newUser.email_ID = email_ID
        newUser.device_ID = UIDevice.current.identifierForVendor?.uuidString
        newUser.session_ID = UUID().uuidString

        performSegue(withIdentifier: "SignUpToEmailOTP", sender: newUser)

        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
                confirmPasswordVC.company_Name = newUser?.company_Name
                confirmPasswordVC.phone_Number = newUser?.phone_Number
                confirmPasswordVC.country_Code = newUser?.country_Code
                confirmPasswordVC.email_ID = newUser?.email_ID
        
            }
        }
    }
    
    func resetStatusLabels() {

        companyNameStatusLabel.text = ""

        phoneNumberStatusLabel.text = ""

        emailIdStatusLabel.text = ""

        statusLabel.text = ""

    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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
