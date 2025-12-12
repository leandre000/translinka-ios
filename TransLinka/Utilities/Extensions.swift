//
//  Extensions.swift
//  TransLinka
//
//  Utility extensions to reduce code duplication
//

import SwiftUI
import Foundation

// MARK: - Date Extensions
extension Date {
    /// Format date as time string (e.g., "2:30 PM")
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    /// Format date as date string (e.g., "Jan 15, 2024")
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    /// Format duration in hours and minutes
    static func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
}

// MARK: - Double Extensions
extension Double {
    /// Format as currency string
    var currencyString: String {
        return String(format: "$%.2f", self)
    }
    
    /// Format as distance string (meters to km)
    var distanceString: String {
        if self >= 1000 {
            return String(format: "%.1f km", self / 1000)
        }
        return String(format: "%.0f m", self)
    }
}

// MARK: - String Extensions
extension String {
    /// Check if string is valid email
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Check if string is valid phone number
    var isValidPhone: Bool {
        let phoneRegex = "^[+]?[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
}

// MARK: - View Extensions
extension View {
    /// Hide keyboard when tapped outside
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Conditional modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Array Extensions
extension Array where Element: Identifiable {
    /// Remove element by ID
    mutating func remove(byId id: Element.ID) {
        removeAll { $0.id == id }
    }
}

