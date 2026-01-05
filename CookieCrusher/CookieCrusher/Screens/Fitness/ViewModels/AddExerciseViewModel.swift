//
//  AddExerciseViewModel.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  ViewModel pro modální okno „Add Exercise“.
//
//  Zodpovědnosti:
//  - držet text z TextFieldu
//  - validovat
//  - uložit do Core Data přes repository
//

import Foundation

@MainActor
final class AddExerciseViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var errorMessage: String?

    private let repository: ExerciseRepository

    init(repository: ExerciseRepository) {
        self.repository = repository
    }

    /// Uloží cvik. Pokud je úspěch, vrátí `true` (aby View mohlo dismissnout sheet).
    func save() -> Bool {
        do {
            _ = try repository.createExercise(name: name)
            errorMessage = nil
            return true
        } catch {
            errorMessage = "Zadejte prosím název (Description)."
            return false
        }
    }
}

