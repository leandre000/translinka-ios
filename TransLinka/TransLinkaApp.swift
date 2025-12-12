//
//  TransLinkaApp.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

@main
struct TransLinkaApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var bookingViewModel = BookingViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(bookingViewModel)
        }
    }
}

