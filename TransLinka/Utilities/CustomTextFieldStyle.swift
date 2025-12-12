//
//  CustomTextFieldStyle.swift
//  TransLinka
//
//  Custom text field style for consistent input fields
//

import SwiftUI

/// Custom text field style used throughout the app
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(Theme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}

