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
              
                let emailID = emailIDTxt.text, !emailID.isEmpty  else {
            
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
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "phoneNumber == %@ AND companyName == %@ AND emailID == %@",phoneNumber, companyName,emailID)
        
        do {
            let matchingUsers = try managedContext.fetch(fetchRequest)
            
            if matchingUsers.isEmpty {
                
                let User = User(context: managedContext)
                User.phoneNumber = phoneNumber
                User.companyName = companyName
                User.emailID = emailID
                User.deviceID = UIDevice.current.identifierForVendor?.uuidString
                User.sessionID = UUID().uuidString
                
                do {
                    try managedContext.save()
                    print("Data saved successfully!")
                    
                    phoneNoTxt.text = ""
                    companyNameTxt.text = ""
                    emailIDTxt.text = ""
                    
                    print("Phone Number: \(User.phoneNumber ?? "")")
                    print("Company Name: \(User.companyName ?? "")")
                    print("Device ID: \(User.deviceID ?? "")")
                    print("Session ID: \(User.sessionID ?? "")")
                    print("Email ID: \(User.emailID ?? "")")
                    
                    
                } catch let error as NSError {
                    print("Error saving data: \(error), \(error.userInfo)")
                }
          
                
            } else {
                showCustomAlertWith(message: "User with the same phone number and company name already exists.", descMsg: "")
                
                phoneNoTxt.text = ""
                companyNameTxt.text = ""
                emailIDTxt.text = ""
            }
            
        } catch let error as NSError {
            print("Error fetching data: \(error), \(error.userInfo)")
        }
        performSegue(withIdentifier: "SignUpToEmailOTP", sender: nil)
        
        
        // Assuming you have instantiated the ConfirmPasswordViewController from the storyboard
        
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
