//
//  BookingConfirmationView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct BookingConfirmationView: View {
    let booking: Booking
    @Environment(\.dismiss) var dismiss
    @State private var qrCodeImage: UIImage?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingXLarge) {
                    // Success Icon
                    ZStack {
                        Circle()
                            .fill(Theme.accentGreen.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.accentGreen)
                    }
                    .padding(.top, Theme.spacingXLarge)
                    .fadeIn()
                    
                    // Confirmation Text
                    VStack(spacing: Theme.spacingSmall) {
                        Text("Booking Confirmed!")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Your ticket has been secured on the blockchain")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .fadeIn()
                    
                    // QR Code
                    if let qrImage = qrCodeImage {
                        VStack(spacing: Theme.spacingMedium) {
                            Image(uiImage: qrImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(Theme.cornerRadiusLarge)
                                .shadow(color: Theme.shadowMedium.color, radius: Theme.shadowMedium.radius)
                            
                            Text("Scan this QR code at boarding")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        .fadeIn()
                    }
                    
                    // Booking Details
                    VStack(spacing: Theme.spacingMedium) {
                        if let route = booking.route {
                            BookingDetailRow(label: "Route", value: "\(route.origin) → \(route.destination)")
                            BookingDetailRow(label: "Date", value: route.departureTime, style: .dateTime.day().month().year())
                            BookingDetailRow(label: "Time", value: route.departureTime, style: .dateTime.hour().minute())
                            BookingDetailRow(label: "Seats", value: booking.seatsString)
                            BookingDetailRow(label: "Passenger", value: booking.passengerName)
                        }
                        
                        BookingDetailRow(label: "Booking ID", value: booking.id)
                        
                        if let hash = booking.blockchainHash {
                            VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                                Text("Blockchain Hash")
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                                
                                Text(hash)
                                    .font(.caption)
                                    .foregroundColor(Theme.primaryBlue)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .cardStyle()
                    .padding(.horizontal, Theme.spacingLarge)
                    
                    // Actions - Use reusable button components
                    VStack(spacing: Theme.spacingMedium) {
                        PrimaryButton(
                            title: "View Ticket",
                            action: { dismiss() }
                        )
                        
                        SecondaryButton(
                            title: "Done",
                            action: { dismiss() }
                        )
                    }
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.bottom, Theme.spacingLarge)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                generateQRCode()
            }
        }
    }
    
    private func generateQRCode() {
        let qrString = "TransLinka:\(booking.id):\(booking.qrCode)"
        qrCodeImage = QRCodeService.shared.generateQRCode(from: qrString)
    }
}

struct BookingDetailRow: View {
    let label: String
    let value: Any
    var style: Date.FormatStyle?
    
    init(label: String, value: Any, style: Date.FormatStyle? = nil) {
        self.label = label
        self.value = value
        self.style = style
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
            
            if let date = value as? Date, let style = style {
                Text(date.formatted(style))
                    .font(.subheadline)
                    .fontWeight(.medium)
            } else {
                Text("\(value)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
}

#Preview {
    BookingConfirmationView(booking: Booking(
        userId: "user1",
        routeId: "route1",
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
        passengerPhone: "1234567890",
        selectedSeats: [1, 2],
        totalPrice: 90.00,
        blockchainHash: "0x1234567890abcdef"
    ))
}

