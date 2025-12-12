//
//  SignUpView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Header
                    VStack(spacing: Theme.spacingSmall) {
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text("Create your account to continue")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.top, Theme.spacingXLarge)
                    .fadeIn()
                    
                    // Form
                    VStack(spacing: Theme.spacingMedium) {
                        // Full Name
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            Text("Full Name")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Enter your full name", text: $fullName)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        .slideIn(from: .left)
                        
                        // Email
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        .slideIn(from: .left)
                        .animation(.smoothSpring.delay(0.1), value: email)
                        
                        // Password
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            HStack {
                                if showPassword {
                                    TextField("Enter your password", text: $password)
                                } else {
                                    SecureField("Enter your password", text: $password)
                                }
                                
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(Theme.cornerRadiusMedium)
                        }
                        .slideIn(from: .left)
                        .animation(.smoothSpring.delay(0.2), value: password)
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            Text("Confirm Password")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            HStack {
                                if showConfirmPassword {
                                    TextField("Confirm your password", text: $confirmPassword)
                                } else {
                                    SecureField("Confirm your password", text: $confirmPassword)
                                }
                                
                                Button(action: { showConfirmPassword.toggle() }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(Theme.cornerRadiusMedium)
                        }
                        .slideIn(from: .left)
                        .animation(.smoothSpring.delay(0.3), value: confirmPassword)
                        
                        // Error Message
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(Theme.accentRed)
                                .padding(.horizontal)
                        }
                        
                        // Sign Up Button
                        Button(action: {
                            Task {
                                await authViewModel.signUp(
                                    fullName: fullName,
                                    email: email,
                                    password: password,
                                    confirmPassword: confirmPassword
                                )
                            }
                        }) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign Up")
                            }
                        }
                        .primaryButtonStyle()
                        .disabled(authViewModel.isLoading)
                        .padding(.top, Theme.spacingMedium)
                        
                        // Google Sign In
                        Button(action: {
                            Task {
                                await authViewModel.signInWithGoogle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                Text("Sign in with Google")
                            }
                            .font(.headline)
                            .foregroundColor(Theme.textPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(Theme.cornerRadiusMedium)
                        }
                    }
                    .padding(.horizontal, Theme.spacingLarge)
                    
                    // Sign In Link
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(Theme.textSecondary)
                        Button("Sign In") {
                            dismiss()
                        }
                        .foregroundColor(Theme.primaryBlue)
                    }
                    .padding(.bottom, Theme.spacingLarge)
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

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(Theme.cornerRadiusMedium)
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthenticationViewModel())
}

