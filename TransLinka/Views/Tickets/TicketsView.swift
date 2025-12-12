//
//  TicketsView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct TicketsView: View {
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @State private var selectedBooking: Booking?
    
    var upcomingBookings: [Booking] {
        let now = Date()
        return bookingViewModel.bookings.filter { booking in
            booking.route?.departureTime ?? Date() > now && booking.status == .confirmed
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if upcomingBookings.isEmpty {
                    VStack(spacing: Theme.spacingMedium) {
                        Image(systemName: "ticket.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Theme.textSecondary)
                        
                        Text("No active tickets")
                            .font(.headline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, Theme.spacingXLarge)
                } else {
                    LazyVStack(spacing: Theme.spacingLarge) {
                        ForEach(upcomingBookings) { booking in
                            TicketCard(booking: booking)
                                .onTapGesture {
                                    selectedBooking = booking
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("My Tickets")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedBooking) { booking in
                TicketDetailView(booking: booking)
            }
            .onAppear {
                bookingViewModel.loadBookings()
            }
        }
    }
}

struct TicketCard: View {
    let booking: Booking
    @State private var qrCodeImage: UIImage?
    
    var body: some View {
        VStack(spacing: Theme.spacingMedium) {
            if let route = booking.route {
                // Route Info
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(route.origin)
                            .font(.headline)
                        
                        Image(systemName: "arrow.down")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                        
                        Text(route.destination)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(route.departureTime, style: .time)
                            .font(.headline)
                            .foregroundColor(Theme.primaryBlue)
                        
                        Text(route.departureTime, style: .date)
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                Divider()
                
                // QR Code
                if let qrImage = qrCodeImage {
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(Theme.cornerRadiusMedium)
                }
                
                // Booking Details
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Seats: \(booking.selectedSeats.sorted().map { String($0) }.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                        
                        Text(booking.passengerName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Text("View Ticket")
                        .font(.subheadline)
                        .foregroundColor(Theme.primaryBlue)
                }
            }
        }
        .padding()
        .cardStyle()
        .onAppear {
            generateQRCode()
        }
    }
    
    private func generateQRCode() {
        let qrString = "TransLinka:\(booking.id):\(booking.qrCode)"
        qrCodeImage = QRCodeService.shared.generateQRCode(from: qrString)
    }
}

#Preview {
    TicketsView()
        .environmentObject(BookingViewModel())
}

