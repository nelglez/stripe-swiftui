//
//  AboutYouViewModel.swift
//  Stripe-SwiftUI
//
//  Created by Nelson Gonzalez on 4/13/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import Foundation
import SwiftUI


class AboutYouViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var showAlert = false
    @Published var errorString = ""
    @Published var isRegistered = false
    
    func isRegisteredUser() {
       let user = UserDefaults.standard.value(forKey: "Customer") as? String
        if user != nil {
            DispatchQueue.main.async {
                self.isRegistered = true
            }
            
        } else {
            DispatchQueue.main.async {
                self.isRegistered = false
            }
        }
    }
}
