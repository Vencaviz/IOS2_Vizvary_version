//
//  FitnessRootView.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Root view pro celý Fitness flow.
//
//  Proč existuje:
//  - Chceme mít jedno místo, kde vytvoříme „dependencies“ (CoreData repository, view modely)
//    a předáme je níž do UI.
//  - V MVVM se snažíme nedělat „business“ logiku ve View.
//

import CoreData
import SwiftUI

struct FitnessRootView: View {
    private let context: NSManagedObjectContext
    private let repository: CoreDataExerciseRepository

    @StateObject private var listViewModel: ExerciseListViewModel

    init(context: NSManagedObjectContext) {
        self.context = context
        let repo = CoreDataExerciseRepository(context: context)
        self.repository = repo
        _listViewModel = StateObject(wrappedValue: ExerciseListViewModel(repository: repo, context: context))
    }

    var body: some View {
        NavigationStack {
            ExerciseListView(viewModel: listViewModel, repository: repository)
        }
        // Předáváme context i přes environment, aby ho případně šlo použít i v subviews.
        .environment(\.managedObjectContext, context)
    }
}

