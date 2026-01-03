//
//  AuthenticationService.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import Foundation
import FirebaseAuth
import Combine

class AuthenticationService: ObservableObject {
    static let shared = AuthenticationService()
    
    @Published var user: User?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    private init() {
        // Listen state change(login/logout) from Firebase
        // Firebase automatically restores the user session
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
            print("🔐 Auth state changed: \(user?.uid ?? "nil") - Anonymous: \(user?.isAnonymous ?? false)")
        }
    }
    
    func signInAnonymously(completion: @escaping (Bool) -> Void) {
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.errorMessage = ""
            completion(true)
        }
    }
    
    func login(email: String, pass: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.errorMessage = ""
            completion(true)
        }
    }
    
    func register(email: String, pass: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.errorMessage = ""
            completion(true)
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    func linkAnonymousAccount(email: String, pass: String, completion: @escaping (Bool, String?) -> Void) {
        // Validate inputs
        guard !email.isEmpty, !pass.isEmpty else {
            completion(false, "Email a heslo nesmí být prázdné")
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, "Žádný přihlášený uživatel")
            return
        }
        
        guard currentUser.isAnonymous else {
            completion(false, "Uživatel není anonymní")
            return
        }
        
        // Create credential on main thread
        DispatchQueue.main.async {
            let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
            
            currentUser.link(with: credential) { [weak self] result, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        completion(false, error.localizedDescription)
                        return
                    }
                    self?.errorMessage = ""
                    completion(true, nil)
                }
            }
        }
    }
    
    func startSession(completion: @escaping () -> Void = {}) {
        // Check if user is already signed in (Firebase persistence)
        if let currentUser = Auth.auth().currentUser {
            print("✅ User already signed in: \(currentUser.uid)")
            self.user = currentUser
            self.isLoading = false
            completion()
            return
        }
        
        // No user found, create anonymous session
        print("🆕 Creating new anonymous session")
        isLoading = true
        
        Auth.auth().signInAnonymously { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Chyba Auth: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                completion()
                return
            }
            
            guard let uid = result?.user.uid else {
                self.isLoading = false
                completion()
                return
            }
            
            print("✅ Anonymous sign in successful: \(uid)")
            
            DatabaseService.shared.checkOrCreateGuest(uid: uid) { success in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if !success {
                        print("⚠️ Nepodařilo se ověřit uživatele v DB")
                    }
                    completion()
                }
            }
        }
    }
}
