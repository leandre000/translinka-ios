//
//  LuggageSelectionView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct LuggageSelectionView: View {
    @Binding var selectedLuggage: LuggageOption
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacingLarge) {
                Text("Select Luggage Size")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(spacing: Theme.spacingMedium) {
                    LuggageOptionCard(
                        option: .none,
                        isSelected: selectedLuggage == .none
                    ) {
                        selectedLuggage = .none
                    }
                    
                    LuggageOptionCard(
                        option: .small,
                        isSelected: selectedLuggage == .small
                    ) {
                        selectedLuggage = .small
                    }
                    
                    LuggageOptionCard(
                        option: .medium,
                        isSelected: selectedLuggage == .medium
                    ) {
                        selectedLuggage = .medium
                    }
                    
                    LuggageOptionCard(
                        option: .large,
                        isSelected: selectedLuggage == .large
                    ) {
                        selectedLuggage = .large
                    }
                }
                .padding()
                
                Spacer()
                
                Button("Confirm") {
                    dismiss()
                }
                .primaryButtonStyle()
                .padding()
            }
            .navigationTitle("Luggage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

enum LuggageOption: String, CaseIterable {
    case none = "No luggage"
    case small = "Small Size"
    case medium = "Medium Size"
    case large = "Large Size"
    
    var price: Double {
        switch self {
        case .none: return 0
        case .small: return 5.00
        case .medium: return 10.00
        case .large: return 15.00
        }
    }
    
    var icon: String {
        switch self {
        case .none: return "xmark.circle"
        case .small: return "bag"
        case .medium: return "bag.fill"
        case .large: return "suitcase.fill"
        }
    }
}

struct LuggageOptionCard: View {
    let option: LuggageOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: option.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? Theme.primaryBlue : Theme.textSecondary)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.rawValue)
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    
                    if option != .none {
                        Text("$\(option.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Theme.primaryBlue)
                }
            }
            .padding()
            .background(isSelected ? Theme.primaryBlue.opacity(0.1) : Color.gray.opacity(0.1))
            .cornerRadius(Theme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .stroke(isSelected ? Theme.primaryBlue : Color.clear, lineWidth: 2)
            )
        }
    }
}

