//
//  Bus.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

struct Bus: Identifiable, Codable {
    let id: String
    var busNumber: String
    var capacity: Int
    var status: BusStatus
    var model: String
    var amenities: [String]
    
    enum BusStatus: String, Codable {
        case active = "Active"
        case maintenance = "Maintenance"
        case inactive = "Inactive"
    }
    
    init(id: String = UUID().uuidString,
         busNumber: String,
         capacity: Int,
         status: BusStatus = .active,
         model: String = "",
         amenities: [String] = []) {
        self.id = id
        self.busNumber = busNumber
        self.capacity = capacity
        self.status = status
        self.model = model
        self.amenities = amenities
    }
}

