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
    
    /// Booking status enumeration
    enum BookingStatus: String, Codable {
        case pending = "Pending"
        case confirmed = "Confirmed"
        case cancelled = "Cancelled"
        case completed = "Completed"
        
        /// Status badge color
        var color: Color {
            switch self {
            case .confirmed: return Theme.accentGreen
            case .pending: return Theme.accentOrange
            case .cancelled: return Theme.accentRed
            case .completed: return Theme.primaryBlue
            }
        }
    }
    
    /// Format total price as currency
    var totalPriceString: String {
        totalPrice.currencyString
    }
    
    /// Format selected seats as comma-separated string
    var seatsString: String {
        selectedSeats.sorted().map { String($0) }.joined(separator: ", ")
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

