//
//  BookingViewModel.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation
import SwiftUI

/// ViewModel managing booking-related state and operations
@MainActor
class BookingViewModel: ObservableObject {
    @Published var routes: [Route] = []
    @Published var bookings: [Booking] = []
    @Published var selectedRoute: Route?
    @Published var selectedSeats: [Int] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let bookingService = BookingService.shared
    
    init() {
        loadRoutes()
        loadBookings()
    }
    
    /// Load all available routes from service
    func loadRoutes() {
        routes = bookingService.getAllRoutes()
    }
    
    /// Load user's bookings from service
    func loadBookings() {
        if let userId = AuthenticationService.shared.getCurrentUser()?.id {
            bookings = bookingService.getBookings(for: userId)
        }
    }
    
    /// Search routes by origin, destination, and date
    func searchRoutes(origin: String, destination: String, date: Date) {
        isLoading = true
        routes = bookingService.searchRoutes(origin: origin, destination: destination, date: date)
        isLoading = false
    }
    
    /// Select a route for booking
    func selectRoute(_ route: Route) {
        selectedRoute = route
    }
    
    /// Toggle seat selection (add if not selected, remove if selected)
    func toggleSeat(_ seatNumber: Int) {
        if selectedSeats.contains(seatNumber) {
            selectedSeats.removeAll { $0 == seatNumber }
        } else {
            selectedSeats.append(seatNumber)
        }
    }
    
    /// Create a new booking with blockchain verification
    /// - Returns: Created booking or nil if error
    func createBooking(
        route: Route,
        passengerName: String,
        passengerEmail: String,
        passengerPhone: String,
        seats: [Int]
    ) async -> Booking? {
        guard let userId = AuthenticationService.shared.getCurrentUser()?.id else {
            errorMessage = ErrorMessages.authenticationRequired
            return nil
        }
        
        isLoading = true
        errorMessage = nil
        
        let totalPrice = route.price * Double(seats.count)
        
        do {
            let booking = try await bookingService.createBooking(
                userId: userId,
                routeId: route.id,
                passengerName: passengerName,
                passengerEmail: passengerEmail,
                passengerPhone: passengerPhone,
                selectedSeats: seats,
                totalPrice: totalPrice
            )
            
            selectedSeats = []
            loadBookings()
            isLoading = false
            return booking
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return nil
        }
    }
}

