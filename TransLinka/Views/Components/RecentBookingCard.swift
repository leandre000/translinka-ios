//
//  RecentBookingCard.swift
//  TransLinka
//
//  Recent booking card component for HomeView
//

import SwiftUI

/// Card displaying recent booking information
struct RecentBookingCard: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
            if let route = booking.route {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(route.origin)
                            .font(.headline)
                        
                        Image(systemName: "arrow.down")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                        
                        Text(route.destination)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(route.departureTime.timeString)
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        Text(route.priceString)
                            .font(.headline)
                            .foregroundColor(Theme.primaryBlue)
                    }
                }
                
                HStack {
                    Label("\(booking.selectedSeats.count) seat(s)", systemImage: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    
                    Spacer()
                    
                    StatusBadge(status: booking.status)
                }
            }
        }
        .padding()
        .frame(width: 200)
        .cardStyle()
    }
}

