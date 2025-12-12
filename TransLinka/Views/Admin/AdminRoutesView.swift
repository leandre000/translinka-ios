//
//  AdminRoutesView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct AdminRoutesView: View {
    @EnvironmentObject var adminViewModel: AdminViewModel
    @State private var showAddRoute = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(adminViewModel.routes) { route in
                    NavigationLink(destination: AdminRouteDetailView(route: route)) {
                        AdminRouteRow(route: route)
                    }
                }
                .onDelete(perform: deleteRoute)
            }
            .navigationTitle("Routes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddRoute = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddRoute) {
                AddEditRouteView()
            }
            .onAppear {
                adminViewModel.loadRoutes()
            }
        }
    }
    
    private func deleteRoute(at offsets: IndexSet) {
        for index in offsets {
            adminViewModel.deleteRoute(adminViewModel.routes[index])
        }
    }
}

struct AdminRouteRow: View {
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
            Text("\(route.origin) → \(route.destination)")
                .font(.headline)
            
            HStack {
                Text(route.departureTime, style: .time)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                
                Text("•")
                    .foregroundColor(Theme.textSecondary)
                
                Text("$\(route.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(Theme.primaryBlue)
            }
        }
        .padding(.vertical, Theme.spacingSmall)
    }
}

struct AdminRouteDetailView: View {
    let route: Route
    @State private var showEdit = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.spacingLarge) {
                Text("Route Details")
                    .font(.title2)
                    .fontWeight(.bold)
                
                DetailSection(title: "Origin", value: route.origin)
                DetailSection(title: "Destination", value: route.destination)
                DetailSection(title: "Departure", value: route.departureTime, style: .date)
                DetailSection(title: "Arrival", value: route.arrivalTime, style: .date)
                DetailSection(title: "Price", value: "$\(route.price, specifier: "%.2f")")
                DetailSection(title: "Bus Number", value: route.busNumber)
                DetailSection(title: "Available Seats", value: "\(route.availableSeats)/\(route.totalSeats)")
            }
            .padding()
        }
        .navigationTitle("Route")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEdit = true
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            AddEditRouteView(route: route)
        }
    }
}

struct DetailSection: View {
    let title: String
    let value: Any
    var style: Date.FormatStyle?
    
    init(title: String, value: Any, style: Date.FormatStyle? = nil) {
        self.title = title
        self.value = value
        self.style = style
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
            
            if let date = value as? Date, let style = style {
                Text(date, style: style)
                    .font(.headline)
            } else {
                Text("\(value)")
                    .font(.headline)
            }
        }
    }
}

struct AddEditRouteView: View {
    @Environment(\.dismiss) var dismiss
    let route: Route?
    
    @State private var origin = ""
    @State private var destination = ""
    @State private var price = ""
    @State private var departureTime = Date()
    @State private var arrivalTime = Date()
    @State private var busNumber = ""
    
    init(route: Route? = nil) {
        self.route = route
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Origin", text: $origin)
                TextField("Destination", text: $destination)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                DatePicker("Departure Time", selection: $departureTime)
                DatePicker("Arrival Time", selection: $arrivalTime)
                TextField("Bus Number", text: $busNumber)
            }
            .navigationTitle(route == nil ? "Add Route" : "Edit Route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let route = route {
                    origin = route.origin
                    destination = route.destination
                    price = String(route.price)
                    departureTime = route.departureTime
                    arrivalTime = route.arrivalTime
                    busNumber = route.busNumber
                }
            }
        }
    }
}

#Preview {
    AdminRoutesView()
        .environmentObject(AdminViewModel())
}

