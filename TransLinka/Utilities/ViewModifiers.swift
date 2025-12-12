//
//  ViewModifiers.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
            .shadow(color: Theme.shadowSmall.color, radius: Theme.shadowSmall.radius, x: Theme.shadowSmall.x, y: Theme.shadowSmall.y)
    }
}

struct GradientBackgroundModifier: ViewModifier {
    let colors: [Color]
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

struct RoundedBorderModifier: ViewModifier {
    let color: Color
    let width: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .stroke(color, lineWidth: width)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
    
    func gradientBackground(colors: [Color] = [Theme.primaryBlue, Theme.primaryBlueDark]) -> some View {
        modifier(GradientBackgroundModifier(colors: colors))
    }
    
    func roundedBorder(color: Color = Theme.primaryBlue, width: CGFloat = 1) -> some View {
        modifier(RoundedBorderModifier(color: color, width: width))
    }
}

