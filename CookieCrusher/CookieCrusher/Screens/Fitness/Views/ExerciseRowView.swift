//
//  ExerciseRowView.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Samostatný view pro jeden řádek v seznamu (zadání: „Řádek tabulky mějte jako samostatný struct“).
//

import SwiftUI

struct ExerciseRowView: View {
    let item: ExerciseListItem

    var body: some View {
        HStack(alignment: .center) {
            Text(item.name)
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(perDayText)
                    .font(.headline)
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                Text("per day")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
        // Identifikátor pro UI testy (těžko se pak „loví“ konkrétní řádky).
        .accessibilityIdentifier("ExerciseRow_\(item.name)")
    }

    private var perDayText: String {
        // V mockupu je např. 0.5, 2, atd. => 0–1 desetinné místo.
        let value = item.perDay
        if abs(value.rounded() - value) < 0.0001 {
            return String(Int(value.rounded()))
        }
        return String(format: "%.1f", value)
    }
}

