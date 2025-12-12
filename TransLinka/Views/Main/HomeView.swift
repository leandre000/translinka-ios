//
//  HomeView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @State private var searchText = ""
    @State private var showSearchResults = false
    @State private var selectedDate = Date()
    
    var userName: String {
        authViewModel.currentUser?.fullName.components(separatedBy: " ").first ?? "User"
    }
    
    var recentBookings: [Booking] {
        Array(bookingViewModel.bookings.prefix(3))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Welcome Section
                    VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                        Text("Welcome Back, \(userName)!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                            .fadeIn()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.top, Theme.spacingMedium)
                    
                    // Search Bar
                    VStack(spacing: Theme.spacingSmall) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Where are you going?", text: $searchText)
                                .onSubmit {
                                    if !searchText.isEmpty {
                                        showSearchResults = true
                                    }
                                }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(Theme.cornerRadiusMedium)
                    }
                    .padding(.horizontal, Theme.spacingLarge)
                    .slideIn(from: .down)
                    
                    // Recent Bookings
                    if !recentBookings.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                            HStack {
                                Text("Recent Bookings")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                NavigationLink("See All", destination: BookingsView())
                                    .font(.subheadline)
                                    .foregroundColor(Theme.primaryBlue)
                            }
                            .padding(.horizontal, Theme.spacingLarge)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Theme.spacingMedium) {
                                    ForEach(recentBookings) { booking in
                                        RecentBookingCard(booking: booking)
                                    }
                                }
                                .padding(.horizontal, Theme.spacingLarge)
                            }
                        }
                        .padding(.vertical, Theme.spacingMedium)
                    }
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("Quick Actions")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal, Theme.spacingLarge)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.spacingMedium) {
                            NavigationLink(destination: MapView()) {
                                QuickActionCard(
                                    icon: "map.fill",
                                    title: "Map & Bus Stops",
                                    color: Theme.primaryBlue
                                ) {}
                            }
                            
                            NavigationLink(destination: RwandanLocationsView()) {
                                QuickActionCard(
                                    icon: "mappin.circle.fill",
                                    title: "Rwandan Locations",
                                    color: Theme.accentGreen
                                ) {}
                            }
                            
                            QuickActionCard(
                                icon: "qrcode.viewfinder",
                                title: "Scan Ticket",
                                color: Theme.primaryBlueDark
                            ) {
                                // Navigate to QR scanner
                            }
                            
                            NavigationLink(destination: ARNavigationView()) {
                                QuickActionCard(
                                    icon: "arkit",
                                    title: "AR Navigation",
                                    color: Theme.accentOrange
                                ) {}
                            }
                            
                            NavigationLink(destination: ChatView()) {
                                QuickActionCard(
                                    icon: "message.fill",
                                    title: "Chat Support",
                                    color: Theme.accentGreen
                                ) {}
                            }
                            
                            QuickActionCard(
                                icon: "magnifyingglass",
                                title: "Find Routes",
                                color: Theme.primaryBlue
                            ) {
                                showSearchResults = true
                            }
                        }
                        .padding(.horizontal, Theme.spacingLarge)
                    }
                    .padding(.vertical, Theme.spacingMedium)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ChatView()) {
                        Image(systemName: "message.fill")
                            .foregroundColor(Theme.primaryBlue)
                    }
                }
            }
            .sheet(isPresented: $showSearchResults) {
                RouteSearchView(searchText: searchText)
            }
        }
    }
}

struct RecentBookingCard: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
            if let route = booking.route {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(route.origin)
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)
                        
                        Image(systemName: "arrow.down")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                        
                        Text(route.destination)
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)
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
            }
            
            Text(booking.bookingDate, style: .date)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .padding()
        .frame(width: 200)
        .cardStyle()
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.spacingSmall) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .cardStyle()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(BookingViewModel())
}

