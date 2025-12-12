//
//  ReusableComponents.swift
//  TransLinka
//
//  Reusable UI components to keep code DRY
//

import SwiftUI

// MARK: - Reusable Card Component
/// Standard card container with consistent styling
struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
            .shadow(color: Theme.shadowSmall.color, radius: Theme.shadowSmall.radius, x: Theme.shadowSmall.x, y: Theme.shadowSmall.y)
    }
}

// MARK: - Primary Button
/// Standard primary action button used throughout the app
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text(title)
            }
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(isDisabled ? Theme.primaryBlue.opacity(0.5) : Theme.primaryBlue)
        .cornerRadius(Theme.cornerRadiusMedium)
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Secondary Button
/// Secondary action button with outline style
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.primaryBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.clear)
                .cornerRadius(Theme.cornerRadiusMedium)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                        .stroke(Theme.primaryBlue, lineWidth: 2)
                )
        }
    }
}

// MARK: - Section Header
/// Consistent section header styling
struct SectionHeader: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
            
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .font(.subheadline)
                    .foregroundColor(Theme.primaryBlue)
            }
        }
        .padding(.horizontal, Theme.spacingLarge)
    }
}

// MARK: - Info Row
/// Standard information display row
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    var iconColor: Color = Theme.primaryBlue
    
    var body: some View {
        HStack(spacing: Theme.spacingMedium) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            Text(label)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Empty State View
/// Standard empty state when no data is available
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: Theme.spacingMedium) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(Theme.textSecondary)
            
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.horizontal, Theme.spacingLarge)
                    .padding(.top, Theme.spacingMedium)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Loading View
/// Standard loading indicator
struct LoadingView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(1.5)
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(Theme.cornerRadiusMedium)
    }
}

// MARK: - Error View
/// Standard error display
struct ErrorView: View {
    let message: String
    var retryAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: Theme.spacingMedium) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(Theme.accentRed)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            if let retryAction = retryAction {
                SecondaryButton(title: "Retry", action: retryAction)
            }
        }
        .padding()
    }
}

