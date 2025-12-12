//
//  CityCard.swift
//  TransLinka
//
//  City card component for RwandanLocationsView
//

import SwiftUI

/// Card displaying city information
struct CityCard: View {
    let city: City
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.spacingMedium) {
                Image(systemName: "building.2.fill")
                    .font(.title2)
                    .foregroundColor(Theme.primaryBlue)
                    .frame(width: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(city.name)
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Tap to view details")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.textSecondary)
            }
            .padding()
            .cardStyle()
        }
        .padding(.horizontal)
    }
}

