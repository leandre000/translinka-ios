//
//  User.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var fullName: String
    var email: String
    var isAdmin: Bool
    
    init(id: String = UUID().uuidString, fullName: String, email: String, isAdmin: Bool = false) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.isAdmin = isAdmin
    }
}

