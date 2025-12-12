//
//  AdminViewModel.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation
import SwiftUI

@MainActor
class AdminViewModel: ObservableObject {
    @Published var totalBookings: Int = 0
    @Published var totalUsers: Int = 0
    @Published var totalRoutes: Int = 0
    @Published var totalRevenue: Double = 0.0
    @Published var recentBookings: [Booking] = []
    @Published var buses: [Bus] = []
    @Published var routes: [Route] = []
    @Published var isLoading = false
    
    private let bookingService = BookingService.shared
    
    init() {
        loadDashboardData()
        loadBuses()
        loadRoutes()
    }
    
    func loadDashboardData() {
        // Calculate statistics
        let allBookings = bookingService.getAllBookings()
        totalBookings = allBookings.count
        totalRevenue = allBookings.reduce(0) { $0 + $1.totalPrice }
        recentBookings = Array(allBookings.suffix(10))
        
        // In production, these would come from API
        totalUsers = 150
        totalRoutes = bookingService.getAllRoutes().count
    }
    
    func loadBuses() {
        // Load buses from service
        buses = [
            Bus(busNumber: "BUS-001", capacity: 50, status: .active, model: "Mercedes", amenities: ["WiFi", "AC", "USB"]),
            Bus(busNumber: "BUS-002", capacity: 50, status: .active, model: "Volvo", amenities: ["WiFi", "AC"]),
            Bus(busNumber: "BUS-003", capacity: 50, status: .maintenance, model: "Mercedes", amenities: ["WiFi", "AC", "USB", "Reclining"])
        ]
    }
    
    func loadRoutes() {
        routes = bookingService.getAllRoutes()
    }
    
    func deleteRoute(_ route: Route) {
        routes.removeAll { $0.id == route.id }
    }
    
    func deleteBus(_ bus: Bus) {
        buses.removeAll { $0.id == bus.id }
    }
}

extension BookingService {
    func getAllBookings() -> [Booking] {
        // In production, this would fetch from API
        return []
    }
}

