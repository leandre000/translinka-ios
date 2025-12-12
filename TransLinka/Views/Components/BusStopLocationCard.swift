//
//  BusStopLocationCard.swift
//  TransLinka
//
//  Bus stop location card component
//

import SwiftUI

/// Card displaying bus stop information
struct BusStopLocationCard: View {
    let busStop: BusStopLocation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.spacingMedium) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title2)
                    .foregroundColor(Theme.accentOrange)
                    .frame(width: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(busStop.name)
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(busStop.city)
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

