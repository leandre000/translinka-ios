//
//  AuthenticationService.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

/// Service handling authentication operations
/// TODO: Replace with backend API integration
class AuthenticationService {
    static let shared = AuthenticationService()
    
    private var currentUser: User?
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    
    private init() {
        loadUser()
    }
    
    /// Register a new user
    /// - Parameters:
    ///   - fullName: User's full name
    ///   - email: User's email address
    ///   - password: User's password (will be hashed in production)
    /// - Returns: Created user object
    /// - Note: In production, this calls backend API
    func signUp(fullName: String, email: String, password: String) async throws -> User {
        // Simulate API call delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // TODO: Replace with actual API call
        let user = User(fullName: fullName, email: email, isAdmin: false)
        currentUser = user
        saveUser(user)
        return user
    }
    
    /// Sign in existing user
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Returns: Authenticated user object
    /// - Note: Admin access for email "admin@translinka.com"
    func signIn(email: String, password: String) async throws -> User {
        // Simulate API call delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // TODO: Replace with actual API call
        // Demo: admin@translinka.com gets admin access
        let isAdmin = email == "admin@translinka.com"
        let user = User(fullName: isAdmin ? "Admin User" : "Jane Doe", email: email, isAdmin: isAdmin)
        currentUser = user
        saveUser(user)
        return user
    }
    
    func signInWithGoogle() async throws -> User {
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let user = User(fullName: "Google User", email: "user@gmail.com", isAdmin: false)
        currentUser = user
        saveUser(user)
        return user
    }
    
    func signOut() {
        currentUser = nil
        userDefaults.removeObject(forKey: userKey)
    }
    
    func resetPassword(email: String) async throws {
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
        }
    }
    
    private func loadUser() {
        if let data = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
        }
    }
}

