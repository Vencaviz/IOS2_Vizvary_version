//
//  MenuView.swift
//  CookieCrusher
//
//  Created by Václav Vizváry on 28.12.2025.
//

import SwiftUI

struct SettingsMenuView: View {
    
    @StateObject private var viewModel = MenuViewModel()
    @StateObject var authService = AuthenticationService.shared
    @State private var navigateToMap = false
    @State private var navigateToAccount = false
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                // Background image
                Image("menu_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top bar with home button
                    HStack {
                        
                        Spacer()
                        
                        Button{
                            navigateToMap.toggle()
                        } label: {
                                                    Image("Buttons-house").resizable().scaledToFit().frame(width: 66, height: 70)
                                                }
                            .padding(.trailing, 120)
                            .padding(.top, 10)}
                    
                    Spacer()
                        .frame(height: 80)
                    
                    // Settings title
                    Text("SETTINGS")
                        .font(.custom("Alkatra-Bold", size: 50))
                        .foregroundColor(.black)
                        .padding(.bottom, 40)
                    
                    Spacer()
                        .frame(height: 100)
                    
                    
                 
                    
                    // Account button
                    NavigationLink(destination: AccountView()) {
                        MenuButton(
                            title: "ACCOUNT",
                            backgroundColor: Color(red: 0.8, green: 0.95, blue: 0.8),
                            borderColor: Color(red: 0.4, green: 0.5, blue: 0.4)
                        )
                    }
                    
                    Spacer()
                        .frame(height: 25)
                    
                    // Log out / Login button (dynamicky podle stavu uživatele)
                    if authService.user?.isAnonymous == false {
                        // Uživatel je přihlášen s emailem -> zobraz LOG OUT
                        Button(action: {
                            viewModel.logOut()
                        }) {
                            MenuButton(
                                title: "LOG OUT",
                                backgroundColor: Color(red: 0.98, green: 0.85, blue: 0.9),
                                borderColor: Color(red: 0.6, green: 0.4, blue: 0.5)
                            )
                        }
                    } else {
                        // Uživatel je anonymní/guest -> zobraz LOGIN
                        Button(action: {
                            navigateToLogin = true
                        }) {
                            MenuButton(
                                title: "LOGIN",
                                backgroundColor: Color(red: 0.85, green: 0.9, blue: 0.98),
                                borderColor: Color(red: 0.4, green: 0.5, blue: 0.6)
                            )
                        }
                    }
                    
                   
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToMap) {
                            MapView()
                        }
            .navigationDestination(isPresented: $navigateToLogin) {
                            LoginView()
                        }
            
        }
    }
}



// Preview
struct SettingsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenuView()
    }
}
