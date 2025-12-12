//
//  BookingsView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct BookingsView: View {
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @State private var selectedFilter: BookingFilter = .all
    
    enum BookingFilter: String, CaseIterable {
        case all = "All"
        case upcoming = "Upcoming"
        case past = "Past"
    }
    
    var filteredBookings: [Booking] {
        let now = Date()
        switch selectedFilter {
        case .all:
            return bookingViewModel.bookings
        case .upcoming:
            return bookingViewModel.bookings.filter { booking in
                booking.route?.departureTime ?? Date() > now
            }
        case .past:
            return bookingViewModel.bookings.filter { booking in
                booking.route?.departureTime ?? Date() <= now
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Tabs
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(BookingFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Bookings List
                if filteredBookings.isEmpty {
                    EmptyStateView(
                        icon: "calendar.badge.exclamationmark",
                        title: "No bookings found",
                        message: "You don't have any \(selectedFilter.rawValue.lowercased()) bookings yet"
                    )
                } else {
                    List {
                        ForEach(filteredBookings) { booking in
                            NavigationLink(destination: TicketDetailView(booking: booking)) {
                                BookingRowView(booking: booking)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Bookings")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                bookingViewModel.loadBookings()
            }
        }
    }
}

struct BookingRowView: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
            if let route = booking.route {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(route.origin) → \(route.destination)")
                            .font(.headline)
                        
                        Text(route.departureTime, style: .date)
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(booking.totalPrice, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(Theme.primaryBlue)
                        
                        StatusBadge(status: booking.status)
                    }
                }
                
                HStack {
                    Label("\(booking.selectedSeats.count) seat(s)", systemImage: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    
                    Spacer()
                    
                    Text(route.departureTime.timeString)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .padding(.vertical, Theme.spacingSmall)
    }
}

// StatusBadge is now in Views/Components/StatusBadge.swift
// Import it from there

#Preview {
    BookingsView()
        .environmentObject(BookingViewModel())
}

