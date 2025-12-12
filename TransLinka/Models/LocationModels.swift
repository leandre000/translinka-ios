//
//  LocationModels.swift
//  TransLinka
//
//  Location-related data models
//

import Foundation
import CoreLocation

/// City model for Rwandan cities
struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

/// Bus stop location model
struct BusStopLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let city: String
}

/// Bus location for real-time tracking
struct BusLocation: Identifiable {
    let id = UUID()
    let busNumber: String
    let coordinate: CLLocationCoordinate2D
    let speed: Double // km/h
    let heading: Double // degrees
    let timestamp: Date
}

/// Next stop information
struct NextStop {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let distance: Double // meters
    let eta: TimeInterval // seconds
}

