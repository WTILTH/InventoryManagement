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
    @IBOutlet weak var FPPhoneNumberTxt: UITextField!
    @IBOutlet weak var FPEmailTxt: UITextField!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
            fetchUser()
        
    }
    @IBAction func VerifyBtnPressed(_ sender: Any) {
        
        
        performSegue(withIdentifier: "forgetToFPotp", sender: nil)
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
