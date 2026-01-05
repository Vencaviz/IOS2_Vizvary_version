//
//  RecordExerciseViewModel.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  ViewModel pro obrazovku „Record Exercise“ (detail konkrétního cviku).
//
//  Zodpovědnosti:
//  - načíst detail (first/last record, počet událostí)
//  - držet vybraný datum pro nový record (DatePicker)
//  - po stisku „Record“ uložit record do Core Data (přes repository)
//  - řídit zobrazení „celebration“ animace
//

import Foundation

@MainActor
final class RecordExerciseViewModel: ObservableObject {
    @Published private(set) var detail: ExerciseDetail?
    @Published var selectedDate: Date = Date()
    @Published var errorMessage: String?

    /// Když se nastaví na `true`, View zobrazí animaci.
    @Published var isPresentingCelebration = false

    private let repository: ExerciseRepository
    private let exerciseId: UUID

    init(exerciseId: UUID, repository: ExerciseRepository) {
        self.exerciseId = exerciseId
        self.repository = repository
    }

    func onAppear() {
        reload()
    }

    func reload() {
        do {
            detail = try repository.fetchExerciseDetail(id: exerciseId)
            errorMessage = nil
        } catch {
            errorMessage = "Nepodařilo se načíst detail."
        }
    }

    /// Uloží nový record a spustí animaci.
    func record() {
        do {
            try repository.addRecord(exerciseId: exerciseId, date: selectedDate)
            // Po uložení si hned přenačteme detail, ať UI ukazuje nové hodnoty.
            reload()

            // Animace podle zadání:
            // - „Record zvýší počítadlo a jde se na animaci.“
            isPresentingCelebration = true
        } catch {
            errorMessage = "Nepodařilo se uložit záznam."
        }
    }

    /// Kolik „kuliček“ chceme v animaci.
    /// Zadání říká: „Kuliček se ukáže tolik, kolik je počítadlo hodnoty.“
    var celebrationBallCount: Int {
        detail?.eventsCount ?? 0
    }
}

