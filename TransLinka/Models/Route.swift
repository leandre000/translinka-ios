//
//  Route.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

struct Route: Identifiable, Codable, Hashable {
    let id: String
    var origin: String
    var destination: String
    var departureTime: Date
    var arrivalTime: Date
    var price: Double
    var busNumber: String
    var availableSeats: Int
    var totalSeats: Int
    /// Calculate route duration in seconds
    var duration: TimeInterval {
        arrivalTime.timeIntervalSince(departureTime)
    }
    
    /// Format duration as readable string
    var durationString: String {
        Date.formatDuration(duration)
    }
    
    /// Format price as currency
    var priceString: String {
        price.currencyString
    }
    
    init(id: String = UUID().uuidString, 
         origin: String, 
         destination: String, 
         departureTime: Date, 
         arrivalTime: Date, 
         price: Double, 
         busNumber: String, 
         availableSeats: Int, 
         totalSeats: Int) {
        self.id = id
        self.origin = origin
        self.destination = destination
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.price = price
        self.busNumber = busNumber
        self.availableSeats = availableSeats
        self.totalSeats = totalSeats
    }
}

// MARK: - Route Location Extensions
extension Route {
    /// Get departure location coordinates from origin city name
    var departureLocation: CLLocationCoordinate2D? {
        return LocationService.shared.rwandanCities.first { $0.name == origin }?.coordinate
    }
    
    /// Get arrival location coordinates from destination city name
    var arrivalLocation: CLLocationCoordinate2D? {
        return LocationService.shared.rwandanCities.first { $0.name == destination }?.coordinate
    }
}

