//
//  MainTabView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            BookingsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "calendar.fill" : "calendar")
                    Text("Bookings")
                }
                .tag(1)
            
            TicketsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "ticket.fill" : "ticket")
                    Text("Tickets")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(Theme.primaryBlue)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(BookingViewModel())
}

