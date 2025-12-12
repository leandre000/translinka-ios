//
//  AuthenticationViewModel.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation
import SwiftUI

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService = AuthenticationService.shared
    
    init() {
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        if let user = authService.getCurrentUser() {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    func signUp(fullName: String, email: String, password: String, confirmPassword: String) async {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signUp(fullName: fullName, email: email, password: password)
            self.currentUser = user
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signIn(email: email, password: password)
            self.currentUser = user
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signInWithGoogle() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signInWithGoogle()
            self.currentUser = user
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signOut() {
        authService.signOut()
        self.currentUser = nil
        self.isAuthenticated = false
    }
    
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.resetPassword(email: email)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

