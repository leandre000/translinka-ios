//
//  BookingViewModel.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation
import SwiftUI

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
    
    func loadRoutes() {
        routes = bookingService.getAllRoutes()
    }
    
    func loadBookings() {
        if let userId = AuthenticationService.shared.getCurrentUser()?.id {
            bookings = bookingService.getBookings(for: userId)
        }
    }
    
    func searchRoutes(origin: String, destination: String, date: Date) {
        isLoading = true
        routes = bookingService.searchRoutes(origin: origin, destination: destination, date: date)
        isLoading = false
    }
    
    func selectRoute(_ route: Route) {
        selectedRoute = route
    }
    
    func toggleSeat(_ seatNumber: Int) {
        if selectedSeats.contains(seatNumber) {
            selectedSeats.removeAll { $0 == seatNumber }
        } else {
            selectedSeats.append(seatNumber)
        }
    }
    
    func createBooking(
        route: Route,
        passengerName: String,
        passengerEmail: String,
        passengerPhone: String,
        seats: [Int]
    ) async -> Booking? {
        guard let userId = AuthenticationService.shared.getCurrentUser()?.id else {
            errorMessage = "User not authenticated"
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

