//
//  AddExerciseView.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Modální okno „Add Exercise“ (zadání: „Toto je modální okno“).
//
//  UX poznámky:
//  - používáme NavigationStack, aby toolbar „Cancel / Save“ vypadal jako v mockupu
//  - TextField je pojmenovaný „Description“ podle obrázku
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: AddExerciseViewModel

    init(repository: CoreDataExerciseRepository) {
        _viewModel = StateObject(wrappedValue: AddExerciseViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Swimming", text: $viewModel.name)
                        .textInputAutocapitalization(.words)
                        .accessibilityIdentifier("AddExerciseNameTextField")
                } header: {
                    Text("Description")
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Add Exercise")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.save() {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

