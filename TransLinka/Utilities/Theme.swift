//
//  Theme.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct Theme {
    // Primary Colors
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let primaryBlueDark = Color(red: 0.15, green: 0.3, blue: 0.7)
    static let primaryBlueLight = Color(red: 0.3, green: 0.5, blue: 0.9)
    
    // Accent Colors
    static let accentGreen = Color(red: 0.2, green: 0.7, blue: 0.4)
    static let accentRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    // Neutral Colors
    static let background = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let cardBackground = Color.white
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    
    // Spacing
    static let spacingSmall: CGFloat = 8
    static let spacingMedium: CGFloat = 16
    static let spacingLarge: CGFloat = 24
    static let spacingXLarge: CGFloat = 32
    
    // Corner Radius
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 16
    
    // Shadows
    static let shadowSmall = Shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    static let shadowMedium = Shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    static let shadowLarge = Shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

extension View {
    func cardStyle() -> some View {
        self
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
            .shadow(color: Theme.shadowSmall.color, radius: Theme.shadowSmall.radius, x: Theme.shadowSmall.x, y: Theme.shadowSmall.y)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Theme.primaryBlue)
            .cornerRadius(Theme.cornerRadiusMedium)
    }
}

