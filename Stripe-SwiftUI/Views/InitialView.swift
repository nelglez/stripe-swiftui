//
//  InititalView.swift
//  Stripe-SwiftUI
//
//  Created by Nelson Gonzalez on 4/13/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import SwiftUI

struct InitialView: View {
    @ObservedObject var aboutYouViewModel = AboutYouViewModel()
    @ObservedObject var paymentContextDelegate = PaymentContextDelegate()
      func listen() {
       
        //MARK: - uncomment the line below to test as a brand new user
     //   UserDefaults.standard.set(nil, forKey: "Customer")
        
        //MARK: - Check to see if there is a registered user or not
        aboutYouViewModel.isRegisteredUser()
          
      }
      
      var body: some View {
         NavigationView {
          Group {
              
            if aboutYouViewModel.isRegistered {
                //MARK: - if the user is registered then proceed to the shopping/checkout page
                ShoppingView(paymentContextDelegate: self.paymentContextDelegate)
              } else {
                //MARK: - if the user is not registered then take him to the login/signup view
                ContentView(aboutYouViewModel: self.aboutYouViewModel)
              }

              
          }.onAppear {
            //MARK: - check to see if the user is registered or not in our app.
              self.listen()
             
          }
        }
      }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
