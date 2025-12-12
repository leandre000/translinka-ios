//
//  ContentView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                if authViewModel.isAuthenticated {
                    if authViewModel.currentUser?.isAdmin == true {
                        AdminTabView()
                            .transition(.opacity)
                    } else {
                        MainTabView()
                            .transition(.opacity)
                    }
                } else {
                    NavigationView {
                        LandingView()
                    }
                    .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: authViewModel.isAuthenticated)
    }
}

struct SplashScreenView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.primaryBlue, Theme.primaryBlueDark],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: Theme.spacingLarge) {
                Image(systemName: "bus.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("TransLinka")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

