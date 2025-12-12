//
//  Constants.swift
//  TransLinka
//
//  App-wide constants and configuration
//

import Foundation

/// App-wide constants for configuration and default values
struct AppConstants {
    // MARK: - API Configuration
    /// Base URL for backend API (to be configured)
    static let apiBaseURL = "https://api.translinka.com"
    
    // MARK: - User Defaults Keys
    static let userDefaultsKey = "currentUser"
    static let hasSeenOnboardingKey = "hasSeenOnboarding"
    static let preferredLanguageKey = "preferredLanguage"
    
    // MARK: - Validation
    static let minPasswordLength = 6
    static let maxPasswordLength = 50
    
    // MARK: - Booking
    static let maxSeatsPerBooking = 10
    static let bookingTimeoutSeconds: TimeInterval = 300 // 5 minutes
    
    // MARK: - Maps
    static let defaultMapZoom: Double = 15.0
    static let defaultMapLatitude = -1.9441 // Kigali
    static let defaultMapLongitude = 30.0619
    
    // MARK: - Animation
    static let defaultAnimationDuration: Double = 0.3
    static let fastAnimationDuration: Double = 0.15
    static let slowAnimationDuration: Double = 0.5
}

/// Error messages used throughout the app
struct ErrorMessages {
    static let networkError = "Network error. Please check your connection."
    static let invalidEmail = "Please enter a valid email address."
    static let invalidPassword = "Password must be at least \(AppConstants.minPasswordLength) characters."
    static let passwordsDoNotMatch = "Passwords do not match."
    static let userNotFound = "User not found."
    static let routeNotFound = "Route not found."
    static let bookingFailed = "Booking failed. Please try again."
    static let paymentFailed = "Payment failed. Please try again."
    static let authenticationRequired = "Please sign in to continue."
}

/// Success messages used throughout the app
struct SuccessMessages {
    static let bookingConfirmed = "Booking confirmed successfully!"
    static let paymentSuccessful = "Payment processed successfully."
    static let profileUpdated = "Profile updated successfully."
    static let passwordReset = "Password reset email sent."
}

