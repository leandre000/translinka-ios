//
//  Booking.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

struct Booking: Identifiable, Codable {
    let id: String
    let userId: String
    let routeId: String
    var route: Route?
    let passengerName: String
    let passengerEmail: String
    let passengerPhone: String
    let selectedSeats: [Int]
    let bookingDate: Date
    var status: BookingStatus
    let totalPrice: Double
    let qrCode: String
    let blockchainHash: String?
    
    enum BookingStatus: String, Codable {
        case pending = "Pending"
        case confirmed = "Confirmed"
        case cancelled = "Cancelled"
        case completed = "Completed"
    }
    
    init(id: String = UUID().uuidString,
         userId: String,
         routeId: String,
         route: Route? = nil,
         passengerName: String,
         passengerEmail: String,
         passengerPhone: String,
         selectedSeats: [Int],
         bookingDate: Date = Date(),
         status: BookingStatus = .pending,
         totalPrice: Double,
         qrCode: String = UUID().uuidString,
         blockchainHash: String? = nil) {
        self.id = id
        self.userId = userId
        self.routeId = routeId
        self.route = route
        self.passengerName = passengerName
        self.passengerEmail = passengerEmail
        self.passengerPhone = passengerPhone
        self.selectedSeats = selectedSeats
        self.bookingDate = bookingDate
        self.status = status
        self.totalPrice = totalPrice
        self.qrCode = qrCode
        self.blockchainHash = blockchainHash
    }
}

