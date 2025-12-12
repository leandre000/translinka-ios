//
//  ContentView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                if authViewModel.currentUser?.isAdmin == true {
                    AdminTabView()
                } else {
                    MainTabView()
                }
            } else {
                NavigationView {
                    LandingView()
                }
            }
        }
    }
}

