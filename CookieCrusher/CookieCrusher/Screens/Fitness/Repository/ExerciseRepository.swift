//
//  ExerciseRepository.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Repository = mezivrstva mezi ViewModely a perzistencí (Core Data).
//
//  Proč:
//  - ViewModel řeší UI logiku, ne detaily ukládání.
//  - Repository umožní vyměnit úložiště (např. Core Data / REST / mock) bez zásahu do Views.
//

import Foundation

/// Lightweight DTO pro zobrazení řádku v seznamu (UI nechceme vázat na NSManagedObject).
struct ExerciseListItem: Identifiable, Equatable {
    let id: UUID
    let name: String

    /// „Počet událostí“ = počet záznamů.
    let eventsCount: Int

    /// První a poslední záznam (pro detail).
    let firstRecord: Date?
    let lastRecord: Date?

    /// Výpočet „per day“ dle zadání:
    /// - počet záznamů / počet dní mezi prvním a posledním záznamem
    /// - chráníme se proti dělení nulou (když existuje jen 1 záznam)
    let perDay: Double
}

/// Detailní „snapshot“ cviku pro obrazovku Record.
struct ExerciseDetail: Equatable {
    let id: UUID
    let name: String
    let eventsCount: Int
    let firstRecord: Date?
    let lastRecord: Date?
}

protocol ExerciseRepository {
    func fetchExercises() throws -> [ExerciseListItem]
    func fetchExerciseDetail(id: UUID) throws -> ExerciseDetail?

    @discardableResult
    func createExercise(name: String) throws -> UUID

    func addRecord(exerciseId: UUID, date: Date) throws
}

