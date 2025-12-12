//
//  AdminTabView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct AdminTabView: View {
    @StateObject private var adminViewModel = AdminViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AdminDashboardView()
                .environmentObject(adminViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "chart.bar.fill" : "chart.bar")
                    Text("Dashboard")
                }
                .tag(0)
            
            AdminRoutesView()
                .environmentObject(adminViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "map.fill" : "map")
                    Text("Routes")
                }
                .tag(1)
            
            AdminBusesView()
                .environmentObject(adminViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "bus.fill" : "bus")
                    Text("Buses")
                }
                .tag(2)
            
            AdminBookingsView()
                .environmentObject(adminViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "calendar.fill" : "calendar")
                    Text("Bookings")
                }
                .tag(3)
        }
        .accentColor(Theme.primaryBlue)
    }
}

#Preview {
    AdminTabView()
}

