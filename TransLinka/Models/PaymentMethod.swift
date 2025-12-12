//
//  PaymentMethod.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

struct PaymentMethod: Identifiable, Codable {
    let id: String
    var type: PaymentType
    var cardNumber: String?
    var cardHolderName: String?
    var expiryDate: String?
    var cvv: String?
    var isDefault: Bool
    
    enum PaymentType: String, Codable, CaseIterable {
        case creditCard = "Credit/Debit Card"
        case paypal = "PayPal"
        case googlePay = "Google Pay"
        case applePay = "Apple Pay"
        case mobileMoney = "Mobile Money"
    }
    
    init(id: String = UUID().uuidString,
         type: PaymentType,
         cardNumber: String? = nil,
         cardHolderName: String? = nil,
         expiryDate: String? = nil,
         cvv: String? = nil,
         isDefault: Bool = false) {
        self.id = id
        self.type = type
        self.cardNumber = cardNumber
        self.cardHolderName = cardHolderName
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.isDefault = isDefault
    }
}

