//
//  TicketDetailView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct TicketDetailView: View {
    let booking: Booking
    @State private var qrCodeImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingXLarge) {
                    // QR Code
                    if let qrImage = qrCodeImage {
                        VStack(spacing: Theme.spacingMedium) {
                            Image(uiImage: qrImage)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(Theme.cornerRadiusLarge)
                                .shadow(color: Theme.shadowLarge.color, radius: Theme.shadowLarge.radius)
                            
                            Text("Scan at boarding gate")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            Text("Valid for this trip only")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(.top, Theme.spacingLarge)
                    }
                    
                    // Ticket Details
                    if let route = booking.route {
                        VStack(spacing: Theme.spacingMedium) {
                            // Route
                            VStack(spacing: Theme.spacingSmall) {
                                Text(route.origin)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Image(systemName: "arrow.down")
                                    .font(.title3)
                                    .foregroundColor(Theme.primaryBlue)
                                
                                Text(route.destination)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, Theme.spacingMedium)
                            
                            Divider()
                            
                            // Details Grid - Use model computed properties for formatting
                            VStack(spacing: Theme.spacingMedium) {
                                DetailRow(icon: "calendar", label: "Date", value: route.departureTime.dateString)
                                DetailRow(icon: "clock", label: "Departure", value: route.departureTime.timeString)
                                DetailRow(icon: "clock.fill", label: "Arrival", value: route.arrivalTime.timeString)
                                DetailRow(icon: "person.2.fill", label: "Seats", value: booking.seatsString)
                                DetailRow(icon: "bus.fill", label: "Bus", value: route.busNumber)
                                DetailRow(icon: "person.fill", label: "Passenger", value: booking.passengerName)
                                DetailRow(icon: "dollarsign.circle.fill", label: "Amount", value: booking.totalPriceString)
                            }
                            
                            if let hash = booking.blockchainHash {
                                Divider()
                                
                                VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                                    HStack {
                                        Image(systemName: "link")
                                            .foregroundColor(Theme.primaryBlue)
                                        Text("Blockchain Hash")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    
                                    Text(hash)
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .cardStyle()
                        .padding(.horizontal, Theme.spacingLarge)
                    }
                    
                    // Actions
                    VStack(spacing: Theme.spacingMedium) {
                        PrimaryButton(
                            title: "Share Ticket",
                            action: {
                                // Share ticket functionality
                            }
                        )
                        
                        SecondaryButton(
                            title: "Validate with NFC",
                            action: {
                                // NFC validation functionality
                            }
                        )
                    }
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.bottom, Theme.spacingLarge)
                }
            }
            .navigationTitle("Ticket")
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

struct DetailRow: View {
    let icon: String
    let label: String
    let value: Any
    var style: Date.FormatStyle?
    
    init(icon: String, label: String, value: Any, style: Date.FormatStyle? = nil) {
        self.icon = icon
        self.label = label
        self.value = value
        self.style = style
    }
    
    var body: some View {
        HStack(spacing: Theme.spacingMedium) {
            Image(systemName: icon)
                .foregroundColor(Theme.primaryBlue)
                .frame(width: 24)
            
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
    TicketDetailView(booking: Booking(
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

