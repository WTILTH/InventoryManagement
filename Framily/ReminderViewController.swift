//
//  ReminderViewController.swift
//  
//
//  Created by Varun kumar on 21/06/23.
//

import UIKit
//import Firebase
import CoreLocation
import UserNotifications

struct Location {
    let latitude: Double
    let longitude: Double
    let name: String
    let address: String
}

class ReminderViewController: UIViewController, CLLocationManagerDelegate {

   // let locationManager = CLLocationManager()
   // var databaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
     /*   view.backgroundColor = BackgroundManager.shared.backgroundColor
        databaseRef = Database.database().reference()

       
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        startMonitoringLocations()
        
        let location1 = Location(latitude: 9.910390, longitude: 78.147861, name: "Theppakulam", address: "Madurai")
        let location2 = Location(latitude: 9.926559, longitude: 78.159659, name: "House1", address: "Madurai")
        let location3 = Location(latitude: 9.928419, longitude: 78.161751, name: "House2", address: "Madurai")
        let location4 = Location(latitude: 9.926237, longitude: 78.157312, name: "Canara Bank", address: "Madurai")

        // Store location1
        databaseRef.child("locations").childByAutoId().setValue([
            "latitude": location1.latitude,
            "longitude": location1.longitude,
            "name": location1.name,
            "address": location1.address
        ])

        
        databaseRef.child("locations").childByAutoId().setValue([
            "latitude": location2.latitude,
            "longitude": location2.longitude,
            "name": location2.name,
            "address": location2.address
        ])

        
        databaseRef.child("locations").childByAutoId().setValue([
            "latitude": location3.latitude,
            "longitude": location3.longitude,
            "name": location3.name,
            "address": location3.address
        ])

 
        databaseRef.child("locations").childByAutoId().setValue([
            "latitude": location4.latitude,
            "longitude": location4.longitude,
            "name": location4.name,
            "address": location4.address
        ])
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let location = getLocation(from: region) {
            // Get the topmost view controller
            guard let topmostViewController = UIApplication.shared.keyWindow?.rootViewController?.topmostViewController else {
                return
            }
            
            // Show the custom alert on the topmost view controller
            topmostViewController.showCustomAlertWith(message: "You reached \(location.name)", descMsg: "", actions: nil)
            
            showNotification(message: "You reached \(location.name)")
        }
    }

    private func getLocation(from region: CLRegion) -> Location? {
        // Retrieve the location from the database using the region.identifier
        // Return the corresponding Location object if found, otherwise return nil
        // Implement your database retrieval logic here
        return nil
    }


    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
    
    func showNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Location Alert"
        content.body = message
        
        let request = UNNotificationRequest(identifier: "LocationNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func startMonitoringLocation(location: Location) {
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), radius: 100, identifier: location.name)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        locationManager.startMonitoring(for: region)
        
        // Check proximity to location
        let currentLocation = locationManager.location
        let locationCoordinate = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let distance = currentLocation?.distance(from: locationCoordinate)
        
        if let distance = distance, distance <= region.radius {
            showCustomAlertWith(message: "You are near \(location.name)", descMsg: "", actions: nil)
            
            showNotification(message: "You reached \(location.name)")
        }
    }
    
    func startMonitoringLocations() {
        databaseRef.child("locations").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let locationsDict = snapshot.value as? [String: Any] else { return }
            for locationDict in locationsDict.values {
                if let locationData = locationDict as? [String: Any],
                   let latitude = locationData["latitude"] as? Double,
                   let longitude = locationData["longitude"] as? Double,
                   let name = locationData["name"] as? String,
                   let address = locationData["address"] as? String {
                    let location = Location(latitude: latitude, longitude: longitude, name: name, address: address)
                    self?.startMonitoringLocation(location: location)
                }
            }
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            startMonitoringLocations()
        }
    }
}
extension UIViewController {
    var topmostViewController: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topmostViewController
        }
        
        if let navigationViewController = self as? UINavigationController {
            return navigationViewController.visibleViewController?.topmostViewController ?? navigationViewController
        }
        
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topmostViewController ?? tabBarController
        }
        
        return self*/
    }
    
    
    
    //
    
    
    
    
    //
    //
    
    
    
    
}
