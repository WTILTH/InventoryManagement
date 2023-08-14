//
//  signUpUser.swift
//  Inventory Mangement
//  Requirement ID :RI/2
//  Created by Varun kumar on 21/07/23.
//  Module : Login 
import UIKit
import CoreData
/*Version History
Draft|| Date        || Author         || Description
0.1   | 14-Aug-2023  | Varun Kumar     | UX
0.2   | 14-Aug-2023  | Tharun Kumar    | API Integration
Changes:
 
 */
class loginUserNameViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var signUpUserBtn: UIButton!
    @IBOutlet weak var groupNameTxt: UITextField!
    @IBOutlet weak var signUpUserPopUp: UIView!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var loginWithEmailPhoneBtn: UIButton!
    
    //var transparentOverlay: UIView?
    var shouldDisableButtons = false
    var managedObjectContext: NSManagedObjectContext!
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var iconClick = false
    let imageIcon = UIImageView()
    var currentPopUpView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //printSavedData()
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        signUpUserPopUp.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 200)
        signUpUserPopUp.layer.cornerRadius = 40.0
        imageIcon.image = UIImage(named: "closeEye")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
        
        imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.width)
        passwordTxt.rightView = contentView
        passwordTxt.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
        // transparentOverlay = UIView(frame: view.bounds)
        // transparentOverlay?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // transparentOverlay?.alpha = 0 // Initially transparent
        // view.addSubview(transparentOverlay!)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        signUpUserPopUp?.addGestureRecognizer(tapGestureRecognizer1)
        if shouldDisableButtons {
            loginBtn.isEnabled = false
            signUpUserBtn.isEnabled = false
            forgotPasswordBtn.isEnabled = false
            loginWithEmailPhoneBtn.isEnabled = false
            Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] timer in
                self?.loginBtn.isEnabled = true
                self?.signUpUserBtn.isEnabled = true
                self?.forgotPasswordBtn.isEnabled = true
                self?.loginWithEmailPhoneBtn.isEnabled = true
            }
        }
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
        signUpUserPopUp?.alpha = 1
        
        UIView.animate(withDuration: 0.3) {
            popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
        }
    }
    // MARK: - dismissPopUpView: Function to dismiss the pop-up view
            func dismissPopUpView(_ popUpView: UIView) {
                signUpUserPopUp?.alpha = 0

                UIView.animate(withDuration: 0.3) {
                    popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 200)
                }
                currentPopUpView = nil
            }
    // MARK: - touchesBegan: Dismiss the keyboard when the user taps outside of any text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - imageTapped: Function to toggle password visibility when the eye icon is tapped
    @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer){
   let tappedImage = tapGestureRecognizer.view as! UIImageView
   if iconClick
   {
       iconClick = false
       tappedImage.image = UIImage(named: "openEye")
       passwordTxt.isSecureTextEntry = false
   }
   else {
       iconClick = true
       tappedImage.image = UIImage(named: "closeEye")
       passwordTxt.isSecureTextEntry = true
   }
}
    // MARK: - showPopUpButtonTapped: Function to handle the "Show Pop-Up" button tap
    @IBAction func showPopUpButtonTapped(_ sender: UIButton) {
       if sender == signUpUserBtn {
            showPopUpView(signUpUserPopUp)
        }
    }
    // MARK: - dismissPopUpButtonTapped: Function to handle the "Dismiss Pop-Up" button tap
        @IBAction func dismissPopUpButtonTapped(_ sender: UIButton) {
          if sender.superview == signUpUserPopUp {
                dismissPopUpView(signUpUserPopUp)
            }
        }
    // MARK: - forgotPasswordBtnPressed: Function to handle the "Forgot Password" button tap
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {

        guard let groupName = groupNameTxt.text, !groupName.isEmpty
        else {
            showCustomAlertWith(message: "Please enter your groupName", descMsg: "")

            return
       }
        guard let userName = userNameTxt.text, !userName.isEmpty
        else {
            showCustomAlertWith(message: "Please enter your user name", descMsg: "")
            return
        }
        forgotPasswordUserAPI(groupName: groupName, userName: userName)
    }
    // MARK: - loginUser: Function to send a forgot Password request to the API
    func forgotPasswordUserAPI(groupName: String, userName: String) {
        let apiURL = URL(string: "https://192.168.29.7:8080/forgotPassword")!
    
    var request = URLRequest(url: apiURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let parameters: [String: Any] = [
        "groupName": groupName,
        "userName": userName
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
           }
    // MARK: - loginInButtonPressed: Function to handle the "Login" button tap
    @IBAction func loginInButtonPressed(_ sender: Any) {
        guard let groupName = groupNameTxt.text, !groupName.isEmpty else {
            showCustomAlertWith(message: "Please enter groupName", descMsg: "")
            return
        }
        
        guard let userName = userNameTxt.text, !userName.isEmpty else {
            showCustomAlertWith(message: "Please enter userName", descMsg: "")
            return
        }
        
        guard let password = passwordTxt.text, !password.isEmpty else {
            showCustomAlertWith(message: "Please enter password", descMsg: "")
            return
        }
        
        print("Sending signup request to API...")
        loginUser(groupName: groupName, userName: userName, password: password)
    }
    // MARK: - verifyPassword: Function to verify if the entered password matches
    private func verifyPassword(_ password: String, storedHash: String?) -> Bool {
        return password == storedHash
    }
    // MARK: - loginUser: Function to send a login request to the API
    func loginUser(groupName: String, userName: String, password: String) {
        let apiURL = URL(string: "https://192.168.29.7:8080/usernameLogin")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "groupName": groupName,
            "userName": userName,
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
                                    self.performSegue(withIdentifier: "signinToOtp", sender: nil)
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
    // MARK: - prepare: Disable all buttons after the segue from EmailOTPViewController , Where the resend button is clicked more than three times
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewController" {
            loginBtn.isEnabled = false
            signUpUserBtn.isEnabled = false
            forgotPasswordBtn.isEnabled = false
            loginWithEmailPhoneBtn.isEnabled = false
        }
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
    

}
