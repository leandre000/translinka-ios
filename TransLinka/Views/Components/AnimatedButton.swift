//
//  AnimatedButton.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct AnimatedButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Theme.primaryBlue)
                .cornerRadius(Theme.cornerRadiusMedium)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .shadow(color: Theme.primaryBlue.opacity(isPressed ? 0.3 : 0.5), radius: isPressed ? 5 : 10)
        }
    }
}

struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isLoading ? Theme.primaryBlue.opacity(0.7) : Theme.primaryBlue)
            .cornerRadius(Theme.cornerRadiusMedium)
        }
        .disabled(isLoading)
    }
}

struct IconButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isAnimating = false
            }
            action()
        }) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .scaleEffect(isAnimating ? 1.2 : 1.0)
        }
    }
}

