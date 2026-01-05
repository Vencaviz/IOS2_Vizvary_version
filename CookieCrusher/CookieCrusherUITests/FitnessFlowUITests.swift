//
//  FitnessFlowUITests.swift
//  CookieCrusherUITests
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  UI test podle zadání:
//  „Napište UI test, který kontroluje, zda se vytvoří správně obrazovka pro přidání záznamu zvyku.“
//
//  Co testujeme:
//  - z hlavního seznamu otevřeme detail („Record Exercise“) pro existující položku
//  - ověříme, že detail obsahuje všechny důležité prvky (texty + DatePicker + tlačítko Record)
//

import XCTest

final class FitnessFlowUITests: XCTestCase {
    @MainActor
    func testRecordExerciseScreenContainsAllRequiredElements() throws {
        let app = XCUIApplication()

        // Spustíme Fitness flow a zapneme testovací režim (in-memory Core Data + seed dat).
        app.launchArguments = ["-fitness", "-ui-testing"]
        app.launch()

        // Ověříme, že jsme na hlavním seznamu.
        XCTAssertTrue(app.navigationBars["Fitness"].waitForExistence(timeout: 3))

        // V seed datech existuje „Swimming“.
        app.staticTexts["Swimming"].tap()

        // Jsme na detailu.
        XCTAssertTrue(app.navigationBars["Record Exercise"].waitForExistence(timeout: 3))

        // Read-only sekce.
        XCTAssertTrue(app.staticTexts["First record:"].exists)
        XCTAssertTrue(app.staticTexts["Last record:"].exists)
        XCTAssertTrue(app.staticTexts["Number of events:"].exists)

        // Date + DatePicker.
        XCTAssertTrue(app.staticTexts["Date"].exists)
        // SwiftUI DatePicker se v XCTest může zobrazit jako `datePicker` nebo jako `otherElement`
        // (záleží na stylu a iOS verzi). Proto testujeme obě možnosti.
        XCTAssertTrue(
            app.datePickers["RecordDatePicker"].exists || app.otherElements["RecordDatePicker"].exists
        )

        // Record button.
        XCTAssertTrue(app.buttons["RecordButton"].exists)
    }
}

