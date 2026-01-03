//
//  AccountView.swift
//  CookieCrusher
//
//  Created by Václav Vizváry on 30.12.2025.
//
import SwiftUI

struct AccountView: View {
    @StateObject private var viewModel = AccountViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showLoginSheet = false
    @State private var showRegisterSheet = false
    
    var body: some View {
        ZStack {
            // Background image
            Image("menu_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top bar with back button
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                
                Spacer()
                    .frame(height: 20)
                
                // Account title
                Text("ACCOUNT")
                    .font(.custom("Alkatra-Bold", size: 45))
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else if viewModel.isAnonymous {
                    // Anonymous user - show login prompt
                    anonymousUserView
                } else if let user = viewModel.user {
                    // Logged in user - show data
                    loggedInUserView(user: user)
                } else {
                    // Error state
                    Text("Failed to load account data")
                        .foregroundColor(.red)
                        .font(.custom("Alkatra-Medium", size: 18))
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showLoginSheet) {
            LoginModalView(showRegisterSheet: $showRegisterSheet)
        }
        .sheet(isPresented: $showRegisterSheet) {
            RegisterModalView()
        }
    }
    
    // MARK: - Anonymous User View
    private var anonymousUserView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 70))
                .foregroundColor(.black.opacity(0.6))
            
            Text("You are playing as a Guest")
                .font(.custom("Alkatra-Bold", size: 24))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Text("Register to save your progress and compete on the leaderboard!")
                .font(.custom("Alkatra-Medium", size: 16))
                .foregroundColor(.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showRegisterSheet = true
            }) {
                Text("REGISTER NOW")
                    .font(.custom("Alkatra-Bold", size: 22))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("Primary"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 3)
                            )
                    )
                    .shadow(radius: 5)
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Logged In User View
    private func loggedInUserView(user: DBUser) -> some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: user.dateCreated)
        
        return ScrollView {
            VStack(spacing: 20) {
                // Profile Icon
                ZStack {
                    Circle()
                        .fill(Color("Primary"))
                        .frame(width: 90, height: 90)
                        .shadow(radius: 5)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 45))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 5)
                
                // Nickname
                Text(user.nickname)
                    .font(.custom("Alkatra-Bold", size: 28))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 25)
                
                // Email
                Text(user.email)
                    .font(.custom("Alkatra-Medium", size: 16))
                    .foregroundColor(.black.opacity(0.6))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                
                // Stats Cards
                VStack(spacing: 12) {
                    // Current Level
                    statCard(
                        icon: "flag.fill",
                        title: "CURRENT LEVEL",
                        value: "\(user.currentLevel)",
                        backgroundColor: Color(red: 0.8, green: 0.95, blue: 0.8),
                        borderColor: Color(red: 0.4, green: 0.5, blue: 0.4)
                    )
                    
                    // Highest Score
                    statCard(
                        icon: "star.fill",
                        title: "HIGHEST SCORE",
                        value: "\(user.highestScore)",
                        backgroundColor: Color(red: 0.98, green: 0.9, blue: 0.7),
                        borderColor: Color(red: 0.7, green: 0.6, blue: 0.3)
                    )
                    
                    // Lives
                    statCard(
                        icon: "heart.fill",
                        title: "LIVES",
                        value: "\(user.lives)",
                        backgroundColor: Color(red: 0.98, green: 0.85, blue: 0.9),
                        borderColor: Color(red: 0.6, green: 0.4, blue: 0.5)
                    )
                    
                    // Member Since
                    statCard(
                        icon: "calendar",
                        title: "MEMBER SINCE",
                        value: dateString,
                        backgroundColor: Color(red: 0.85, green: 0.9, blue: 0.98),
                        borderColor: Color(red: 0.4, green: 0.5, blue: 0.6)
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 15)
        }
    }
    
    // MARK: - Stat Card Component
    private func statCard(icon: String, title: String, value: String, backgroundColor: Color, borderColor: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(borderColor)
                .frame(width: 35)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.custom("Alkatra-Bold", size: 13))
                    .foregroundColor(.black.opacity(0.6))
                
                Text(value)
                    .font(.custom("Alkatra-Bold", size: 20))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(borderColor, lineWidth: 3)
                )
        )
        .shadow(radius: 3)
    }
}

#Preview {
    AccountView()
}
