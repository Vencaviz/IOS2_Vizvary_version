//
//  AccountView.swift
//  CookieCrusher
//
//  Created by Václav Vizváry on 30.12.2025.
//
import SwiftUI

struct AccountView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("menu_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    // Top bar with home button
                    HStack {
                    }
                }
            }
            
        }
    }
}
#Preview {
    AccountView()
}
