//
//  AdminBookingsView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct AdminBookingsView: View {
    @EnvironmentObject var adminViewModel: AdminViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(adminViewModel.recentBookings) { booking in
                    NavigationLink(destination: AdminBookingDetailView(booking: booking)) {
                        AdminBookingRow(booking: booking)
                    }
                }
            }
            .navigationTitle("All Bookings")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                adminViewModel.loadDashboardData()
            }
        }
    }
}

struct AdminBookingDetailView: View {
    let booking: Booking
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.spacingLarge) {
                if let route = booking.route {
                    DetailSection(title: "Route", value: "\(route.origin) → \(route.destination)")
                    DetailSection(title: "Date", value: route.departureTime.dateString)
                    DetailSection(title: "Time", value: route.departureTime.timeString)
                }
                
                DetailSection(title: "Passenger", value: booking.passengerName)
                DetailSection(title: "Email", value: booking.passengerEmail)
                DetailSection(title: "Phone", value: booking.passengerPhone)
                DetailSection(title: "Seats", value: booking.seatsString)
                DetailSection(title: "Total Price", value: booking.totalPriceString)
                DetailSection(title: "Status", value: booking.status.rawValue)
                DetailSection(title: "Booking ID", value: booking.id)
                
                if let hash = booking.blockchainHash {
                    DetailSection(title: "Blockchain Hash", value: hash)
                }
            }
            .padding()
        }
        .navigationTitle("Booking Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AdminBookingsView()
        .environmentObject(AdminViewModel())
}

