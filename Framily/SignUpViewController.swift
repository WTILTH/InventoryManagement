//
//  SignUpViewController.swift
//  Framily
//
//  Created by Tharun kumar on 04/07/23.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var phoneNoTxt: UITextField!
    @IBOutlet weak var companyNameTxt: UITextField!
    @IBOutlet weak var emailIDTxt: UITextField!
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let phoneNumber = phoneNoTxt.text,
              let companyName = companyNameTxt.text,
              let emailID = emailIDTxt.text else {
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
    }
  }
