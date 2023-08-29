//
//  OrganizationalDetailsViewController.swift
//  Framily
//
//  Created by Varun kumar on 25/08/23.
//

import UIKit

class OrganizationalDetailsViewController: UIViewController, URLSessionDelegate {

    @IBOutlet weak var organizationalNameTxt: UITextField!
    @IBOutlet weak var businessLocationTxt: UITextField!
    @IBOutlet weak var stateOrProvinceTxt: UITextField!
    @IBOutlet weak var currencyTxt: UITextField!
    @IBOutlet weak var timeZoneTxt: UITextField!
    @IBOutlet weak var languageTxt: UITextField!
    @IBOutlet weak var inventoryStartDateTxt: UITextField!
    @IBOutlet weak var fiscalYearTxt: UITextField!
    @IBOutlet weak var GSTIDTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        guard let organizationalName = organizationalNameTxt.text, !organizationalName.isEmpty else {
            showCustomAlertWith(message: "Please enter organizationalName", descMsg: "")
            return
        }
        
        guard let businessLocation = businessLocationTxt.text, !businessLocation.isEmpty else {
            showCustomAlertWith(message: "Please enter businessLocation", descMsg: "")
            return
        }
        
        guard let stateOrProvince = stateOrProvinceTxt.text, !stateOrProvince.isEmpty else {
            showCustomAlertWith(message: "Please enter stateOrProvince", descMsg: "")
            return
        }
        guard let GSTID = GSTIDTxt.text else {
            return
        }
        guard let currency = currencyTxt.text, !currency.isEmpty else {
            showCustomAlertWith(message: "Please enter currency", descMsg: "")
            return
        }
        
        guard let timeZone = timeZoneTxt.text, !timeZone.isEmpty else {
            showCustomAlertWith(message: "Please enter timeZone", descMsg: "")
            return
        }
        
        guard let language = languageTxt.text, !language.isEmpty else {
            showCustomAlertWith(message: "Please enter language", descMsg: "")
            return
        }
        guard let inventoryStartDate = inventoryStartDateTxt.text, !inventoryStartDate.isEmpty else {
            showCustomAlertWith(message: "Please enter inventoryStartDate", descMsg: "")
            return
        }
        
        guard let fiscalYear = fiscalYearTxt.text, !fiscalYear.isEmpty else {
            showCustomAlertWith(message: "Please enter fiscalYear", descMsg: "")
            return
        }
        print("Sending signup request to API...")
        organizationalDetailsAPI(organizationalName: organizationalName, businessLocation: businessLocation, stateOrProvince: stateOrProvince, GSTID: GSTID, currency: currency, timeZone: timeZone, language: language, inventoryStartDate: inventoryStartDate, fiscalYear: fiscalYear)
        
    }
   func organizationalDetailsAPI(organizationalName: String, businessLocation: String, stateOrProvince: String, GSTID: String,currency: String, timeZone: String, language: String, inventoryStartDate: String, fiscalYear: String) {
     let apiURL = URL(string: "http://192.168.29.7:8082/OrganizationDetails")!
 
 var request = URLRequest(url: apiURL)
 request.httpMethod = "POST"
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     
     let currentDate = Date()
     let dateFormatter = ISO8601DateFormatter()
     let formattedDate = dateFormatter.string(from: currentDate)
 
 let parameters: [String: Any] = [
     "organizationalName": organizationalName,
     "businessLocation": businessLocation,
     "stateOrProvince": stateOrProvince,
     "GSTID": GSTID,
     "currency": currency,
     "timeZone": timeZone,
     "language": language,
     "inventoryStartDate": inventoryStartDate,
     "fiscalYear": fiscalYear
     
 ]

     do {
         let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
         request.httpBody = jsonData
     } catch {
         print("Error creating request body: \(error)")
         return
     }
     let credentials = "arun:arun1"
     let credentialsData = credentials.data(using: .utf8)!
     let base64Credentials = credentialsData.base64EncodedString()
     request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
     
     let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
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
                                 self.performSegue(withIdentifier: "detailsToHome", sender: nil)
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
                           
                                 
                                 let jsonObject = try JSONSerialization.jsonObject(with: responseData/*decryptedData*/, options: [])
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
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
           if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)

                if(errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let cert1 = NSData(bytes: data, length: size)
                        let file_der = Bundle.main.path(forResource: "aarthy", ofType: "cer")

                        if let file = file_der {
                            if let cert2 = NSData(contentsOfFile: file) {
                                if cert1.isEqual(to: cert2 as Data) {
                                    print("SSL Pinning Successful")
                                    
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
