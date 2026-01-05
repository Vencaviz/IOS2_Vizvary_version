//
//  CDExerciseRecord.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Core Data entita reprezentující jeden záznam (událost) ke cviku/zvyku.
//  Typicky: „dnes jsem šel plavat“ -> record s datem.
//

import CoreData

@objc(CDExerciseRecord)
final class CDExerciseRecord: NSManagedObject {
    static let entityName = "CDExerciseRecord"
}

extension CDExerciseRecord {
    @nonobjc static func fetchRequest() -> NSFetchRequest<CDExerciseRecord> {
        NSFetchRequest<CDExerciseRecord>(entityName: entityName)
    }

    // MARK: - Core Data properties
    @NSManaged var id: UUID
    @NSManaged var date: Date

    /// Inverse relationship (povinný) na `CDExercise`.
    @NSManaged var exercise: CDExercise
}

