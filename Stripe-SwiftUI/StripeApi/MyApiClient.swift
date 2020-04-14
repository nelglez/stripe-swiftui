//
//  MyApiClient.swift
//  Stripe-SwiftUI
//
//  Created by Nelson Gonzalez on 4/13/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import Foundation
import Stripe
class MyAPIClient: NSObject,STPCustomerEphemeralKeyProvider {
    
    #warning("Please use your own backend url below")
    static let baseUrl = "https://yourWebsite.com/StripeBackend/"

    
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        //MARK: - Retrive customer that was saved on registering on the app.
        guard let customer = UserDefaults.standard.value(forKey: "Customer") as? String else {
            print("NO CUSTOMER SAVED")
            return
        }
        
        let createCustomerEndPoint = URL(string: MyAPIClient.baseUrl + "empheralkey.php")
        
        guard let url = createCustomerEndPoint else {
            print("The url is not valid.")
            return
        }
        
        let body = "api_version=\(apiVersion)&customer=\(customer)"
        
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
    
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server Error!")
                completion(nil, NSError(domain: "empherakey.php",
                    code: 100,
                userInfo: [NSLocalizedDescriptionKey: "Something went wrong"]))
                return
            }
            
            guard let data = data else {
                print("There is no data returned from request")
                completion(nil, NSError())
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as! [String : Any]
                // print(json)
                print(json)
                
                completion(json, nil)
                
                
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion(nil, NSError())
                return
            }
            
        }.resume()
    }
    
    //MARK: - STEP 1. Create customer.

    class func createCustomer(email: String, phone: String, name: String, onSuccess: @escaping() -> Void, onError: @escaping(Error) -> Void){
        
        let createCustomerEndPoint = URL(string: baseUrl + "createCustomer.php")
        
        guard let url = createCustomerEndPoint else {
            print("The url is not valid.")
            return
        }
        
        let body = "email=\(email.lowercased())&phone=\(phone)&name=\(name)"
        
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
     
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                onError(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server Error!")
                return
            }
            
            guard let data = data else {
                print("There is no data returned from request")
                onError(NSError())
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as! [String : Any]
                // print(json)
                print(json)
                guard let customerId = json["id"] as? String else {
                    print("Could not retrieve customerId")
                    return
                    
                }
                
                //MARK: - Save the new customer ID in our app. We will need this customerid later on.
                print("CustomerId: \(customerId)")
                UserDefaults.standard.set(customerId, forKey: "Customer")
                onSuccess()
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
                onError(error)
                return
            }
            
        }.resume()
        
    }
 
    class func createPaymentIntent(amount: Int, currency: String, customerId: String, completion:@escaping (String) -> Void) {
        
        
    
        let createCustomerEndPoint = URL(string: MyAPIClient.baseUrl + "createpaymentintent.php")
        
        guard let url = createCustomerEndPoint else {
            print("The url is not valid.")
            return
        }
        
        let body = "amount=\(amount)&currency=\(currency)&customerId=\(customerId)"
        
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
  
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server Error!")
                completion("Server Response Error!")
                return
            }
            
            guard let data = data else {
                print("There is no data returned from request")
                completion("There is no data returned from request")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : String]
                // print(json)
                print(json!)
                guard let clientSecret = json?["clientSecret"] else { return }
                
                completion(clientSecret)
                
                
                
            } catch {
                print("JSON error: \(error)")
                completion(error.localizedDescription)
                return
            }
            
        }.resume()
        
    }
}
