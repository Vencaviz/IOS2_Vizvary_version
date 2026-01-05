//
//  FitnessManagedObjectModel.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Poznámka:
//  - V klasickém iOS projektu se Core Data model často řeší přes `.xcdatamodeld`.
//  - V tomto repozitáři je ale projekt nastavený na „file system synchronized“ skupiny,
//    kde je úprava `.pbxproj` (a přidání `.xcdatamodeld`) zbytečně křehké.
//  - Proto model definujeme programově pomocí `NSManagedObjectModel`.
//
//  Výhody:
//  - Žádné ruční editace Xcode projektu.
//  - Model je plně verzovatelný v gitu jako čistý kód.
//
//  Nevýhody:
//  - Nemáte „vizuální“ editor modelu v Xcode.
//

import CoreData

/// Namespace pro vytvoření Core Data modelu pro „Fitness“ část aplikace.
///
/// Model obsahuje:
/// - `CDExercise`: konkrétní „zvyk/cvik“ (např. Swimming, Running)
/// - `CDExerciseRecord`: jednotlivý záznam (událost) s datem
enum FitnessManagedObjectModel {
    /// Vytvoří a vrátí `NSManagedObjectModel` pro Fitness.
    static func make() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // MARK: - Entity: CDExercise
        let exerciseEntity = NSEntityDescription()
        exerciseEntity.name = CDExercise.entityName
        exerciseEntity.managedObjectClassName = NSStringFromClass(CDExercise.self)

        // Atributy pro `CDExercise`
        let exerciseId = NSAttributeDescription()
        exerciseId.name = "id"
        exerciseId.attributeType = .UUIDAttributeType
        exerciseId.isOptional = false

        let exerciseName = NSAttributeDescription()
        exerciseName.name = "name"
        exerciseName.attributeType = .stringAttributeType
        exerciseName.isOptional = false

        let exerciseCreatedAt = NSAttributeDescription()
        exerciseCreatedAt.name = "createdAt"
        exerciseCreatedAt.attributeType = .dateAttributeType
        exerciseCreatedAt.isOptional = false

        exerciseEntity.properties = [exerciseId, exerciseName, exerciseCreatedAt]

        // MARK: - Entity: CDExerciseRecord
        let recordEntity = NSEntityDescription()
        recordEntity.name = CDExerciseRecord.entityName
        recordEntity.managedObjectClassName = NSStringFromClass(CDExerciseRecord.self)

        let recordId = NSAttributeDescription()
        recordId.name = "id"
        recordId.attributeType = .UUIDAttributeType
        recordId.isOptional = false

        let recordDate = NSAttributeDescription()
        recordDate.name = "date"
        recordDate.attributeType = .dateAttributeType
        recordDate.isOptional = false

        recordEntity.properties = [recordId, recordDate]

        // MARK: - Relationships
        // 1) CDExercise (1) -> (many) CDExerciseRecord
        let exerciseToRecords = NSRelationshipDescription()
        exerciseToRecords.name = "records"
        exerciseToRecords.destinationEntity = recordEntity
        exerciseToRecords.minCount = 0
        exerciseToRecords.maxCount = 0 // 0 == „to-many“ bez limitu
        exerciseToRecords.deleteRule = .cascadeDeleteRule
        exerciseToRecords.isOptional = true
        exerciseToRecords.isOrdered = true // v UI často chceme stabilní pořadí

        // 2) CDExerciseRecord (many) -> (1) CDExercise
        let recordToExercise = NSRelationshipDescription()
        recordToExercise.name = "exercise"
        recordToExercise.destinationEntity = exerciseEntity
        recordToExercise.minCount = 1
        recordToExercise.maxCount = 1
        recordToExercise.deleteRule = .nullifyDeleteRule
        recordToExercise.isOptional = false

        // Propojíme inverse relationships (důležité pro konzistenci v Core Data).
        exerciseToRecords.inverseRelationship = recordToExercise
        recordToExercise.inverseRelationship = exerciseToRecords

        // Přidáme relationship do entit.
        exerciseEntity.properties.append(exerciseToRecords)
        recordEntity.properties.append(recordToExercise)

        model.entities = [exerciseEntity, recordEntity]
        return model
    }
}

