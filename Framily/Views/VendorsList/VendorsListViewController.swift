//
//  MoviesViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/9/21.
//

import UIKit
import CoreData

class VendorsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var vendors: [Vendor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchVendors()
    }
    
   
    func fetchVendors() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Vendor> = Vendor.fetchRequest()
        
        do {
            vendors = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch vendors: \(error)")
        }
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Vendorslist", for: indexPath) as! VendorsListTableViewCell
        
        let vendor = vendors[indexPath.row]
        cell.vendorsListLbl.text = vendor.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVendor = vendors[indexPath.row]
      
        let name = selectedVendor.name ?? "N/A"
        let age = selectedVendor.age ?? "N/A"
        let storeName = selectedVendor.storeName ?? "N/A"
        let category = selectedVendor.category ?? "N/A"
        
  
        let alert = UIAlertController(title: "Vendor Details", message: "Name: \(name)\nAge: \(age)\nStore Name: \(storeName)\nCategory: \(category)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
