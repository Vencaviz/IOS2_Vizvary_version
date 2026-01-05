//
//  ExerciseListView.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Hlavní obrazovka se seznamem cviků.
//
//  Požadavky z obrázku:
//  - název obrazovky „Fitness“
//  - řádky jsou samostatný struct (`ExerciseRowView`)
//  - načítání záznamů z Core Data
//  - tlačítko „New exercise“ je dole uprostřed a „plave“ nad seznamem
//

import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    let repository: CoreDataExerciseRepository

    var body: some View {
        ZStack {
            List {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                }

                ForEach(viewModel.items) { item in
                    NavigationLink {
                        RecordExerciseView(exerciseId: item.id, repository: repository)
                    } label: {
                        ExerciseRowView(item: item)
                    }
                }
            }
            .listStyle(.plain)

            // „Plovoucí“ tlačítko dole uprostřed.
            VStack {
                Spacer()
                Button("New exercise") {
                    viewModel.tapNewExercise()
                }
                .buttonStyle(FitnessPrimaryButtonStyle())
                .accessibilityIdentifier("NewExerciseButton")
                .padding(.bottom, 24)
            }
            .allowsHitTesting(true)
        }
        .navigationTitle("Fitness")
        .onAppear { viewModel.onAppear() }
        .sheet(isPresented: $viewModel.isPresentingAddExercise) {
            AddExerciseView(repository: repository)
        }
    }
}

