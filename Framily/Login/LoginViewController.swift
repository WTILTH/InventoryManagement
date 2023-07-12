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
    
    var managedObjectContext: NSManagedObjectContext!
    var iconClick = false
    let imageIcon = UIImageView()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        printSavedData()

        setupCoreDataStack()

        

        let startDateString = "2023-07-12"

        let endDateString = "2023-07-12"

        

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"

        

        if let startDate = dateFormatter.date(from: startDateString),

            let endDate = dateFormatter.date(from: endDateString) {

            

            let currentDate = Date()

            if currentDate >= startDate && currentDate <= endDate {

                let calendar = Calendar.current

                let dateComponents = calendar.dateComponents([.day], from: currentDate, to: endDate)

                

                if let numberOfDays = dateComponents.day {

                    let unit = SKProduct.PeriodUnit.day

                    let formattedPeriod = PeriodFormatter.formatSubscriptionPeriod(unit: unit, numberOfUnits: numberOfDays)

                    

                    if let currentUser = getCurrentUser() {

                        let dueAmount = currentUser.dueAmount

                        showAlert(for: formattedPeriod, dueAmount: dueAmount)

                    } else {

                        showAlert(for: formattedPeriod, dueAmount: nil)

                    }

                }

            } else {

                showAlert(for: "Trial Period Expired", dueAmount: nil)

            }

        }

    

        imageIcon.image = UIImage(named: "closeEye")
                let contentView = UIView()
                contentView.addSubview(imageIcon)
                
                contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
                
                imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
                passwordText.rightView = contentView
                passwordText.rightViewMode = .always
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                imageIcon.isUserInteractionEnabled = true
                imageIcon.addGestureRecognizer(tapGestureRecognizer)
                
            }
    
    func showAlert(for subscriptionPeriod: String?, dueAmount: Double?) {
        let message: String
        if let period = subscriptionPeriod, let amount = dueAmount {
            message = "Your subscription period is \(period). Due amount: \(amount)"
        } else if let period = subscriptionPeriod, let amount = dueAmount{
            message = "\(period). Due amount: \(amount)"
        } else {
            message = "Invalid subscription period"
        }
        
        let alert = UIAlertController(title: "Subscription Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    private func getCurrentUser() -> User? {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.fetchLimit = 1

        do {
            let fetchedUsers = try managedObjectContext?.fetch(fetchRequest) as! [User]
            if let currentUser = fetchedUsers.first {
              
                currentUser.dueAmount = 59.99
                try managedObjectContext?.save()
                return currentUser
            }
        } catch let error as NSError {
            print("Failed to fetch user details: \(error), \(error.userInfo)")
        }
        
        return nil
    }
            
            
            @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer)
    {
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if iconClick
        {
            iconClick = false
            tappedImage.image = UIImage(named: "openEye")
            passwordText.isSecureTextEntry = false
        }
        
        else {
            
            iconClick = true
            tappedImage.image = UIImage(named: "closeEye")
            passwordText.isSecureTextEntry = true
            
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        
        guard let loginInput = emailIdText.text, !loginInput.isEmpty
        else {
            showCustomAlertWith(message: "Please enter your Username or Email ID or Phone number", descMsg: "Please enter your Username or Email ID or Phone number")
            return
    }
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let loginInput = emailIdText.text, !loginInput.isEmpty,
                    let password = passwordText.text, !password.isEmpty else {
                        showCustomAlertWith(message: "Please enter both login and password", descMsg: "Please enter both login and password.")
                        return
                }
  
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                fetchRequest.predicate = NSPredicate(format: "password == %@", password)

                do {
                    let result = try managedContext.fetch(fetchRequest)
                    let filteredUsers = result.compactMap { $0 as? User }.filter {
                        $0.userName == loginInput || $0.phoneNumber == loginInput
                    }
                    
                    if let user = filteredUsers.first {
                       
                        performSegue(withIdentifier: "loginToOtp", sender: nil)
                    } else {
                        showCustomAlertWith(message: "Invalid login credentials", descMsg: "Invalid login credentials.")
                    }
                } catch {
                   
                    showCustomAlertWith(message: "An error occurred during login", descMsg: "An error occurred during login.")
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
                print("--*------*-----*-----*---")
            }
        } catch let error as NSError {
            print("Error fetching data: \(error), \(error.userInfo)")
        }
    }
    


    private func setupCoreDataStack() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
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
