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
    
    /// Handle user registration
    /// - Parameters:
    ///   - fullName: User's full name
    ///   - email: User's email address
    ///   - password: User's password
    ///   - confirmPassword: Password confirmation
    func signUp(fullName: String, email: String, password: String, confirmPassword: String) async {
        // Validate password match
        guard password == confirmPassword else {
            errorMessage = ErrorMessages.passwordsDoNotMatch
            return
        }
        
        // Validate password length
        guard password.count >= AppConstants.minPasswordLength else {
            errorMessage = ErrorMessages.invalidPassword
            return
        }
        
        // Validate email format
        guard email.isValidEmail else {
            errorMessage = ErrorMessages.invalidEmail
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
    
    /// Handle user sign in
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    func signIn(email: String, password: String) async {
        // Validate email format
        guard email.isValidEmail else {
            errorMessage = ErrorMessages.invalidEmail
            return
        }
        
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

