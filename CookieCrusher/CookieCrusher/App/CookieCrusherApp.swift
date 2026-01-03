//
//  CookieCrusherApp.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct CookieCrusherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authService = AuthenticationService.shared
    
    @State private var isCheckingAuth = true
    
    var body: some Scene {
        WindowGroup {
            if isCheckingAuth {
                // Loading screen while checking auth state
                ZStack {
                    Image("menu_bg")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                    }
                }
                .onAppear {
                    // Give Firebase time to restore session
                    authService.startSession {
                        withAnimation {
                            isCheckingAuth = false
                        }
                    }
                }
            }
            else if authService.user != nil {
                // User is signed in (anonymous or registered)
                MapView()
                    .transition(.opacity)
            }
            else {
                // No user - show login (shouldn't happen with startSession)
                LoginView()
                    .transition(.opacity)
            }
        }
    }
}
