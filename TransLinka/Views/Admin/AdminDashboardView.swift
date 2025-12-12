//
//  AdminDashboardView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct AdminDashboardView: View {
    @EnvironmentObject var adminViewModel: AdminViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.spacingMedium) {
                        StatCard(title: "Total Bookings", value: "\(adminViewModel.totalBookings)", icon: "calendar", color: Theme.primaryBlue)
                        StatCard(title: "Total Users", value: "\(adminViewModel.totalUsers)", icon: "person.2.fill", color: Theme.accentGreen)
                        StatCard(title: "Total Routes", value: "\(adminViewModel.totalRoutes)", icon: "map.fill", color: Theme.accentOrange)
                        StatCard(title: "Total Revenue", value: "$\(adminViewModel.totalRevenue, specifier: "%.2f")", icon: "dollarsign.circle.fill", color: Theme.accentGreen)
                    }
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.top, Theme.spacingMedium)
                    
                    // Recent Bookings
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("Recent Bookings")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal, Theme.spacingLarge)
                        
                        if adminViewModel.recentBookings.isEmpty {
                            Text("No recent bookings")
                                .foregroundColor(Theme.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(adminViewModel.recentBookings) { booking in
                                AdminBookingRow(booking: booking)
                                    .padding(.horizontal, Theme.spacingLarge)
                            }
                        }
                    }
                    .padding(.vertical, Theme.spacingMedium)
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                adminViewModel.loadDashboardData()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Spacer()
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

struct AdminBookingRow: View {
    let booking: Booking
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if let route = booking.route {
                    Text("\(route.origin) → \(route.destination)")
                        .font(.headline)
                }
                
                Text(booking.passengerName)
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
        .padding()
        .cardStyle()
    }
}

#Preview {
    AdminDashboardView()
        .environmentObject(AdminViewModel())
}

