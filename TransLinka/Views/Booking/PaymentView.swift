//
//  PaymentView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct PaymentView: View {
    let route: Route
    let passengerName: String
    let passengerEmail: String
    let passengerPhone: String
    
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPaymentMethod: PaymentMethod.PaymentType = .creditCard
    @State private var cardNumber = ""
    @State private var cardHolderName = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var showBookingConfirmation = false
    @State private var confirmedBooking: Booking?
    
    var totalPrice: Double {
        route.price * Double(bookingViewModel.selectedSeats.count)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Payment Method Selection
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("Select Payment Method")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(PaymentMethod.PaymentType.allCases, id: \.self) { method in
                            Button(action: {
                                selectedPaymentMethod = method
                            }) {
                                HStack {
                                    Image(systemName: iconForPaymentType(method))
                                        .foregroundColor(Theme.primaryBlue)
                                    
                                    Text(method.rawValue)
                                        .foregroundColor(Theme.textPrimary)
                                    
                                    Spacer()
                                    
                                    if selectedPaymentMethod == method {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Theme.primaryBlue)
                                    }
                                }
                                .padding()
                                .background(selectedPaymentMethod == method ? Theme.primaryBlue.opacity(0.1) : Color.gray.opacity(0.1))
                                .cornerRadius(Theme.cornerRadiusMedium)
                            }
                        }
                    }
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.top, Theme.spacingLarge)
                    
                    // Payment Details (for Credit Card)
                    if selectedPaymentMethod == .creditCard {
                        VStack(spacing: Theme.spacingMedium) {
                            VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                                Text("Card Number")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                TextField("1234 5678 9012 3456", text: $cardNumber)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            
                            VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                                Text("Card Holder Name")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                TextField("John Doe", text: $cardHolderName)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            HStack(spacing: Theme.spacingMedium) {
                                VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                                    Text("Expiry Date")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)
                                    
                                    TextField("MM/YY", text: $expiryDate)
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .keyboardType(.numberPad)
                                }
                                
                                VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                                    Text("CVV")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)
                                    
                                    TextField("123", text: $cvv)
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .keyboardType(.numberPad)
                                }
                            }
                        }
                        .padding(.horizontal, Theme.spacingLarge)
                    }
                    
                    // Total Amount - Display formatted currency
                    VStack(spacing: Theme.spacingSmall) {
                        HStack {
                            Text("Total Amount")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(totalPriceString)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.primaryBlue)
                        }
                    }
                    .padding()
                    .cardStyle()
                    .padding(.horizontal, Theme.spacingLarge)
                    
                    // Pay Button - Process payment and create booking
                    PrimaryButton(
                        title: "Pay \(totalPriceString)",
                        action: {
                            Task {
                                if let booking = await bookingViewModel.createBooking(
                                    route: route,
                                    passengerName: passengerName,
                                    passengerEmail: passengerEmail,
                                    passengerPhone: passengerPhone,
                                    seats: bookingViewModel.selectedSeats
                                ) {
                                    confirmedBooking = booking
                                    showBookingConfirmation = true
                                }
                            }
                        },
                        isLoading: bookingViewModel.isLoading,
                        isDisabled: selectedPaymentMethod == .creditCard && (cardNumber.isEmpty || cardHolderName.isEmpty || expiryDate.isEmpty || cvv.isEmpty)
                    )
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.bottom, Theme.spacingLarge)
                }
            }
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showBookingConfirmation) {
                if let booking = confirmedBooking {
                    BookingConfirmationView(booking: booking)
                }
            }
        }
    }
    
    private func iconForPaymentType(_ type: PaymentMethod.PaymentType) -> String {
        switch type {
        case .creditCard: return "creditcard.fill"
        case .paypal: return "p.circle.fill"
        case .googlePay: return "g.circle.fill"
        case .applePay: return "applelogo"
        case .mobileMoney: return "phone.fill"
        }
    }
}

#Preview {
    PaymentView(
        route: Route(
            origin: "New York",
            destination: "Boston",
            departureTime: Date(),
            arrivalTime: Date().addingTimeInterval(18000),
            price: 45.00,
            busNumber: "BUS-001",
            availableSeats: 30,
            totalSeats: 50
        ),
        passengerName: "John Doe",
        passengerEmail: "john@example.com",
        passengerPhone: "1234567890"
    )
    .environmentObject(BookingViewModel())
}

