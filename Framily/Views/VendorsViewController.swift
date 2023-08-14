//
//  ViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by Varun kumar on 19/06/23.
//

/*import UIKit
import CoreData

class VendorsViewController: UIViewController {
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var categeryTxt: UITextField!
    @IBOutlet weak var ageTxt: UITextField!
    @IBOutlet weak var storeNameTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        navigationController?.navigationBar.tintColor = .white
        
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let category = categeryTxt.text, !category.isEmpty,
              let age = ageTxt.text, !age.isEmpty,
              let storeName = storeNameTxt.text, !storeName.isEmpty,
              let name = nameTxt.text, !name.isEmpty else {
           
            showCustomAlertWith(message: "Empty Fields", descMsg: "Please fill in all the fields.")
            return
        }
        
        
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Vendor", in: context)!
        let vendor = NSManagedObject(entity: entity, insertInto: context)
        
        vendor.setValue(category, forKey: "category")
        vendor.setValue(age, forKey: "age")
        vendor.setValue(storeName, forKey: "storeName")
        vendor.setValue(name, forKey: "name")
        
        do {
            try context.save()
            print("Data saved successfully!")
           
            
            categeryTxt.text = ""
            ageTxt.text = ""
            storeNameTxt.text = ""
            nameTxt.text = ""
            
            
        } catch {
            print("Failed to save data: \(error)")
           
        }
    }
    
}*/
