//
//  LoginRegisterModals.swift
//  CookieCrusher
//
//  Modal components for Login and Registration
//

import SwiftUI

// MARK: - Login Modal View
struct LoginModalView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var showRegisterSheet: Bool
    
    var body: some View {
        ZStack {
            LoginBackground()
            
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.black.opacity(0.6))
                            .padding()
                    }
                    Spacer()
                }
                
                Spacer()
                
                Text("CookieCrusher")
                    .font(.custom("Alkatra-Bold", size: 50))
                    .foregroundColor(.black)
                    .padding(.bottom, 40)
                
                // Form card
                VStack(spacing: 10) {
                    if viewModel.showError {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    } else {
                        LoginTextField(title: "Email", text: $viewModel.email)
                        
                        LoginTextField(title: "Password", text: $viewModel.password, isSecure: true)
                        
                        LoginButton(title: "Login", isValid: viewModel.isValid) {
                            viewModel.login()
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                        Button(action: {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showRegisterSheet = true
                            }
                        }) {
                            Text("REGISTRATION")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color("Secondary"))
                                .cornerRadius(25)
                        }
                    }
                }
                .padding(15)
                .frame(maxWidth: 380)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .shadow(radius: 5)
                
                Spacer()
            }
        }
        .onChange(of: viewModel.shouldDismiss) { _, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

// MARK: - Register Modal View
struct RegisterModalView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LoginBackground()
            
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .bold()
                            Text("BACK")
                                .bold()
                        }
                        .foregroundColor(Color("Primary"))
                        .padding()
                    }
                    Spacer()
                }
                
                Spacer()
                
                Text("CookieCrusher")
                    .font(.custom("Alkatra-Bold", size: 50))
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                // Form card
                VStack(spacing: 10) {
                    if viewModel.showError {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    } else {
                        LoginTextField(title: "Nickname", text: $viewModel.nickname)
                        
                        LoginTextField(title: "Email", text: $viewModel.email)
                        
                        LoginTextField(title: "Password (6+ characters)", text: $viewModel.password, isSecure: true)
                        
                        LoginButton(title: "Register", isPrimary: false, isValid: viewModel.isValid) {
                            viewModel.register()
                        }
                        .padding(.top, 10)
                    }
                }
                .padding(15)
                .frame(maxWidth: 380)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .shadow(radius: 5)
                
                Spacer()
            }
        }
        .onChange(of: viewModel.registrationSuccess) { _, success in
            if success {
                dismiss()
            }
        }
    }
}
