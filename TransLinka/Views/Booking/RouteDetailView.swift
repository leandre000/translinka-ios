//
//  RouteDetailView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct RouteDetailView: View {
    let route: Route
    @State private var showSeatSelection = false
    
    var durationString: String {
        let hours = Int(route.duration) / 3600
        let minutes = (Int(route.duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacingLarge) {
                // Route Info Card
                VStack(spacing: Theme.spacingMedium) {
                    // Origin and Destination
                    HStack(alignment: .top, spacing: Theme.spacingLarge) {
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            Text("From")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                            
                            Text(route.origin)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(route.departureTime, style: .time)
                                .font(.headline)
                                .foregroundColor(Theme.primaryBlue)
                            
                            Text(route.departureTime, style: .date)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Image(systemName: "arrow.right")
                                .font(.title)
                                .foregroundColor(Theme.primaryBlue)
                                .padding(.top, Theme.spacingLarge)
                            
                            Text(durationString)
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: Theme.spacingSmall) {
                            Text("To")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                            
                            Text(route.destination)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(route.arrivalTime, style: .time)
                                .font(.headline)
                                .foregroundColor(Theme.primaryBlue)
                            
                            Text(route.arrivalTime, style: .date)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    
                    Divider()
                    
                    // Additional Info
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Bus Number")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                            Text(route.busNumber)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Available Seats")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                            Text("\(route.availableSeats)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Theme.accentGreen)
                        }
                    }
                }
                .padding()
                .cardStyle()
                .padding(.horizontal, Theme.spacingLarge)
                
                // Price
                HStack {
                    Text("Price per seat")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("$\(route.price, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.primaryBlue)
                }
                .padding()
                .cardStyle()
                .padding(.horizontal, Theme.spacingLarge)
                
                // Select Seats Button
                Button(action: {
                    showSeatSelection = true
                }) {
                    Text("Select Seats")
                        .primaryButtonStyle()
                }
                .padding(.horizontal, Theme.spacingLarge)
            }
            .padding(.vertical, Theme.spacingLarge)
        }
        .navigationTitle("Route Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSeatSelection) {
            SeatSelectionView(route: route)
        }
    }
}

#Preview {
    NavigationView {
        RouteDetailView(route: Route(
            origin: "New York",
            destination: "Boston",
            departureTime: Date(),
            arrivalTime: Date().addingTimeInterval(18000),
            price: 45.00,
            busNumber: "BUS-001",
            availableSeats: 30,
            totalSeats: 50
        ))
    }
}

