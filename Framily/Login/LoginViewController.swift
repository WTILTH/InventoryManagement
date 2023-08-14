//
//  LoginViewController.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Tharun kumar on 19/06/23.
//  Module : Login 
import UIKit
import CoreData
import StoreKit
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | UX and Validation
0.2   | 14-Aug-2023  | Tharun Kumar    | API Integration
Changes:
 
 */
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailIdText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signUpPopUp: UIView!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext!
    var iconClick = false
    let imageIcon = UIImageView()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentPopUpView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        //self.navigationItem.setHidesBackButton(true, animated: false)
        signUpPopUp.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 200)
        signUpPopUp.layer.cornerRadius = 40.0
       /* printSavedData()
        setupCoreDataStack()*/
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
        let underlineLayer = CALayer()
        underlineLayer.frame = CGRect(x: 0, y: emailIdText.frame.size.height - 1, width: emailIdText.frame.size.width, height: 1)
        underlineLayer.backgroundColor = UIColor.white.cgColor
        emailIdText.layer.addSublayer(underlineLayer)
        let underlineLayer1 = CALayer()
        underlineLayer1.frame = CGRect(x: 0, y: passwordText.frame.size.height - 1, width: passwordText.frame.size.width, height: 1)
        underlineLayer1.backgroundColor = UIColor.white.cgColor
        passwordText.layer.addSublayer(underlineLayer1)
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        signUpPopUp?.addGestureRecognizer(tapGestureRecognizer1)
    }
    // MARK: - handleTap: This function is to handle the pop up view
    @objc func handleTap() {
        view.endEditing(true)
        if let currentPopUpView = currentPopUpView {
            dismissPopUpView(currentPopUpView)
        }
    }
    //MARK: - showPopUpView: Function to show the pop-up view
    func showPopUpView(_ popUpView: UIView) {
        if let currentPopUpView = currentPopUpView {
            dismissPopUpView(currentPopUpView)
        }
        currentPopUpView = popUpView
        signUpPopUp?.alpha = 1
        UIView.animate(withDuration: 0.3) {
            popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
        }
    }
    // MARK: - dismissPopUpView: Function to dismiss the pop-up view
    func dismissPopUpView(_ popUpView: UIView) {
        signUpPopUp?.alpha = 0
        UIView.animate(withDuration: 0.3) {
            popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 200)
        }
        currentPopUpView = nil
    }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - showPopUpButtonTapped: Function to handle the "Show Pop-Up" button tap
    @IBAction func showPopUpButtonTapped(_ sender: UIButton) {
       if sender == signUpBtn {
            showPopUpView(signUpPopUp)
        }
    }
    // MARK: - dismissPopUpButtonTapped: Function to handle the "Dismiss Pop-Up" button tap
        @IBAction func dismissPopUpButtonTapped(_ sender: UIButton) {
          if sender.superview == signUpPopUp {
                dismissPopUpView(signUpPopUp)
            }
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
              
                currentUser.dueAmount = 55.99
                try managedObjectContext?.save()
                return currentUser
            }
        } catch let error as NSError {
            print("Failed to fetch user details: \(error), \(error.userInfo)")
        }
        
        return nil
    }
    // MARK: - imageTapped: Function to toggle password visibility when the eye icon is tapped
    @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer){
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
    // MARK: - forgotPasswordBtnPressed: Function to handle the "Forgot Password" button tap
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        guard let emailID = emailIdText.text, !emailID.isEmpty else {
            showCustomAlertWith(message: "Please enter Email Id or Phone Number", descMsg: "")
            return
        }
      //  print("Sending signup request to API...")
        //forgotPasswordAPI(emailID: emailID)
    }
    /*func forgotPasswordAPI(emailID: String) {
     let apiURL = URL(string: "https://192.168.29.7:8080/emailOrPhoneForgotPassword")!
 
 var request = URLRequest(url: apiURL)
 request.httpMethod = "POST"
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 
 let parameters: [String: Any] = [
     "emailID": emailID
 ]
 
 do {
     request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
 } catch {
     print("Error creating request body: \(error)")
     return
 }
 
 let credentials = "arun:arun1"
 let credentialsData = credentials.data(using: .utf8)!
 let base64Credentials = credentialsData.base64EncodedString()
 request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
 
 let session = URLSession.shared
 let task = session.dataTask(with: request) { data, response, error in
     if let error = error {
         print("Error: \(error)")
         // Handle network error appropriately
         return
     }
     
     if let httpResponse = response as? HTTPURLResponse {
         let statusCode = httpResponse.statusCode
         print("HTTP Status Code: \(statusCode)")
         
         if (200...299).contains(statusCode) {
             if let responseData = data {
                 do {
                     let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                     print("Response: \(jsonObject)")
                     
                     if let responseDict = jsonObject as? [String: Any] {
                         if let success = responseDict["success"] as? Bool, success {
                             DispatchQueue.main.async {
                                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                 let otpViewController = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordViewControllers") as! ForgetPasswordViewController
                                 otpViewController.responseData = responseDict
                                 self.navigationController?.pushViewController(otpViewController, animated: true)
                             }
                         } else if let errorMessage = responseDict["errorMessage"] as? String {
                             DispatchQueue.main.async {
                                 self.showCustomAlertWith(message: "Server Error", descMsg: errorMessage)
                             }
                         } else {
                             DispatchQueue.main.async {
                                 self.showCustomAlertWith(message: "Server Error", descMsg: "There was a problem with the server. Please try again later.")
                             }
                         }
                     } else {
                         DispatchQueue.main.async {
                             self.showCustomAlertWith(message: "Server Error", descMsg: "There was a problem with the server. Please try again later.")
                         }
                     }
                     
                 } catch {
                     print("Error parsing response data: \(error)")
                 }
             }
         } else if (400...499).contains(statusCode) {
             if let responseData = data {
                            do {
                                let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                                print("Response: \(jsonObject)")
                                
                                if let responseDict = jsonObject as? [String: Any], let body = responseDict["body"] as? String {
                                    DispatchQueue.main.async {
                                        self.showCustomAlertWith(message: body, descMsg: "")
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showCustomAlertWith(message: "An error occurred while processing the response.", descMsg: "")
                                    }
                                }
                                
                            } catch {
                                print("Error parsing response data: \(error)")
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Client Error", descMsg: "An error occurred while processing the response.")
                                }
                            }
                        }
                    } else {
                        print("Invalid HTTP response: \(httpResponse)")
                        DispatchQueue.main.async {
                            self.showCustomAlertWith(message: "Server Error", descMsg: "An unknown error occurred.")
                        }
                    }
                }
            }
            
            task.resume()
            print("Sending signup request to API...")
        }*/
    // MARK: - loginInButtonPressed: Function to handle the "Login" button tap
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let emailID = emailIdText.text, !emailID.isEmpty else {
             showCustomAlertWith(message: "Please enter Email Id or Phone Number", descMsg: "")
             return
         }
         
         guard let password = passwordText.text, !password.isEmpty else {
             showCustomAlertWith(message: "Please enter Password", descMsg: "")
             return
         }
        
        if emailID.rangeOfCharacter(from: .letters) != nil {
            
            if !isValidEmail(emailID) {
                showCustomAlertWith(message: "Invalid email format", descMsg: "Please enter a valid email address.")
                return
            }
        } else if emailID.rangeOfCharacter(from: .decimalDigits) != nil {
          
           /* if !isValidPhoneNumber(emailID) {
                showCustomAlertWith(message: "Invalid phone number", descMsg: "Please enter a valid phone number.")
                return
            }*/
        } else {
           
            showCustomAlertWith(message: "Invalid login", descMsg: "Please enter a valid email address or phone number.")
            return
        }
        
              /*  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                fetchRequest.predicate = NSPredicate(format: "emailID == %@", email)

                do {
                    let result = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
                    let filteredUsers = result.compactMap { $0 as? User }.filter {
                        $0.emailID == email
                    }
                    
                    if let user = filteredUsers.first {
                        if user.phoneNumber == phoneNumber {
                            performSegue(withIdentifier: "loginToOtp", sender: nil)
                        } else {
                            showCustomAlertWith(message: "Incorrect Phone Number", descMsg: "")
                        }
                    } else {
                        showCustomAlertWith(message: "Email is not registered", descMsg: "")
                    }
                } catch {
                    showCustomAlertWith(message: "An error occurred during login", descMsg: "")
                }*/
        print("Sending signup request to API...")
        loginAPI(emailID: emailID,password: password)
            }
    // MARK: - loginUser: Function to send a login request to the API
    func loginAPI(emailID: String, password: String) {
        let apiURL = URL(string: "https://192.168.29.7:8080/emailOrPhoneLogin")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "emailID": emailID,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error creating request body: \(error)")
            return
        }
        
        let credentials = "arun:arun1"
        let credentialsData = credentials.data(using: .utf8)!
        let base64Credentials = credentialsData.base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                // Handle network error appropriately
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("HTTP Status Code: \(statusCode)")
                
                if (200...299).contains(statusCode) {
                    if let responseData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                            print("Response: \(jsonObject)")
                         
                            if let responseDict = jsonObject as? [String: Any],
                               let success = responseDict["success"] as? Bool, success {
                               
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "loginToOtp", sender: nil)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Server Error", descMsg: "There was a problem with the server. Please try again later.")
                                }
                            }
                            
                        } catch {
                            print("Error parsing response data: \(error)")
                        }
                    }
                } else if (400...499).contains(statusCode) {
                    if let responseData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                            print("Response: \(jsonObject)")
                            
                            if let responseDict = jsonObject as? [String: Any], let body = responseDict["body"] as? String {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: body, descMsg: "")
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Client Error", descMsg: "An error occurred while processing the response.")
                                }
                            }
                            
                        } catch {
                            print("Error parsing response data: \(error)")
                            DispatchQueue.main.async {
                                self.showCustomAlertWith(message: "Client Error", descMsg: "An error occurred while processing the response.")
                            }
                        }
                    }
                } else {
                    print("Invalid HTTP response: \(httpResponse)")
                    DispatchQueue.main.async {
                        self.showCustomAlertWith(message: "Server Error", descMsg: "An unknown error occurred.")
                    }
                }
            }
        }
        
        task.resume()
        print("Sending signup request to API...")
    }

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToOtp" {
            
        }
    }*/
    // MARK: - isValidEmail: Function to validate an email address using regular expressions
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    // MARK: - isValidPhoneNumber: Function to validate a phone number using regular expressions
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
            let phoneRegex = "[0-9]{10}"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phonePredicate.evaluate(with: phoneNumber)
        }
    
   /* func printSavedData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let savedUsers = try managedContext.fetch(fetchRequest)
            for user in savedUsers {
                print("User Data:")
            print("Phone Number: \(user.phoneNumber ?? "")")
                print("Country Code: \(user.countryCode ?? "")")
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
    }*/
    


   /* private func setupCoreDataStack() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
    }*/
    }

  // MARK: - UIViewController: Extension is for the Custom alert properties
extension UIViewController {
    static var commonAlertImage: UIImage?
    // MARK: - showCustomAlertWith: Function to show custom alert
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
