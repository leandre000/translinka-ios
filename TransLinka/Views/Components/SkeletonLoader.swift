//
//  SkeletonLoader.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct SkeletonLoader: View {
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
            .fill(
                LinearGradient(
                    colors: [
                        Color.gray.opacity(0.3),
                        Color.gray.opacity(0.5),
                        Color.gray.opacity(0.3)
                    ],
                    startPoint: isAnimating ? .leading : .trailing,
                    endPoint: isAnimating ? .trailing : .leading
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

struct SkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMedium) {
            SkeletonLoader()
                .frame(height: 20)
            
            SkeletonLoader()
                .frame(height: 16)
            
            SkeletonLoader()
                .frame(height: 16)
                .frame(width: 150)
        }
        .padding()
        .cardStyle()
    }
}

