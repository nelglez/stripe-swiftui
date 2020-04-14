//
//  ShoppingView.swift
//  Stripe-SwiftUI
//
//  Created by Nelson Gonzalez on 4/13/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import SwiftUI
import Stripe

 

struct ShoppingView: View {
    @ObservedObject var paymentContextDelegate: PaymentContextDelegate
    let config = STPPaymentConfiguration.shared()
    @State private var paymentContext: STPPaymentContext!
    let customerContext = STPCustomerContext(keyProvider: MyAPIClient())
    
    let price = 20
    
    private let stripeCreditCartCut = 0.029
    private let flatFeeCents = 30


    var subtotal: Int {
        var amount = 0
        
        let priceToPennies = Int(price * 100)
        amount += priceToPennies

        
        return amount
    }

    var processingFees: Int {
        if subtotal == 0 {
            return 0
        }
        let sub = Double(subtotal)
        let feesAndSubtotal = Int(sub * stripeCreditCartCut) + flatFeeCents
        return feesAndSubtotal
    }

    var total: Int {
        return subtotal + processingFees
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image("cake").resizable().frame(width: 150, height: 150).cornerRadius(30)
            Text("Chocolate Cake").font(.title)
            Text("$\(price).00").foregroundColor(.green)
            
            //MARK: - present the payment options VC (to enter CC info) CC means credit card.
            Button(action: {
               
                  self.paymentContext.presentPaymentOptionsViewController()
            }) {
               
                Text(self.paymentContextDelegate.paymentMethodButtonTitle)
            }
            
            //MARK: - If the user is new and has not selected a payment method yet, we dont show the Pay Now button until there is a CC on his account. CC means credit card.
            if self.paymentContextDelegate.paymentMethodButtonTitle != "Select Payment Method" {
            Button(action: {
                
                self.paymentContext.requestPayment()
            }) {
                Text("Pay Now").frame(width: UIScreen.main.bounds.width - 30, height: 50)
            }.foregroundColor(.white).background(Color.red).cornerRadius(10).padding(.top, 15)
            }
            
            Spacer()
            
        }.padding().navigationBarTitle("Order").onAppear {
         
            //MARK: - Start configuring the payment context as soon as the view appears
         
            self.paymentContextConfiguration()
            
            
            
            
        }.alert(isPresented: self.$paymentContextDelegate.showAlert) {
            Alert(title: Text(""), message: Text(self.paymentContextDelegate.message), dismissButton: .default(Text("OK")))
        }
    }
    
    //MARK: - Configuration
    
    func paymentContextConfiguration() {
        self.config.shippingType = .shipping
        self.config.requiredBillingAddressFields = .full
        
        self.config.requiredShippingAddressFields = [.postalAddress, .emailAddress]
        
        self.config.companyName = "Testing"
        
        self.paymentContext = STPPaymentContext(customerContext: customerContext, configuration: self.config, theme: .default())
        
        self.paymentContext.delegate = self.paymentContextDelegate
        
        let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
            .filter({$0.isKeyWindow}).first
        
        self.paymentContext.hostViewController = keyWindow?.rootViewController
        self.paymentContext.paymentAmount = self.total
    }
}

struct ShoppingView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingView(paymentContextDelegate: PaymentContextDelegate())
    }
}
