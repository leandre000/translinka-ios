//
//  RouteSearchView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct RouteSearchView: View {
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var origin = ""
    @State private var destination = ""
    @State private var selectedDate = Date()
    let searchText: String
    
    init(searchText: String = "") {
        self.searchText = searchText
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacingLarge) {
                // Search Form
                VStack(spacing: Theme.spacingMedium) {
                    VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                        Text("Origin")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        TextField("From", text: $origin)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                        Text("Destination")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        TextField("To", text: $destination)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                        Text("Date")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(Theme.cornerRadiusMedium)
                    }
                    
                    PrimaryButton(
                        title: "Search Routes",
                        action: {
                            bookingViewModel.searchRoutes(origin: origin, destination: destination, date: selectedDate)
                        },
                        isDisabled: origin.isEmpty || destination.isEmpty
                    )
                    .padding(.top, Theme.spacingMedium)
                }
                .padding()
                
                // Results
                if !bookingViewModel.routes.isEmpty {
                    List {
                        ForEach(bookingViewModel.routes) { route in
                            NavigationLink(destination: RouteDetailView(route: route)) {
                                RouteRowView(route: route)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else if !origin.isEmpty && !destination.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "No routes found",
                        message: "We couldn't find any routes for your search. Try different locations or dates."
                    )
                }
            }
            .navigationTitle("Search Routes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if !searchText.isEmpty {
                    let components = searchText.components(separatedBy: " to ")
                    if components.count == 2 {
                        origin = components[0].trimmingCharacters(in: .whitespaces)
                        destination = components[1].trimmingCharacters(in: .whitespaces)
                    }
                }
            }
        }
    }
}

struct RouteRowView: View {
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
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
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                    
                    Text("$\(route.price, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(Theme.primaryBlue)
                }
            }
            
            HStack {
                Label("\(route.availableSeats) seats available", systemImage: "person.2.fill")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                Text(route.departureTime, style: .date)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(.vertical, Theme.spacingSmall)
    }
}

#Preview {
    RouteSearchView()
        .environmentObject(BookingViewModel())
}

