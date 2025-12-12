//
//  QuickActionCard.swift
//  TransLinka
//
//  Reusable quick action card component
//

import SwiftUI

/// Quick action card used in HomeView
struct QuickActionCard: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.spacingSmall) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .padding()
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
            .shadow(color: Theme.shadowSmall.color, radius: Theme.shadowSmall.radius, x: Theme.shadowSmall.x, y: Theme.shadowSmall.y)
        }
    }
}

