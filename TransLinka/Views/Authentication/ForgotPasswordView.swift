//
//  ForgotPasswordView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var isSubmitted = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacingLarge) {
                if isSubmitted {
                    VStack(spacing: Theme.spacingMedium) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.accentGreen)
                        
                        Text("Email Sent!")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Please check your email for password reset instructions.")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("OK") {
                            dismiss()
                        }
                        .primaryButtonStyle()
                        .padding(.top, Theme.spacingLarge)
                    }
                    .padding()
                    .fadeIn()
                } else {
                    VStack(spacing: Theme.spacingLarge) {
                        Text("Reset Password")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Enter your email address and we'll send you instructions to reset your password.")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(Theme.accentRed)
                        }
                        
                        Button(action: {
                            Task {
                                await authViewModel.resetPassword(email: email)
                                if authViewModel.errorMessage == nil {
                                    isSubmitted = true
                                }
                            }
                        }) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Send Reset Link")
                            }
                        }
                        .primaryButtonStyle()
                        .disabled(authViewModel.isLoading || email.isEmpty)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthenticationViewModel())
}

