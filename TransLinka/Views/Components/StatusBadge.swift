//
//  StatusBadge.swift
//  TransLinka
//
//  Reusable status badge component
//

import SwiftUI

/// Status badge component for displaying booking status
struct StatusBadge: View {
    let status: Booking.BookingStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(8)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .confirmed: return Theme.accentGreen.opacity(0.2)
        case .pending: return Theme.accentOrange.opacity(0.2)
        case .cancelled: return Theme.accentRed.opacity(0.2)
        case .completed: return Theme.primaryBlue.opacity(0.2)
        }
    }
    
    private var foregroundColor: Color {
        switch status {
        case .confirmed: return Theme.accentGreen
        case .pending: return Theme.accentOrange
        case .cancelled: return Theme.accentRed
        case .completed: return Theme.primaryBlue
        }
    }
}

