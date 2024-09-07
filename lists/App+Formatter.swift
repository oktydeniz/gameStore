//
//  App+Formatter.swift
//  lists
//
//  Created by oktay on 30.08.2024.
//

import Foundation


struct AppFormatter {
    
    static let dollarFormatter: NumberFormatter = {
        let ff = NumberFormatter()
         ff.numberStyle = .currency
         ff.currencySymbol = "$"
         ff.currencyCode = "USD"
         ff.minimumFractionDigits = 0
         ff.maximumFractionDigits = 2
         return ff
     }()
}
