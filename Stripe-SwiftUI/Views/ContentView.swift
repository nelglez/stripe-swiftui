//
//  ContentView.swift
//  Stripe-SwiftUI
//
//  Created by Nelson Gonzalez on 4/13/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var aboutYouViewModel: AboutYouViewModel
    
    var body: some View {
        
        VStack {
            Text("SwiftUI Stripe").font(.largeTitle)
            
            Text("About you:").font(.title)
            
            TextField("Full name", text: $aboutYouViewModel.fullName).padding().background(Color("Color")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.top, 1)
            
            TextField("124567890", text: $aboutYouViewModel.phoneNumber, onEditingChanged:  { changed in
    
                self.aboutYouViewModel.phoneNumber =  self.aboutYouViewModel.phoneNumber.toPhoneNumber()
                
            }).keyboardType(.phonePad).padding().background(Color("Color")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.top, 1)
            
            TextField("Email Address", text: $aboutYouViewModel.email).keyboardType(.emailAddress).padding().background(Color("Color")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.top, 1)
            
            
            Button(action: {
                if self.aboutYouViewModel.fullName.isEmpty, self.aboutYouViewModel.phoneNumber.isEmpty, self.aboutYouViewModel.email.isEmpty {
                    //trigger alert
                    print("please complete all fields.")
                    self.aboutYouViewModel.showAlert = true
                    self.aboutYouViewModel.errorString = "Please complete all fields to continue."
                    return
                } else {
                    MyAPIClient.createCustomer(email: self.aboutYouViewModel.email, phone: self.aboutYouViewModel.phoneNumber, name: self.aboutYouViewModel.fullName, onSuccess: {
                        print("Successfully registered new user.")
                    
                        //MARK: - We need to trigger isRegistered so we can take the user to the shopping page of our app.
                        
                        self.aboutYouViewModel.isRegisteredUser()
                    }) { (error) in
                        self.aboutYouViewModel.showAlert = true
                        self.aboutYouViewModel.errorString = error.localizedDescription
                    }
                }
            }) {
                Text("Continue to app").frame(width: UIScreen.main.bounds.width - 30, height: 50)
            }.foregroundColor(.white).background(Color.orange).cornerRadius(10).padding(.top, 15).alert(isPresented: self.$aboutYouViewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(self.aboutYouViewModel.errorString), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
            
            }.padding().navigationBarTitle("Stripe SwiftUI")
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(aboutYouViewModel: AboutYouViewModel())
    }
}
