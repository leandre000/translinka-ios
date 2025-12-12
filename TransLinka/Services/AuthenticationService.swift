//
//  AuthenticationService.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

class AuthenticationService {
    static let shared = AuthenticationService()
    
    private var currentUser: User?
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    
    private init() {
        loadUser()
    }
    
    func signUp(fullName: String, email: String, password: String) async throws -> User {
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // In production, this would call a real API
        let user = User(fullName: fullName, email: email, isAdmin: false)
        currentUser = user
        saveUser(user)
        return user
    }
    
    func signIn(email: String, password: String) async throws -> User {
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // In production, this would call a real API
        // For demo, create a user if email is admin@translinka.com
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

