//
//  PaymentMethodsView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct PaymentMethodsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var paymentMethods: [PaymentMethod] = []
    @State private var showAddPayment = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(paymentMethods) { method in
                    PaymentMethodRow(method: method)
                }
                .onDelete(perform: deletePaymentMethod)
                
                Button(action: {
                    showAddPayment = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.primaryBlue)
                        Text("Add Payment Method")
                            .foregroundColor(Theme.primaryBlue)
                    }
                }
            }
            .navigationTitle("Payment Methods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showAddPayment) {
                AddPaymentMethodView()
            }
            .onAppear {
                loadPaymentMethods()
            }
        }
    }
    
    private func loadPaymentMethods() {
        // Load from storage or API
        paymentMethods = []
    }
    
    private func deletePaymentMethod(at offsets: IndexSet) {
        paymentMethods.remove(atOffsets: offsets)
    }
}

struct PaymentMethodRow: View {
    let method: PaymentMethod
    
    var body: some View {
        HStack {
            Image(systemName: iconForPaymentType(method.type))
                .foregroundColor(Theme.primaryBlue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(method.type.rawValue)
                    .font(.headline)
                
                if let cardNumber = method.cardNumber, !cardNumber.isEmpty {
                    Text("**** \(cardNumber.suffix(4))")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            Spacer()
            
            if method.isDefault {
                Text("Default")
                    .font(.caption)
                    .foregroundColor(Theme.accentGreen)
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

struct AddPaymentMethodView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedType: PaymentMethod.PaymentType = .creditCard
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Payment Type", selection: $selectedType) {
                    ForEach(PaymentMethod.PaymentType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                
                // Add form fields based on payment type
            }
            .navigationTitle("Add Payment Method")
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
        }
    }
}

#Preview {
    PaymentMethodsView()
}

