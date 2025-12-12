//
//  LandingView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct LandingView: View {
    @State private var isAnimating = false
    @State private var showSignIn = false
    @State private var showSignUp = false
    
    var body: some View {
        ZStack {
            // Animated Gradient Background
            LinearGradient(
                colors: [Theme.primaryBlue, Theme.primaryBlueDark],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animatedGradient(colors: [Theme.primaryBlue, Theme.primaryBlueDark, Theme.primaryBlueLight])
            
            VStack(spacing: Theme.spacingXLarge) {
                Spacer()
                
                // Logo and Title with Enhanced Animation
                VStack(spacing: Theme.spacingMedium) {
                    Image(systemName: "bus.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .rotationEffect(.degrees(isAnimating ? 5 : 0))
                        .glow(color: .white)
                        .pulse(duration: 2.0)
                    
                    Text("TransLinka")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .fadeIn()
                    
                    Text("Your Smart Travel Companion")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .fadeIn()
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
                
                Spacer()
                
                // Enhanced Buttons
                VStack(spacing: Theme.spacingMedium) {
                    NavigationLink(destination: SignUpView()) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Theme.accentGreen)
                            .cornerRadius(Theme.cornerRadiusMedium)
                            .shadow(color: Theme.accentGreen.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    Button(action: {
                        showSignIn = true
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(Theme.cornerRadiusMedium)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(.horizontal, Theme.spacingLarge)
                .padding(.bottom, Theme.spacingXLarge)
                .slideIn(from: .up)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSignIn) {
            SignInView()
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    NavigationView {
        LandingView()
    }
}
