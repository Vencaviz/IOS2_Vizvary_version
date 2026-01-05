//
//  RecordExerciseView.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Obrazovka pro přidání záznamu ke konkrétnímu cviku („Record Exercise“).
//
//  Požadavky:
//  - „First record“, „Last record“, „Number of events“ jsou read-only
//  - zadávání data přes DatePicker
//  - tlačítko „Record“ uloží záznam, zvýší počítadlo a spustí animaci
//  - po animaci návrat na hlavní seznam
//

import SwiftUI

struct RecordExerciseView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: RecordExerciseViewModel

    init(exerciseId: UUID, repository: CoreDataExerciseRepository) {
        _viewModel = StateObject(wrappedValue: RecordExerciseViewModel(exerciseId: exerciseId, repository: repository))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Read-only informace
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("First record:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(dateText(viewModel.detail?.firstRecord))
                        .font(.body.weight(.semibold))
                        .monospacedDigit()
                }

                Spacer()

                VStack(alignment: .leading, spacing: 6) {
                    Text("Last record:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(dateText(viewModel.detail?.lastRecord))
                        .font(.body.weight(.semibold))
                        .monospacedDigit()
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Number of events:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(viewModel.detail?.eventsCount ?? 0)")
                    .font(.title3.bold())
                    .monospacedDigit()
            }

            Divider()

            // Zadávání data
            Text("Date")
                .font(.caption)
                .foregroundStyle(.secondary)

            DatePicker(
                "",
                selection: $viewModel.selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .accessibilityIdentifier("RecordDatePicker")

            Spacer()

            HStack {
                Spacer()
                Button("Record") {
                    viewModel.record()
                }
                .buttonStyle(FitnessPrimaryButtonStyle())
                .accessibilityIdentifier("RecordButton")
                Spacer()
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .navigationTitle("Record Exercise")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
        .fullScreenCover(isPresented: $viewModel.isPresentingCelebration) {
            CelebrationView(ballCount: viewModel.celebrationBallCount) {
                // 1) zavřeme animaci
                viewModel.isPresentingCelebration = false
                // 2) krátce poté se vrátíme na hlavní seznam (pop z NavigationStack)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    dismiss()
                }
            }
        }
    }

    private func dateText(_ date: Date?) -> String {
        guard let date else { return "-" }
        // Použijeme locale-agnostic formát, ať je to čitelné v CZ i EN.
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

