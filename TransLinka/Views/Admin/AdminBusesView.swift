//
//  AdminBusesView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct AdminBusesView: View {
    @EnvironmentObject var adminViewModel: AdminViewModel
    @State private var showAddBus = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(adminViewModel.buses) { bus in
                    AdminBusRow(bus: bus)
                }
                .onDelete(perform: deleteBus)
            }
            .navigationTitle("Buses")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddBus = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddBus) {
                AddEditBusView()
            }
        }
    }
    
    private func deleteBus(at offsets: IndexSet) {
        for index in offsets {
            adminViewModel.deleteBus(adminViewModel.buses[index])
        }
    }
}

struct AdminBusRow: View {
    let bus: Bus
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(bus.busNumber)
                    .font(.headline)
                
                Text("Capacity: \(bus.capacity)")
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            StatusBadge(status: bus.status.rawValue)
        }
        .padding(.vertical, Theme.spacingSmall)
    }
}

struct AddEditBusView: View {
    @Environment(\.dismiss) var dismiss
    let bus: Bus?
    
    @State private var busNumber = ""
    @State private var capacity = ""
    @State private var model = ""
    
    init(bus: Bus? = nil) {
        self.bus = bus
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Bus Number", text: $busNumber)
                TextField("Capacity", text: $capacity)
                    .keyboardType(.numberPad)
                TextField("Model", text: $model)
            }
            .navigationTitle(bus == nil ? "Add Bus" : "Edit Bus")
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
                if let bus = bus {
                    busNumber = bus.busNumber
                    capacity = String(bus.capacity)
                    model = bus.model
                }
            }
        }
    }
}

#Preview {
    AdminBusesView()
        .environmentObject(AdminViewModel())
}

