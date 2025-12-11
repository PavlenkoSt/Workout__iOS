//
//  ContentView.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftData
import SwiftUI

enum Tabs: Equatable, Hashable {
    case home
    case goals
    case records
    case presets
}

struct ContentView: View {
    @State private var selectedTab: Tabs = .home

    @Environment(\.modelContext) private var modelContext
    @StateObject private var trainingViewModel: TrainingViewModel

    init() {
        // we can't use @Environment in init, so we do this:
        // create a placeholder, then actually set in body,
        // or use a static factory. Easiest trick:
        _trainingViewModel = StateObject(
            wrappedValue: TrainingViewModel(
                repository: TrainingRepositoryImpl(
                    context: ModelContext(
                        try! ModelContainer(
                            for: TrainingDay.self,
                            TrainingExercise.self
                        )
                    )
                )
            )
        )
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                Home(
                    viewModel: trainingViewModel
                )
            }
            Tab("Goals", systemImage: "checkmark", value: .goals) {
                Goals()
            }
            Tab("Records", systemImage: "star.fill", value: .records) {
                Records()
            }
            Tab("Presets", systemImage: "heart.fill", value: .presets) {
                Presets()
            }
        }
    }
}

#Preview {
    ContentView()
}
