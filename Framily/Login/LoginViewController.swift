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

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailIdText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginView: UIView!
    
    var managedObjectContext: NSManagedObjectContext!
    var iconClick = false
    let imageIcon = UIImageView()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        self.navigationItem.setHidesBackButton(true, animated: false)
        printSavedData()
        setupCoreDataStack()
        loginView.layer.cornerRadius = 20.0
        loginBtn.layer.cornerRadius = 10.0
        signUpBtn.layer.cornerRadius = 10.0
        emailIdText.backgroundColor = UIColor.clear
       emailIdText.borderStyle = .none
        passwordText.backgroundColor = UIColor.clear
       passwordText.borderStyle = .none
        let shadowColor = UIColor.black.cgColor
        let shadowOpacity: Float = 2.0
        let shadowOffset = CGSize(width: 0, height: 3)
        let shadowRadius: CGFloat = 5
        
        signUpBtn.layer.shadowColor = shadowColor
        signUpBtn.layer.shadowOpacity = shadowOpacity
       signUpBtn.layer.shadowOffset = shadowOffset
        signUpBtn.layer.shadowRadius = shadowRadius
        
        loginBtn.layer.shadowColor = shadowColor
        loginBtn.layer.shadowOpacity = shadowOpacity
       loginBtn.layer.shadowOffset = shadowOffset
        loginBtn.layer.shadowRadius = shadowRadius
        loginView.layer.shadowColor = shadowColor
        loginView.layer.shadowOpacity = shadowOpacity
       loginView.layer.shadowOffset = shadowOffset
        loginView.layer.shadowRadius = shadowRadius
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

                        let dueAmount = currentUser.due_Amount

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
        let underlineLayer = CALayer()
        underlineLayer.frame = CGRect(x: 0, y: emailIdText.frame.size.height - 1, width: emailIdText.frame.size.width, height: 1)
        underlineLayer.backgroundColor = UIColor.white.cgColor
        emailIdText.layer.addSublayer(underlineLayer)
        let underlineLayer1 = CALayer()
        underlineLayer1.frame = CGRect(x: 0, y: passwordText.frame.size.height - 1, width: passwordText.frame.size.width, height: 1)
        underlineLayer1.backgroundColor = UIColor.white.cgColor
        passwordText.layer.addSublayer(underlineLayer1)
            }
    
    func showAlert(for subscriptionPeriod: String?, dueAmount: Double?) {

            let message: String

            if let period = subscriptionPeriod, let amount = dueAmount {

                message = "Your subscription period is \(period). Due amount: \(amount)"

            } else if let period = subscriptionPeriod, let amount = dueAmount {

                message = "\(period). Due amount: \(amount)"

            } else {

                message = "Subscription period got over"

            }

            

            if subscriptionPeriod != nil {

                let alert = UIAlertController(title: "Subscription Alert", message: message, preferredStyle: .alert)

                

              

                let payAction = UIAlertAction(title: "Pay Now", style: .default) { [weak self] (_) in

                    self?.navigateToPaymentViewController()

                }

                

                alert.addAction(payAction)

                

                if subscriptionPeriod != nil {

                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                    alert.addAction(cancelAction)

                }

                

                present(alert, animated: true, completion: nil)

            } else {

                let alert = UIAlertController(title: "Subscription Alert", message: message, preferredStyle: .alert)

                

                let payAction = UIAlertAction(title: "Pay Now", style: .default) { [weak self] (_) in

                    self?.navigateToPaymentViewController()

                }

                

                alert.addAction(payAction)

                

                present(alert, animated: true, completion: nil)

            }

        }




        func navigateToPaymentViewController() {

         

            performSegue(withIdentifier: "paymentSegue", sender: nil)

        }
    private func getCurrentUser() -> User? {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.fetchLimit = 1

        do {
            let fetchedUsers = try managedObjectContext?.fetch(fetchRequest) as! [User]
            if let currentUser = fetchedUsers.first {
              
                currentUser.due_Amount = 59.99
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
            showCustomAlertWith(message: "Please enter your Username or Email ID or Phone number", descMsg: "")
            return
    }
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailIdText.text, !email.isEmpty else {
             showCustomAlertWith(message: "Please enter Email Id or Phone number", descMsg: "")
             return
         }
         
         guard let password = passwordText.text, !password.isEmpty else {
             showCustomAlertWith(message: "Please enter password", descMsg: "")
             return
         }
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                fetchRequest.predicate = NSPredicate(format: "email_ID == %@", email)

                do {
                    let result = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
                    let filteredUsers = result.compactMap { $0 as? User }.filter {
                        $0.email_ID == email
                    }
                    
                    if let user = filteredUsers.first {
                        if user.password == password {
                            performSegue(withIdentifier: "loginToOtp", sender: nil)
                        } else {
                            showCustomAlertWith(message: "Incorrect password", descMsg: "")
                        }
                    } else {
                        showCustomAlertWith(message: "Email is not registered", descMsg: "")
                    }
                } catch {
                    showCustomAlertWith(message: "An error occurred during login", descMsg: "")
                }
            }
   


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToOtp" {
            
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
    func printSavedData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let savedUsers = try managedContext.fetch(fetchRequest)
            for user in savedUsers {
                print("User Data:")
            print("Phone Number: \(user.phone_Number ?? "")")
                print("Country Code: \(user.country_Code ?? "")")
        print("Company Name: \(user.company_Name ?? "")")
            print("Email ID: \(user.email_ID ?? "")")
            print("Device ID: \(user.device_ID ?? "")")
            print("Session ID: \(user.session_ID ?? "")")
            print("Group Name: \(user.group_Name ?? "")")
            print("First Name: \(user.first_Name ?? "")")
            print("Last Name: \(user.last_Name ?? "")")
            print("User Name: \(user.user_Name ?? "")")
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
