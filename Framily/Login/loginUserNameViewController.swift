//
//  signUpUser.swift
//  Framily
//
//  Created by Varun kumar on 21/07/23.
//

import UIKit
import CoreData

class loginUserNameViewController: UIViewController {

    @IBOutlet weak var loginInBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var signUpUserBtn: UIButton!
    @IBOutlet weak var groupNameTxt: UITextField!
    @IBOutlet weak var signUpUserPopUp: UIView!
    //var transparentOverlay: UIView?
    var iconClick = false
    let imageIcon = UIImageView()
    var currentPopUpView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
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

                      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {

                          return

                      }

                      

              let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

              fetchRequest.predicate = NSPredicate(format: "groupName == %@", groupName)


                      do {

                          let result = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)

                          let filteredUsers = result.compactMap { $0 as? User }.filter {

                              $0.groupName == groupName

                          }

                          

                          if let user = filteredUsers.first {

                              if user.password == password {

                                  performSegue(withIdentifier: "signinToOtp", sender: nil)

                              } else {

                                  showCustomAlertWith(message: "Incorrect password", descMsg: "")

                              }

                          } else {

                              showCustomAlertWith(message: "User Name and Group Name is not registered", descMsg: "")

                          }

                      } catch {

                          showCustomAlertWith(message: "An error occurred during login", descMsg: "")

                      }

                  }

}
