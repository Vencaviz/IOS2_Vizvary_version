//
//  CoreDataExerciseRepository.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Implementace repository nad Core Data.
//
//  Důležité:
//  - V repozitáři se snažíme držet „čisté“ typy (DTO) a Core Data izolovat uvnitř.
//  - Díky tomu Views a ViewModely nemusí znát `NSManagedObjectContext` ani `NSManagedObject`.
//

import CoreData
import Foundation

final class CoreDataExerciseRepository: ExerciseRepository {
    private let context: NSManagedObjectContext
    private let calendar: Calendar

    init(context: NSManagedObjectContext, calendar: Calendar = .current) {
        self.context = context
        self.calendar = calendar
    }

    func fetchExercises() throws -> [ExerciseListItem] {
        let request = CDExercise.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true),
            NSSortDescriptor(key: "name", ascending: true),
        ]

        let exercises = try context.fetch(request)
        return exercises.map { mapToListItem($0) }
    }

    func fetchExerciseDetail(id: UUID) throws -> ExerciseDetail? {
        let request = CDExercise.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let exercise = try context.fetch(request).first else { return nil }

        let records = exercise.recordsArray.sorted(by: { $0.date < $1.date })
        let first = records.first?.date
        let last = records.last?.date

        return ExerciseDetail(
            id: exercise.id,
            name: exercise.name,
            eventsCount: records.count,
            firstRecord: first,
            lastRecord: last
        )
    }

    func createExercise(name: String) throws -> UUID {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw NSError(domain: "Fitness", code: 1, userInfo: [NSLocalizedDescriptionKey: "Exercise name is empty"])
        }

        let exercise = CDExercise(context: context)
        exercise.id = UUID()
        exercise.name = trimmed
        exercise.createdAt = Date()

        try saveIfNeeded()
        return exercise.id
    }

    func addRecord(exerciseId: UUID, date: Date) throws {
        let request = CDExercise.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", exerciseId as CVarArg)

        guard let exercise = try context.fetch(request).first else {
            throw NSError(domain: "Fitness", code: 2, userInfo: [NSLocalizedDescriptionKey: "Exercise not found"])
        }

        let record = CDExerciseRecord(context: context)
        record.id = UUID()
        record.date = date
        record.exercise = exercise

        try saveIfNeeded()
    }
}

// MARK: - Mapping
private extension CoreDataExerciseRepository {
    func mapToListItem(_ exercise: CDExercise) -> ExerciseListItem {
        // Seřadíme recordy podle data, ať je „first/last“ korektní.
        let records = exercise.recordsArray.sorted(by: { $0.date < $1.date })
        let count = records.count
        let first = records.first?.date
        let last = records.last?.date

        // Počet dní mezi prvním a posledním záznamem.
        // - Když máme 0 záznamů, perDay je 0.
        // - Když máme 1 záznam, daysBetween vyjde 0, proto použijeme max(1,...)
        let daysBetween: Int = {
            guard let first, let last else { return 1 }
            let diff = calendar.dateComponents([.day], from: first, to: last).day ?? 0
            return max(1, diff)
        }()

        let perDay: Double = {
            guard count > 0 else { return 0 }
            return Double(count) / Double(daysBetween)
        }()

        return ExerciseListItem(
            id: exercise.id,
            name: exercise.name,
            eventsCount: count,
            firstRecord: first,
            lastRecord: last,
            perDay: perDay
        )
    }

    func saveIfNeeded() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}

