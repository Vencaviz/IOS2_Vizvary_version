//
//  CDExercise.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Core Data entita reprezentující jeden „zvyk/cvik“ v seznamu.
//
//  Poznámka k architektuře:
//  - I když je to NSManagedObject (tedy „datová“ vrstva),
//    ViewModely by s ním měly pracovat přes Repository, ne přímo přes `NSManagedObjectContext`,
//    aby se logika dala snáze testovat a měnit.
//

import CoreData

@objc(CDExercise)
final class CDExercise: NSManagedObject {
    static let entityName = "CDExercise"
}

extension CDExercise {
    /// Pomocný typed fetch request.
    @nonobjc static func fetchRequest() -> NSFetchRequest<CDExercise> {
        NSFetchRequest<CDExercise>(entityName: entityName)
    }

    // MARK: - Core Data properties (KVC backed)
    //
    // Tyto vlastnosti nejsou generované `.xcdatamodeld`,
    // proto je deklarujeme ručně a označíme `@NSManaged`.
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var createdAt: Date

    /// Relationship: ordered set záznamů.
    @NSManaged var records: NSOrderedSet?
}

extension CDExercise {
    /// Bezpečný převod `records` na `[CDExerciseRecord]`.
    var recordsArray: [CDExerciseRecord] {
        (records?.array as? [CDExerciseRecord]) ?? []
    }
}

