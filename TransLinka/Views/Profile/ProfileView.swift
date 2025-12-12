//
//  ProfileView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showSettings = false
    @State private var showPaymentMethods = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Profile Header
                    VStack(spacing: Theme.spacingMedium) {
                        Circle()
                            .fill(Theme.primaryBlue.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(authViewModel.currentUser?.fullName.prefix(1).uppercased() ?? "U")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(Theme.primaryBlue)
                            )
                        
                        Text(authViewModel.currentUser?.fullName ?? "User")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(authViewModel.currentUser?.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.top, Theme.spacingLarge)
                    .fadeIn()
                    
                    // Menu Items
                    VStack(spacing: Theme.spacingSmall) {
                        ProfileMenuItem(
                            icon: "calendar",
                            title: "My Bookings",
                            color: Theme.primaryBlue
                        ) {
                            // Navigate to bookings
                        }
                        
                        ProfileMenuItem(
                            icon: "creditcard",
                            title: "Payment Methods",
                            color: Theme.accentGreen
                        ) {
                            showPaymentMethods = true
                        }
                        
                        ProfileMenuItem(
                            icon: "gearshape.fill",
                            title: "Settings",
                            color: Theme.textSecondary
                        ) {
                            showSettings = true
                        }
                        
                        ProfileMenuItem(
                            icon: "questionmark.circle.fill",
                            title: "Help Center",
                            color: Theme.accentOrange
                        ) {
                            // Navigate to help
                        }
                        
                        ProfileMenuItem(
                            icon: "arrow.right.square.fill",
                            title: "Logout",
                            color: Theme.accentRed
                        ) {
                            authViewModel.signOut()
                        }
                    }
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.vertical, Theme.spacingMedium)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showPaymentMethods) {
                PaymentMethodsView()
            }
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.spacingMedium) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.textSecondary)
                    .font(.caption)
            }
            .padding()
            .cardStyle()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel())
}

