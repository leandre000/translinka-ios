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
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.primaryBlue, Theme.primaryBlueDark],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: Theme.spacingXLarge) {
                Spacer()
                
                // Logo and Title
                VStack(spacing: Theme.spacingMedium) {
                    Image(systemName: "bus.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .rotationEffect(.degrees(isAnimating ? 5 : 0))
                    
                    Text("TransLinka")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                }
                .fadeIn()
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
                
                Spacer()
                
                // Buttons
                VStack(spacing: Theme.spacingMedium) {
                    NavigationLink(destination: SignUpView()) {
                        Text("Get Started")
                            .primaryButtonStyle()
                    }
                    
                    Button(action: {
                        showSignIn = true
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(Theme.cornerRadiusMedium)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
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
    }
}

#Preview {
    NavigationView {
        LandingView()
    }
}

