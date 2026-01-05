//
//  FitnessPersistenceController.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Třída zapouzdřující Core Data stack pro Fitness funkcionalitu.
//
//  Co řeší:
//  - vytvoření `NSPersistentContainer` s programově definovaným modelem
//  - volitelné in-memory úložiště (ideální pro UI testy / preview)
//  - seed demo dat (aby appka po spuštění nebyla prázdná)
//

import CoreData

final class FitnessPersistenceController {
    /// Sdílená instance pro běžné spuštění aplikace.
    static let shared = FitnessPersistenceController()

    let container: NSPersistentContainer

    /// Vytvoří persistence controller.
    /// - Parameters:
    ///   - inMemory: pokud `true`, data se neukládají na disk (testy / preview).
    ///   - seedDemoData: pokud `true`, vloží ukázková data (pokud je DB prázdná).
    init(inMemory: Bool = false, seedDemoData: Bool = false) {
        let model = FitnessManagedObjectModel.make()
        container = NSPersistentContainer(name: "FitnessModel", managedObjectModel: model)

        if inMemory {
            // `/dev/null` je standardní trik pro in-memory persistent store.
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error {
                // V reálné aplikaci sem patří sofistikovanější error handling.
                fatalError("Failed to load persistent stores: \(error)")
            }
        }

        // Konfigurace contextu:
        // - mergePolicy: když uložíme objekt, který už existuje, preferujeme „naše“ hodnoty
        // - automaticallyMergesChangesFromParent: lepší UX v případě background saves
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true

        if seedDemoData {
            seedDemoDataIfNeeded()
        }
    }
}

// MARK: - Demo data
private extension FitnessPersistenceController {
    func seedDemoDataIfNeeded() {
        let context = container.viewContext

        // Pokud už máme aspoň 1 cvik, nic neseedujeme.
        let request = CDExercise.fetchRequest()
        request.fetchLimit = 1
        let existing = (try? context.count(for: request)) ?? 0
        guard existing == 0 else { return }

        // Vytvoříme 2 cviky podle mockupu.
        let swimming = CDExercise(context: context)
        swimming.id = UUID()
        swimming.name = "Swimming"
        swimming.createdAt = Date()

        let running = CDExercise(context: context)
        running.id = UUID()
        running.name = "Running"
        running.createdAt = Date()

        // Helper pro výrobu date z komponent (kvůli determinismu).
        func makeDate(day: Int, month: Int, year: Int) -> Date {
            var comps = DateComponents()
            comps.calendar = Calendar(identifier: .gregorian)
            comps.timeZone = TimeZone(secondsFromGMT: 0)
            comps.day = day
            comps.month = month
            comps.year = year
            return comps.date ?? Date()
        }

        // „Swimming“: 1 záznam 2.5.2025 => v detailu bude první i poslední stejné.
        let swimRecord = CDExerciseRecord(context: context)
        swimRecord.id = UUID()
        swimRecord.date = makeDate(day: 2, month: 5, year: 2025)
        swimRecord.exercise = swimming

        // „Running“: 3 záznamy 2.5., 3.5., 4.5.2025
        let runDates = [
            makeDate(day: 2, month: 5, year: 2025),
            makeDate(day: 3, month: 5, year: 2025),
            makeDate(day: 4, month: 5, year: 2025),
        ]

        for d in runDates {
            let r = CDExerciseRecord(context: context)
            r.id = UUID()
            r.date = d
            r.exercise = running
        }

        do {
            try context.save()
        } catch {
            // Seed data není kritická, proto tady pouze logicky „fallback“.
            context.rollback()
        }
    }
}

