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
    @StateObject private var goalsViewModel: GoalsViewModel
    @StateObject private var recordsViewModel: RecordsViewModel
    @StateObject private var presetsVideModel: PresetsViewModel

    init() {
        let tempContainer = try! ModelContainer(
            for: TrainingDay.self,
            TrainingExercise.self,
            Goal.self,
            RecordModel.self,
            Preset.self,
            PresetExercise.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        let tempContext = ModelContext(tempContainer)

        let trainingRepository = TrainingRepository(context: tempContext)
        let recordsRepository = RecordsRepository(context: tempContext)
        let goalsRepository = GoalsRepository(context: tempContext)
        let presetsRepository = PresetsRepository(context: tempContext)

        _trainingViewModel = StateObject(
            wrappedValue: TrainingViewModel(
                repository: trainingRepository,
                presetsRepository: presetsRepository
            )
        )

        _goalsViewModel = StateObject(
            wrappedValue: GoalsViewModel(
                repository: goalsRepository,
                recordsRepository: recordsRepository
            )
        )

        _recordsViewModel = StateObject(
            wrappedValue: RecordsViewModel(repository: recordsRepository)
        )

        _presetsVideModel = StateObject(
            wrappedValue: PresetsViewModel(repository: presetsRepository)
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
                Goals(
                    viewModel: goalsViewModel
                )
            }
            Tab("Records", systemImage: "star.fill", value: .records) {
                Records(
                    viewModel: recordsViewModel
                )
            }
            Tab("Presets", systemImage: "heart.fill", value: .presets) {
                NavigationStack {
                    Presets(
                        viewModel: presetsVideModel
                    )
                }
            }
        }.onAppear {
            trainingViewModel.setContext(modelContext)
            goalsViewModel.setContext(modelContext)
            recordsViewModel.setContext(modelContext)
            presetsVideModel.setContext(modelContext)
        }
    }
}

#Preview {
    ContentView()
}
