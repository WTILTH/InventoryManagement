//
//  signUpUser.swift
//  Framily
//
//  Created by Varun kumar on 21/07/23.
//

import UIKit
import CoreData

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
        
        printSavedData()
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
        
        // Add tap gesture recognizer to the transparent overlay view
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
            @objc func handleTap() {
                // Dismiss the keyboard when the user taps on the transparent overlay
                view.endEditing(true)
                // Dismiss the pop-up view
                if let currentPopUpView = currentPopUpView {
                    dismissPopUpView(currentPopUpView)
                }
            }

            // Function to show the pop-up view
    func showPopUpView(_ popUpView: UIView) {
        // Dismiss any currently visible pop-up views
        if let currentPopUpView = currentPopUpView {
            dismissPopUpView(currentPopUpView)
        }
        currentPopUpView = popUpView
        
        // Make the transparent overlay visible when the pop-up is shown
        signUpUserPopUp?.alpha = 1
        
        UIView.animate(withDuration: 0.3) {
            popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
        }
    }
            // Function to dismiss the pop-up view
            func dismissPopUpView(_ popUpView: UIView) {
                // Hide the transparent overlay when the pop-up is dismissed
                signUpUserPopUp?.alpha = 0

                UIView.animate(withDuration: 0.3) {
                    popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 200)
                }
                currentPopUpView = nil
            }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer)
{
   
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
   /* func showPopUpView(_ popUpView: UIView) {
        // Dismiss any currently visible pop-up views
        if let currentPopUpView = currentPopUpView {
            dismissPopUpView(currentPopUpView)
        }
        currentPopUpView = popUpView

        UIView.animate(withDuration: 0.3) {
            popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
        }
    }

    func dismissPopUpView(_ popUpView: UIView) {
        UIView.animate(withDuration: 0.3) {
            popUpView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 200)
        }
        currentPopUpView = nil
    }*/

    @IBAction func showPopUpButtonTapped(_ sender: UIButton) {
       if sender == signUpUserBtn {
            // Show pop-up view 1
            showPopUpView(signUpUserPopUp)
        }
    }
        @IBAction func dismissPopUpButtonTapped(_ sender: UIButton) {
          if sender.superview == signUpUserPopUp {
                // Dismiss pop-up view 1
                dismissPopUpView(signUpUserPopUp)
            }
        }
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {

        guard let signinInput = groupNameTxt.text, !signinInput.isEmpty
        else {
            showCustomAlertWith(message: "Please enter your groupName", descMsg: "")

            return
       }
    }
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
        signUpUser(groupName: groupName, userName: userName, password: password)
    }

    private func verifyPassword(_ password: String, storedHash: String?) -> Bool {
        return password == storedHash
    }
    
    
    func signUpUser(groupName: String, userName: String, password: String) {
        let apiURL = URL(string: "http://192.168.29.7:8080/usernameLogin")!
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
                DispatchQueue.main.async {
                    self.showCustomAlertWith(message: "Network Error", descMsg: "There was a network error. Please check your connection and try again.")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                if let responseData = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                        print("Response: \(jsonObject)")
                        
                        if let responseDict = jsonObject as? [String: Any] {
                            if let success = responseDict["success"] as? Bool, success {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "signinToOtp", sender: nil)
                                }
                            } else if let errorMessage = responseDict["errorMessage"] as? String {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Server Error", descMsg: errorMessage)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showCustomAlertWith(message: "Server Error", descMsg: "An unknown error occurred.")
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showCustomAlertWith(message: "Server Error", descMsg: "An unknown error occurred.")
                            }
                        }
                    } catch {
                        print("Error parsing response data: \(error)")
                        DispatchQueue.main.async {
                            self.showCustomAlertWith(message: "Server Error", descMsg: "An error occurred while processing the response.")
                        }
                    }
                }
            } else {
                print("Invalid HTTP response: \(response?.description ?? "")")
                DispatchQueue.main.async {
                    self.showCustomAlertWith(message: "Server Error", descMsg: "An unknown error occurred.")
                }
            }
        }
        
        task.resume()
        print("Sending signup request to API...")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewController" {
            // Disable all buttons after the segue from EmailOTPViewController
            loginBtn.isEnabled = false
            signUpUserBtn.isEnabled = false
            forgotPasswordBtn.isEnabled = false
            loginWithEmailPhoneBtn.isEnabled = false
        }
    }
    func printSavedData() {
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
    }
    

}
