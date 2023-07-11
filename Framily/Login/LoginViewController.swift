//
//  LoginViewController.swift
//  Framily
//
//  Created by Tharun kumar on 19/06/23.
//
import UIKit
import CoreData
import StoreKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailIdText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        printSavedData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let emailID = emailIdText.text, !emailID.isEmpty,
            let password = passwordText.text, !password.isEmpty else {
                
                showCustomAlertWith(message: "Fill all the fields", descMsg: "Please enter both email and password.")
                return
        }

        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "emailID == %@", emailID)

        do {
            let result = try managedContext.fetch(fetchRequest)
            if let user = result.first as? User {
                if user.password == password {
                    
                    performSegue(withIdentifier: "loginToOtp", sender: nil)
                } else {
                    
                    showCustomAlertWith(message: "Incorrect password", descMsg: "Incorrect password.")
                }
            } else {
                
                showCustomAlertWith(message: "user found with the provided email", descMsg: "No user found with the provided email.")
            }
        } catch {
            
            showCustomAlertWith(message: "An error occurred during login.", descMsg: "An error occurred during login.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToOtp" {
            
        }
    }
    func printSavedData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let savedUsers = try managedContext.fetch(fetchRequest)
            for user in savedUsers {
                print("User Data:")
                print("Phone Number: \(user.phoneNumber ?? "")")
                print("Company Name: \(user.companyName ?? "")")
                print("Email ID: \(user.emailID ?? "")")
                print("Device ID: \(user.deviceID ?? "")")
                print("Session ID: \(user.sessionID ?? "")")
                print("Group Name: \(user.groupName ?? "")")
                print("First Name: \(user.firstName ?? "")")
                print("Last Name: \(user.lastName ?? "")")
                print("User Name: \(user.userName ?? "")")
                print("Password: \(user.password ?? "")")
                print("----------------------")
            }
        } catch let error as NSError {
            print("Error fetching data: \(error), \(error.userInfo)")
        }
    }
}


extension UIViewController {
    static var commonAlertImage: UIImage?
    
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
