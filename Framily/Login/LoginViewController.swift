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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
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
