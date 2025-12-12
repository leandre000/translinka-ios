//
//  PassengerDetailsView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct PassengerDetailsView: View {
    let route: Route
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var passengerName = ""
    @State private var passengerEmail = ""
    @State private var passengerPhone = ""
    @State private var showPayment = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Header
                    VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                        Text("Passenger Details")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Please provide passenger information")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.top, Theme.spacingLarge)
                    
                    // Form
                    VStack(spacing: Theme.spacingMedium) {
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            Text("Full Name")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Enter passenger name", text: $passengerName)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Enter email", text: $passengerEmail)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            Text("Phone Number")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Enter phone number", text: $passengerPhone)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                    }
                    .padding(.horizontal, Theme.spacingLarge)
                    
                    // Booking Summary
                    VStack(spacing: Theme.spacingMedium) {
                        Text("Booking Summary")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(route.origin)
                                    .font(.subheadline)
                                Text(route.destination)
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(bookingViewModel.selectedSeats.count) seat(s)")
                                    .font(.subheadline)
                                Text("$\(route.price * Double(bookingViewModel.selectedSeats.count), specifier: "%.2f")")
                                    .font(.headline)
                                    .foregroundColor(Theme.primaryBlue)
                            }
                        }
                        
                        if !bookingViewModel.selectedSeats.isEmpty {
                            Text("Seats: \(bookingViewModel.selectedSeats.sorted().map { String($0) }.joined(separator: ", "))")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .cardStyle()
                    .padding(.horizontal, Theme.spacingLarge)
                    
                    // Continue Button
                    PrimaryButton(
                        title: "Continue to Payment",
                        action: { showPayment = true },
                        isDisabled: passengerName.isEmpty || !passengerEmail.isValidEmail || !passengerPhone.isValidPhone
                    )
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.bottom, Theme.spacingLarge)
                }
            }
            .navigationTitle("Passenger Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showPayment) {
                PaymentView(
                    route: route,
                    passengerName: passengerName,
                    passengerEmail: passengerEmail,
                    passengerPhone: passengerPhone
                )
            }
            .onAppear {
                if let user = authViewModel.currentUser {
                    passengerName = user.fullName
                    passengerEmail = user.email
                }
            }
        }
    }
}

#Preview {
    PassengerDetailsView(route: Route(
        origin: "New York",
        destination: "Boston",
        departureTime: Date(),
        arrivalTime: Date().addingTimeInterval(18000),
        price: 45.00,
        busNumber: "BUS-001",
        availableSeats: 30,
        totalSeats: 50
    ))
    .environmentObject(BookingViewModel())
    .environmentObject(AuthenticationViewModel())
}

