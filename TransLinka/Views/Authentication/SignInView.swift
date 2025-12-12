//
//  SignInView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showForgotPassword = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Header
                    VStack(spacing: Theme.spacingSmall) {
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text("Sign in to continue")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.top, Theme.spacingXLarge)
                    .fadeIn()
                    
                    // Form
                    VStack(spacing: Theme.spacingMedium) {
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
                        
                        // Forgot Password
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                showForgotPassword = true
                            }
                            .font(.subheadline)
                            .foregroundColor(Theme.primaryBlue)
                        }
                        
                        // Error Message
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(Theme.accentRed)
                                .padding(.horizontal)
                        }
                        
                        // Sign In Button
                        Button(action: {
                            Task {
                                await authViewModel.signIn(email: email, password: password)
                            }
                        }) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign In")
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
                    
                    // Sign Up Link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(Theme.textSecondary)
                        NavigationLink("Sign Up", destination: SignUpView())
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
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthenticationViewModel())
}

