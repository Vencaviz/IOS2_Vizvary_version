//
//  ExerciseListViewModel.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  ViewModel pro hlavní obrazovku se seznamem cviků.
//
//  Zodpovědnosti:
//  - načíst cviky z repository
//  - reagovat na změny Core Data (jednoduše: reload při změně contextu)
//  - ovládat prezentaci „Add Exercise“ sheetu
//

import Combine
import CoreData
import Foundation

@MainActor
final class ExerciseListViewModel: ObservableObject {
    @Published private(set) var items: [ExerciseListItem] = []
    @Published var isPresentingAddExercise = false
    @Published var errorMessage: String?

    private let repository: ExerciseRepository
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    init(repository: ExerciseRepository, context: NSManagedObjectContext) {
        self.repository = repository
        self.context = context

        // Jednoduchý „reactive“ pattern:
        // - když context něco změní (save / insert / delete), přenačteme seznam
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: context)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.load()
            }
            .store(in: &cancellables)
    }

    func onAppear() {
        load()
    }

    func load() {
        do {
            items = try repository.fetchExercises()
            errorMessage = nil
        } catch {
            errorMessage = "Nepodařilo se načíst data."
        }
    }

    func tapNewExercise() {
        isPresentingAddExercise = true
    }
}

