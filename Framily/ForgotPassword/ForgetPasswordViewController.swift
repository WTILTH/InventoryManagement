//
//  ForgotPasswordViewController.swift
//  Framily
//
//  Created by Varun kumar on 10/07/23.
//

import UIKit
import CoreData

class ForgetPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var veriftBtn: UIButton!
    @IBOutlet weak var FPEmailIDTxt: UITextField!
    @IBOutlet weak var FPPhoneNumberTxt: UITextField!
    @IBOutlet weak var forgotPasswordView: UIView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
            super.viewDidLoad()
        forgotPasswordView.layer.cornerRadius = 20.0
        FPEmailIDTxt.backgroundColor = UIColor.clear
       FPEmailIDTxt.borderStyle = .none
        FPPhoneNumberTxt.backgroundColor = UIColor.clear
       FPPhoneNumberTxt.borderStyle = .none
        view.backgroundColor = BackgroundManager.shared.backgroundColor
            fetchUser()

        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        veriftBtn.layer.shadowColor = shadowColor
        veriftBtn.layer.shadowOpacity = shadowOpacity
       veriftBtn.layer.shadowOffset = shadowOffset
        veriftBtn.layer.shadowRadius = shadowRadius
        veriftBtn.layer.cornerRadius = 10.0
        forgotPasswordView.layer.shadowColor = shadowColor
        forgotPasswordView.layer.shadowOpacity = shadowOpacity
       forgotPasswordView.layer.shadowOffset = shadowOffset
        forgotPasswordView.layer.shadowRadius = shadowRadius
        let underlineLayer = CALayer()
        underlineLayer.frame = CGRect(x: 0, y: FPEmailIDTxt.frame.size.height - 1, width: FPEmailIDTxt.frame.size.width, height: 1)
        underlineLayer.backgroundColor = UIColor.white.cgColor
        FPEmailIDTxt.layer.addSublayer(underlineLayer)
        let underlineLayer1 = CALayer()
        underlineLayer1.frame = CGRect(x: 0, y: FPPhoneNumberTxt.frame.size.height - 1, width: FPPhoneNumberTxt.frame.size.width, height: 1)
        underlineLayer1.backgroundColor = UIColor.white.cgColor
        FPPhoneNumberTxt.layer.addSublayer(underlineLayer1)

        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            self.view.endEditing(true)

        }
        @IBAction func verifyBtnPressed(_ sender: Any) {
            guard let emailID = FPEmailIDTxt.text, !emailID.isEmpty else {
                showCustomAlertWith(message: "Fill Email ID", descMsg: "Please enter your Email ID.")
                return
            }
            if !isValidEmail(emailID) {
                showCustomAlertWith(message: "Invalid Email ID", descMsg: "")
                
                return
            }
            guard let phoneNumber = FPPhoneNumberTxt.text, !phoneNumber.isEmpty else {
                showCustomAlertWith(message: "Fill Phone Number", descMsg: "Please enter your phone number.")
                return
            }
            if !isValidPhoneNumber(phoneNumber) {
                showCustomAlertWith(message: "Invalid Phone number", descMsg: "")
                return
            }
            
            let hasMatchingUser = users.contains { $0.emailID == emailID && $0.phoneNumber == phoneNumber }
            
            if hasMatchingUser {
                performSegue(withIdentifier: "forgetToFPotp", sender: nil)
            } else {
                showCustomAlertWith(message: "Invalid user", descMsg: "No user found with the provided Email ID and phone number.")
            }
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if segue.identifier == "forgetToFPotp" {

                if let otpViewController = segue.destination as?
                    ForgotPasswordOtpViewController,
                   let validatedUser = sender as? User {
                otpViewController.user = validatedUser

                }
            }
        }
        func fetchUser() {

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {

                return

            }
let managedContext = appDelegate.persistentContainer.viewContext

            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            
            do {
                users = try managedContext.fetch(fetchRequest)
            } catch {
            print("Failed to fetch users: \(error)")

            }
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
    

