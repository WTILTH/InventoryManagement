//
//  SignUpExistingViewController.swift
//  Framily
//
//  Created by Varun kumar on 25/07/23.
//
// sign up 2
import UIKit
import CoreData
import DialCountries

class SignUpExistingViewController: UIViewController {
    
    var countryCodes = [[String]]()
    @IBOutlet weak var existingGroupNameTxt: UITextField!
    @IBOutlet weak var existingCountryCodeTxt: UITextField!
    @IBOutlet weak var existingPhoneNumberTxt: UITextField!
    @IBOutlet weak var existingEmailIDTxt: UITextField!
    @IBOutlet weak var existingGroupNameStatusLabel: UILabel!
    @IBOutlet weak var existingCountryCodeTxtStatusLabel: UILabel!
    @IBOutlet weak var existingEmailIDStatusLabel: UILabel!
    @IBOutlet weak var existingNextBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var existingSignUpView: UIView!
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDialCountriesController))
        existingCountryCodeTxt.addGestureRecognizer(tapGesture)
        existingCountryCodeTxt.isUserInteractionEnabled = true
        existingSignUpView.layer.cornerRadius = 20.0
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        self.countryCodes = getAllCountryCodes()
        picker()
        existingCountryCodeTxt.isUserInteractionEnabled = true
        existingGroupNameTxt.backgroundColor = UIColor.clear
       existingGroupNameTxt.borderStyle = .none
        existingCountryCodeTxt.backgroundColor = UIColor.clear
       existingCountryCodeTxt.borderStyle = .none
        existingPhoneNumberTxt.backgroundColor = UIColor.clear
       existingPhoneNumberTxt.borderStyle = .none
        existingEmailIDTxt.backgroundColor = UIColor.clear
       existingEmailIDTxt.borderStyle = .none
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        existingNextBtn.layer.shadowColor = shadowColor
        existingNextBtn.layer.shadowOpacity = shadowOpacity
       existingNextBtn.layer.shadowOffset = shadowOffset
        existingNextBtn.layer.shadowRadius = shadowRadius
        existingSignUpView.layer.shadowColor = shadowColor
        existingSignUpView.layer.shadowOpacity = shadowOpacity
        existingSignUpView.layer.shadowOffset = shadowOffset
        existingSignUpView.layer.shadowRadius = shadowRadius
        let underlineLayer = CALayer()
        underlineLayer.frame = CGRect(x: 0, y: existingGroupNameTxt.frame.size.height - 1, width: existingGroupNameTxt.frame.size.width, height: 1)
        underlineLayer.backgroundColor = UIColor.white.cgColor
        existingGroupNameTxt.layer.addSublayer(underlineLayer)
        let underlineLayer4 = CALayer()
        underlineLayer4.frame = CGRect(x: 0, y: existingCountryCodeTxt.frame.size.height - 1, width: existingCountryCodeTxt.frame.size.width, height: 1)
        underlineLayer4.backgroundColor = UIColor.white.cgColor
        existingCountryCodeTxt.layer.addSublayer(underlineLayer4)
        let underlineLayer3 = CALayer()
        underlineLayer3.frame = CGRect(x: 0, y: existingPhoneNumberTxt.frame.size.height - 1, width: existingPhoneNumberTxt.frame.size.width, height: 1)
        underlineLayer3.backgroundColor = UIColor.white.cgColor
        existingPhoneNumberTxt.layer.addSublayer(underlineLayer3)
        let underlineLayer2 = CALayer()
        underlineLayer2.frame = CGRect(x: 0, y: existingEmailIDTxt.frame.size.height - 1, width: existingEmailIDTxt.frame.size.width, height: 1)
        underlineLayer2.backgroundColor = UIColor.white.cgColor
        existingEmailIDTxt.layer.addSublayer(underlineLayer2)
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
        guard let groupName = existingGroupNameTxt.text, !groupName.isEmpty else {
            existingGroupNameStatusLabel.text = "Please enter Group name"
            existingCountryCodeTxtStatusLabel.text = ""
            existingEmailIDStatusLabel.text = ""
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
        
        if !isValidPhoneNumber(phoneNumber) {
            existingCountryCodeTxtStatusLabel.text = "Invalid phone number"
            return
        }
        
        guard let emailID = existingEmailIDTxt.text, !emailID.isEmpty else {
            existingGroupNameStatusLabel.text = ""
            existingCountryCodeTxtStatusLabel.text = ""
            existingEmailIDStatusLabel.text = "Please enter email ID"
            return
        }
        
        resetStatusLabels()
        
        
        if !isValidEmail(emailID) {
            existingEmailIDStatusLabel.text = "Invalid email"
            return
        }
        let newUser = User(context: managedContext)
        newUser.phoneNumber = phoneNumber
      newUser.countryCode = countryCode
       newUser.groupName = groupName
        newUser.emailID = emailID
       newUser.deviceID = UIDevice.current.identifierForVendor?.uuidString
       newUser.sessionID = UUID().uuidString

        performSegue(withIdentifier: "SignUpExistingToEmailOTP", sender: newUser)

        
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
        existingCountryCodeTxt.inputView = picker
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
                confirmPasswordVC.groupName = newUser?.groupName
                confirmPasswordVC.phoneNumber = newUser?.phoneNumber
                confirmPasswordVC.countryCode = newUser?.countryCode
                confirmPasswordVC.emailID = newUser?.emailID
        
            }
        }
    }
    
    func resetStatusLabels() {

        existingGroupNameStatusLabel.text = ""

        existingCountryCodeTxtStatusLabel.text = ""

        existingEmailIDStatusLabel.text = ""

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
extension SignUpExistingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
}
extension SignUpExistingViewController: DialCountriesControllerDelegate {
    func didSelected(with country: Country) {
        // Update the text field with the selected country code
        existingCountryCodeTxt.text = country.dialCode
    }
}

