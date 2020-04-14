//
//  MyView.swift
//  Stripe-SwiftUI
//
//  Created by Nelson Gonzalez on 4/13/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import SwiftUI

extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}


