//
//  SeatSelectionView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct SeatSelectionView: View {
    let route: Route
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedSeats: Set<Int> = []
    @State private var showPassengerDetails = false
    
    var totalPrice: Double {
        route.price * Double(selectedSeats.count)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacingLarge) {
                // Seat Map
                ScrollView {
                    VStack(spacing: Theme.spacingMedium) {
                        // Legend
                        HStack(spacing: Theme.spacingLarge) {
                            HStack(spacing: Theme.spacingSmall) {
                                Rectangle()
                                    .fill(Theme.accentGreen)
                                    .frame(width: 20, height: 20)
                                    .cornerRadius(4)
                                Text("Available")
                                    .font(.caption)
                            }
                            
                            HStack(spacing: Theme.spacingSmall) {
                                Rectangle()
                                    .fill(Theme.primaryBlue)
                                    .frame(width: 20, height: 20)
                                    .cornerRadius(4)
                                Text("Selected")
                                    .font(.caption)
                            }
                            
                            HStack(spacing: Theme.spacingSmall) {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 20, height: 20)
                                    .cornerRadius(4)
                                Text("Occupied")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        
                        // Bus Layout
                        VStack(spacing: Theme.spacingSmall) {
                            // Driver area
                            HStack {
                                Image(systemName: "steeringwheel")
                                    .foregroundColor(Theme.textSecondary)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            // Seats (2-3-2 configuration)
                            ForEach(0..<10) { row in
                                HStack(spacing: Theme.spacingSmall) {
                                    // Left side (2 seats)
                                    SeatView(seatNumber: row * 7 + 1, selectedSeats: $selectedSeats, route: route)
                                    SeatView(seatNumber: row * 7 + 2, selectedSeats: $selectedSeats, route: route)
                                    
                                    Spacer()
                                    
                                    // Middle (3 seats)
                                    SeatView(seatNumber: row * 7 + 3, selectedSeats: $selectedSeats, route: route)
                                    SeatView(seatNumber: row * 7 + 4, selectedSeats: $selectedSeats, route: route)
                                    SeatView(seatNumber: row * 7 + 5, selectedSeats: $selectedSeats, route: route)
                                    
                                    Spacer()
                                    
                                    // Right side (2 seats)
                                    SeatView(seatNumber: row * 7 + 6, selectedSeats: $selectedSeats, route: route)
                                    SeatView(seatNumber: row * 7 + 7, selectedSeats: $selectedSeats, route: route)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                }
                
                // Summary and Continue
                VStack(spacing: Theme.spacingMedium) {
                    if !selectedSeats.isEmpty {
                        HStack {
                            Text("Selected: \(selectedSeats.sorted().map { String($0) }.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            Spacer()
                            
                            Text("Total: $\(totalPrice, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(Theme.primaryBlue)
                        }
                        .padding(.horizontal)
                    }
                    
                    PrimaryButton(
                        title: selectedSeats.isEmpty ? "Select Seats to Continue" : "Continue",
                        action: {
                            bookingViewModel.selectedSeats = Array(selectedSeats)
                            showPassengerDetails = true
                        },
                        isDisabled: selectedSeats.isEmpty
                    )
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Theme.cardBackground)
            }
            .navigationTitle("Select Seats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showPassengerDetails) {
                PassengerDetailsView(route: route)
            }
        }
    }
}

struct SeatView: View {
    let seatNumber: Int
    @Binding var selectedSeats: Set<Int>
    let route: Route
    
    var isSelected: Bool {
        selectedSeats.contains(seatNumber)
    }
    
    var isOccupied: Bool {
        // Simulate some occupied seats
        seatNumber % 3 == 0 || seatNumber > route.totalSeats - route.availableSeats
    }
    
    var body: some View {
        Button(action: {
            if !isOccupied {
                if isSelected {
                    selectedSeats.remove(seatNumber)
                } else {
                    selectedSeats.insert(seatNumber)
                }
            }
        }) {
            Text("\(seatNumber)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : (isOccupied ? Theme.textSecondary : Theme.textPrimary))
                .frame(width: 35, height: 35)
                .background(isSelected ? Theme.primaryBlue : (isOccupied ? Color.gray.opacity(0.3) : Theme.accentGreen.opacity(0.3)))
                .cornerRadius(6)
        }
        .disabled(isOccupied)
    }
}

#Preview {
    SeatSelectionView(route: Route(
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
}

