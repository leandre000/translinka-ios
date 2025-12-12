//
//  LottieAnimationView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

// Placeholder for Lottie animations
// In production, integrate Lottie-iOS framework

struct SuccessAnimation: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.accentGreen)
                .frame(width: 80, height: 80)
                .scaleEffect(scale)
                .opacity(opacity)
            
            Image(systemName: "checkmark")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

struct LoadingAnimation: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Theme.primaryBlue, lineWidth: 4)
            .frame(width: 40, height: 40)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

struct ConfettiAnimation: View {
    @State private var confetti: [ConfettiPiece] = []
    
    var body: some View {
        ZStack {
            ForEach(confetti) { piece in
                Circle()
                    .fill(piece.color)
                    .frame(width: 10, height: 10)
                    .position(piece.position)
            }
        }
        .onAppear {
            generateConfetti()
        }
    }
    
    private func generateConfetti() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple]
        for i in 0..<50 {
            let piece = ConfettiPiece(
                id: i,
                color: colors.randomElement() ?? .blue,
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: -100...0)
                )
            )
            confetti.append(piece)
            
            withAnimation(.easeOut(duration: Double.random(in: 1...3))) {
                if let index = confetti.firstIndex(where: { $0.id == i }) {
                    confetti[index].position.y = UIScreen.main.bounds.height + 100
                }
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id: Int
    let color: Color
    var position: CGPoint
}

