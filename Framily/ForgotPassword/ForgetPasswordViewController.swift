//
//  ForgotPasswordViewController.swift
//  Framily
//
//  Created by Varun kumar on 10/07/23.
//

import UIKit
import CoreData

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var veriftBtn: UIButton!
    @IBOutlet weak var FPEmailIDTxt: UITextField!
    @IBOutlet weak var FPPhoneNumberTxt: UITextField!
    
    var users: [User] = []
    
    override func viewDidLoad() {

            super.viewDidLoad()

            fetchUser()

        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            self.view.endEditing(true)

        }
        @IBAction func verifyBtnPressed(_ sender: Any) {
            guard let emailID = FPEmailIDTxt.text, !emailID.isEmpty,

                  let phoneNumber = FPPhoneNumberTxt.text, !phoneNumber.isEmpty else
            {
                showCustomAlertWith(message: "Fill all the fields", descMsg: "Please enter both Email ID and phone number.")
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
    }

