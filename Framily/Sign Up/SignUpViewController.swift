//
//  SignUpViewController.swift
//  Framily
//
//  Created by Tharun kumar on 04/07/23.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var phoneNoTxt: UITextField!
    @IBOutlet weak var companyNameTxt: UITextField!
    @IBOutlet weak var emailIDTxt: UITextField!
    @IBOutlet weak var companyNameStatusLabel: UILabel!
    @IBOutlet weak var phoneNumberStatusLabel: UILabel!
    @IBOutlet weak var emailIdStatusLabel: UILabel!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let companyName = companyNameTxt.text, !companyName.isEmpty,
            let phoneNumber = phoneNoTxt.text, !phoneNumber.isEmpty,
            let emailID = emailIDTxt.text, !emailID.isEmpty else {
                statusLabel.text = "All fields must be filled."
                return
        }

        resetStatusLabels()
        if !isValidEmail(emailID) {
            emailIdStatusLabel.text = "Invalid email"
            return
        }

        if !isValidPhoneNumber(phoneNumber) {
            phoneNumberStatusLabel.text = "Invalid phone number"
            return
        }

        let newUser = User(context: managedContext)
        newUser.phoneNumber = phoneNumber
        newUser.companyName = companyName
        newUser.emailID = emailID
        newUser.deviceID = UIDevice.current.identifierForVendor?.uuidString
        newUser.sessionID = UUID().uuidString

        performSegue(withIdentifier: "SignUpToEmailOTP", sender: newUser)

        
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
                confirmPasswordVC.companyName = newUser?.companyName
                confirmPasswordVC.phoneNumber = newUser?.phoneNumber
                confirmPasswordVC.emailID = newUser?.emailID
        
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
