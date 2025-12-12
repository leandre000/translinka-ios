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
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Enhanced Profile Header
                    VStack(spacing: Theme.spacingMedium) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.primaryBlue, Theme.primaryBlueLight],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: Theme.primaryBlue.opacity(0.3), radius: 10)
                            
                            Text(authViewModel.currentUser?.fullName.prefix(1).uppercased() ?? "U")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .fadeIn()
                        
                        Text(authViewModel.currentUser?.fullName ?? "User")
                            .font(.title2)
                            .fontWeight(.bold)
                            .fadeIn()
                        
                        Text(authViewModel.currentUser?.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .fadeIn()
                    }
                    .padding(.top, Theme.spacingLarge)
                    
                    // Enhanced Menu Items
                    VStack(spacing: Theme.spacingSmall) {
                        ProfileMenuItem(
                            icon: "calendar",
                            title: "My Bookings",
                            color: Theme.primaryBlue,
                            badge: nil
                        ) {
                            // Navigate to bookings
                        }
                        
                        ProfileMenuItem(
                            icon: "creditcard",
                            title: "Payment Methods",
                            color: Theme.accentGreen,
                            badge: nil
                        ) {
                            showPaymentMethods = true
                        }
                        
                        ProfileMenuItem(
                            icon: "gearshape.fill",
                            title: "Settings",
                            color: Theme.textSecondary,
                            badge: nil
                        ) {
                            showSettings = true
                        }
                        
                        ProfileMenuItem(
                            icon: "questionmark.circle.fill",
                            title: "Help Center",
                            color: Theme.accentOrange,
                            badge: nil
                        ) {
                            // Navigate to help
                        }
                        
                        Divider()
                            .padding(.vertical, Theme.spacingSmall)
                        
                        ProfileMenuItem(
                            icon: "arrow.right.square.fill",
                            title: "Logout",
                            color: Theme.accentRed,
                            badge: nil
                        ) {
                            showLogoutConfirmation = true
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
            .alert("Logout", isPresented: $showLogoutConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    authViewModel.signOut()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    let badge: String?
    let action: () -> Void
    
    init(icon: String, title: String, color: Color, badge: String? = nil, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.color = color
        self.badge = badge
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.spacingMedium) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 20))
                }
                
                Text(title)
                    .foregroundColor(Theme.textPrimary)
                    .font(.body)
                
                Spacer()
                
                if let badge = badge {
                    Text(badge)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.accentRed)
                        .cornerRadius(12)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.textSecondary)
                    .font(.caption)
            }
            .padding()
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
            .shadow(color: Theme.shadowSmall.color, radius: Theme.shadowSmall.radius, x: Theme.shadowSmall.x, y: Theme.shadowSmall.y)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel())
}
