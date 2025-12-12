//
//  BookingService.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

class BookingService {
    static let shared = BookingService()
    
    private var routes: [Route] = []
    private var bookings: [Booking] = []
    
    private init() {
        loadSampleData()
    }
    
    func getAllRoutes() -> [Route] {
        return routes
    }
    
    func searchRoutes(origin: String, destination: String, date: Date) -> [Route] {
        return routes.filter { route in
            route.origin.localizedCaseInsensitiveContains(origin) &&
            route.destination.localizedCaseInsensitiveContains(destination) &&
            Calendar.current.isDate(route.departureTime, inSameDayAs: date)
        }
    }
    
    func getRoute(by id: String) -> Route? {
        return routes.first { $0.id == id }
    }
    
    func getBookings(for userId: String) -> [Booking] {
        return bookings.filter { $0.userId == userId }
    }
    
    func createBooking(
        userId: String,
        routeId: String,
        passengerName: String,
        passengerEmail: String,
        passengerPhone: String,
        selectedSeats: [Int],
        totalPrice: Double
    ) async throws -> Booking {
        // Simulate blockchain transaction
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        guard let route = getRoute(by: routeId) else {
            throw BookingError.routeNotFound
        }
        
        // Generate blockchain hash (simulated)
        let blockchainHash = generateBlockchainHash()
        
        let booking = Booking(
            userId: userId,
            routeId: routeId,
            route: route,
            passengerName: passengerName,
            passengerEmail: passengerEmail,
            passengerPhone: passengerPhone,
            selectedSeats: selectedSeats,
            status: .confirmed,
            totalPrice: totalPrice,
            blockchainHash: blockchainHash
        )
        
        bookings.append(booking)
        return booking
    }
    
    private func generateBlockchainHash() -> String {
        return "0x\(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(64))"
    }
    
    private func loadSampleData() {
        let calendar = Calendar.current
        let now = Date()
        
        routes = [
            Route(
                origin: "New York",
                destination: "Boston",
                departureTime: calendar.date(byAdding: .hour, value: 2, to: now) ?? now,
                arrivalTime: calendar.date(byAdding: .hour, value: 5, to: now) ?? now,
                price: 45.00,
                busNumber: "BUS-001",
                availableSeats: 30,
                totalSeats: 50
            ),
            Route(
                origin: "New York",
                destination: "Philadelphia",
                departureTime: calendar.date(byAdding: .hour, value: 3, to: now) ?? now,
                arrivalTime: calendar.date(byAdding: .hour, value: 6, to: now) ?? now,
                price: 35.00,
                busNumber: "BUS-002",
                availableSeats: 25,
                totalSeats: 50
            ),
            Route(
                origin: "Boston",
                destination: "New York",
                departureTime: calendar.date(byAdding: .hour, value: 4, to: now) ?? now,
                arrivalTime: calendar.date(byAdding: .hour, value: 7, to: now) ?? now,
                price: 45.00,
                busNumber: "BUS-003",
                availableSeats: 40,
                totalSeats: 50
            )
        ]
    }
    
    enum BookingError: LocalizedError {
        case routeNotFound
        
        var errorDescription: String? {
            switch self {
            case .routeNotFound:
                return "Route not found"
            }
        }
    }
}

