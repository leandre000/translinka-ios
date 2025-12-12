//
//  ARNavigationView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI
import ARKit
import RealityKit

struct ARNavigationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showInstructions = true
    
    var body: some View {
        ZStack {
            // AR View Placeholder
            Color.black.ignoresSafeArea()
            
            VStack {
                // Instructions Overlay
                if showInstructions {
                    VStack(spacing: Theme.spacingMedium) {
                        Text("AR Navigation")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Point your camera at the terminal to see navigation directions to your gate")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Got it") {
                            withAnimation {
                                showInstructions = false
                            }
                        }
                        .primaryButtonStyle()
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(Theme.cornerRadiusLarge)
                    .padding()
                    .transition(.opacity)
                }
                
                Spacer()
                
                // AR Controls
                HStack {
                    Button(action: {
                        showInstructions = true
                    }) {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ARNavigationView()
}

