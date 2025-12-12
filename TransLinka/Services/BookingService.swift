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
    
    /// Create a new booking with blockchain verification
    /// - Parameters:
    ///   - userId: User ID making the booking
    ///   - routeId: Selected route ID
    ///   - passengerName: Passenger full name
    ///   - passengerEmail: Passenger email
    ///   - passengerPhone: Passenger phone number
    ///   - selectedSeats: Array of selected seat numbers
    ///   - totalPrice: Total booking price
    /// - Returns: Created booking with blockchain hash
    /// - Throws: BookingError if route not found
    func createBooking(
        userId: String,
        routeId: String,
        passengerName: String,
        passengerEmail: String,
        passengerPhone: String,
        selectedSeats: [Int],
        totalPrice: Double
    ) async throws -> Booking {
        // Simulate blockchain transaction delay
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        guard let route = getRoute(by: routeId) else {
            throw BookingError.routeNotFound(ErrorMessages.routeNotFound)
        }
        
        // Generate blockchain hash for ticket security
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
    
    /// Generate a simulated blockchain hash for ticket verification
    /// In production, this would call the actual blockchain service
    private func generateBlockchainHash() -> String {
        return "0x\(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(64))"
    }
    
    private func loadSampleData() {
        let calendar = Calendar.current
        let now = Date()
        
        // Rwandan sample routes for demo/stakeholder previews
        routes = [
            Route(
                origin: "Kigali",
                destination: "Huye",
                departureTime: calendar.date(byAdding: .hour, value: 2, to: now) ?? now,
                arrivalTime: calendar.date(byAdding: .hour, value: 5, to: now) ?? now,
                price: 7000,
                busNumber: "VOLCANO-101",
                availableSeats: 22,
                totalSeats: 50
            ),
            Route(
                origin: "Kigali",
                destination: "Musanze",
                departureTime: calendar.date(byAdding: .hour, value: 4, to: now) ?? now,
                arrivalTime: calendar.date(byAdding: .hour, value: 7, to: now) ?? now,
                price: 8500,
                busNumber: "STELLA-202",
                availableSeats: 18,
                totalSeats: 50
            ),
            Route(
                origin: "Kigali",
                destination: "Rubavu",
                departureTime: calendar.date(byAdding: .day, value: 1, to: now) ?? now,
                arrivalTime: calendar.date(byAdding: .day, value: 1, to: now.addingTimeInterval(3 * 3600)) ?? now,
                price: 9500,
                busNumber: "VIRUNGA-303",
                availableSeats: 30,
                totalSeats: 50
            ),
            Route(
                origin: "Huye",
                destination: "Kigali",
                departureTime: calendar.date(byAdding: .day, value: 1, to: now) ?? now,
                arrivalTime: calendar.date(byAdding: .day, value: 1, to: now.addingTimeInterval(3 * 3600)) ?? now,
                price: 7000,
                busNumber: "HORIZON-404",
                availableSeats: 12,
                totalSeats: 50
            ),
            Route(
                origin: "Rusizi",
                destination: "Kigali",
                departureTime: calendar.date(byAdding: .day, value: 2, to: now) ?? now,
                arrivalTime: calendar.date(byAdding: .day, value: 2, to: now.addingTimeInterval(6 * 3600)) ?? now,
                price: 12000,
                busNumber: "TOWN-505",
                availableSeats: 35,
                totalSeats: 50
            )
        ]
        
        // Sample bookings to showcase different statuses in the UI
        if let r1 = routes.first,
           let r2 = routes.dropFirst().first,
           let r3 = routes.dropFirst(2).first {
            
            bookings = [
                Booking(
                    userId: "user-demo-1",
                    routeId: r1.id,
                    route: r1,
                    passengerName: "Alice Uwimana",
                    passengerEmail: "alice@example.com",
                    passengerPhone: "0780000001",
                    selectedSeats: [5, 6],
                    bookingDate: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
                    status: .confirmed,
                    totalPrice: r1.price * 2,
                    blockchainHash: generateBlockchainHash()
                ),
                Booking(
                    userId: "user-demo-2",
                    routeId: r2.id,
                    route: r2,
                    passengerName: "Jean Bosco",
                    passengerEmail: "jean@example.com",
                    passengerPhone: "0780000002",
                    selectedSeats: [12],
                    bookingDate: calendar.date(byAdding: .hour, value: -6, to: now) ?? now,
                    status: .pending,
                    totalPrice: r2.price,
                    blockchainHash: generateBlockchainHash()
                ),
                Booking(
                    userId: "user-demo-3",
                    routeId: r3.id,
                    route: r3,
                    passengerName: "Claudine Iradukunda",
                    passengerEmail: "claudine@example.com",
                    passengerPhone: "0780000003",
                    selectedSeats: [20, 21, 22],
                    bookingDate: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
                    status: .completed,
                    totalPrice: r3.price * 3,
                    blockchainHash: generateBlockchainHash()
                ),
                Booking(
                    userId: "user-demo-4",
                    routeId: r1.id,
                    route: r1,
                    passengerName: "Eric Niyonzima",
                    passengerEmail: "eric@example.com",
                    passengerPhone: "0780000004",
                    selectedSeats: [30],
                    bookingDate: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                    status: .cancelled,
                    totalPrice: r1.price,
                    blockchainHash: generateBlockchainHash()
                )
            ]
        }
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

