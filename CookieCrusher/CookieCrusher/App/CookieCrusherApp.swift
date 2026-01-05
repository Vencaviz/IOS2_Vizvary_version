//
//  CookieCrusherApp.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI
import FirebaseCore
import CoreData


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
    
    @State private var isFirstLaunch = true

    // MARK: - Fitness mode (assignment/demo)
    //
    // Tento repozitář už obsahuje původní aplikaci s Firebase loginem.
    // Pro účely zadání „Fitness“ (podle mockupu) přidáváme separátní flow,
    // které lze spustit přes launch argument:
    //
    //   -fitness
    //
    // Výhoda:
    // - UI testy nemusí řešit login / síť.
    //
    // Pro UI testy používáme navíc:
    //   -ui-testing
    // který zapne in-memory Core Data a seed demo dat.
    private let fitnessPersistence: FitnessPersistenceController = {
        let args = ProcessInfo.processInfo.arguments
        let isUITesting = args.contains("-ui-testing")
        return FitnessPersistenceController(inMemory: isUITesting, seedDemoData: isUITesting)
    }()
    
    var body: some Scene {
        WindowGroup {
            // Fitness režim má přednost – je to „samostatná aplikace v aplikaci“ pro zadání.
            if ProcessInfo.processInfo.arguments.contains("-fitness") {
                FitnessRootView(context: fitnessPersistence.container.viewContext)
            }
            else if authService.user != nil {
                MapView()
                    .transition(.opacity)
            }
            else if isFirstLaunch {
                ZStack {
                    Image("menu_bg")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                .onAppear {
                    authService.startSession {
                        withAnimation {
                            isFirstLaunch = false
                        }
                    }
                }
            }
            else {
                LoginView()
                    .transition(.opacity)
            }
        }
    }
}
