//
//  RouteComparisonView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct RouteComparisonView: View {
    let routes: [Route]
    @State private var selectedRoute: Route?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingMedium) {
                    ForEach(routes) { route in
                        ComparisonRouteCard(
                            route: route,
                            isSelected: selectedRoute?.id == route.id
                        ) {
                            selectedRoute = route
                        }
                    }
                    
                    if let route = selectedRoute {
                        Button("Book This Route") {
                            // Navigate to booking
                        }
                        .primaryButtonStyle()
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Compare Routes")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ComparisonRouteCard: View {
    let route: Route
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                // Route Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(route.origin) → \(route.destination)")
                            .font(.headline)
                        
                        Text(route.departureTime, style: .time)
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.accentGreen)
                            .font(.title2)
                    }
                }
                
                Divider()
                
                // Comparison Metrics
                HStack(spacing: Theme.spacingLarge) {
                    ComparisonMetric(
                        icon: "clock",
                        label: "Duration",
                        value: formatDuration(route.duration)
                    )
                    
                    ComparisonMetric(
                        icon: "dollarsign.circle.fill",
                        label: "Price",
                        value: "$\(route.price, specifier: "%.2f")"
                    )
                    
                    ComparisonMetric(
                        icon: "person.2.fill",
                        label: "Seats",
                        value: "\(route.availableSeats)"
                    )
                }
            }
            .padding()
            .background(isSelected ? Theme.primaryBlue.opacity(0.1) : Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .stroke(isSelected ? Theme.primaryBlue : Color.clear, lineWidth: 2)
            )
        }
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
}

struct ComparisonMetric: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(Theme.primaryBlue)
                .font(.title3)
            
            Text(value)
                .font(.headline)
            
            Text(label)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

