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
    @IBOutlet weak var FPUserNameTxt: UITextField!
    @IBOutlet weak var FPGroupNameTxt: UITextField!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
            fetchUser()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func VerifyBtnPressed(_ sender: Any) {
        guard let userName = FPUserNameTxt.text, !userName.isEmpty,
            let groupName = FPGroupNameTxt.text, !groupName.isEmpty else {
         
            showCustomAlertWith(message: "Fill all the fields", descMsg: "Please enter both user name and group name.")
            return
        }

       
        let hasMatchingUser = users.contains { $0.userName == userName && $0.groupName == groupName }

        if hasMatchingUser {
                performSegue(withIdentifier: "forgetToFPotp", sender: nil)
        } else {
            
            showCustomAlertWith(message: "Invalid user", descMsg: "No user found with the provided user name and group name.")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forgetToFPotp" {
            if let otpViewController = segue.destination as? ForgotPasswordOtpViewController,
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
            print("Failed to fetch vendors: \(error)")
        }
    }
}

