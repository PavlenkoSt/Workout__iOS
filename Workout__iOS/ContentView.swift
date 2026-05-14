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
    @StateObject private var presetsViewModel: PresetsViewModel
    @StateObject private var monetizationViewModel = MonetizationViewModel()

    @State private var isShowingPaywall = false

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

        _presetsViewModel = StateObject(
            wrappedValue: PresetsViewModel(repository: presetsRepository)
        )
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                Home(
                    viewModel: trainingViewModel,
                    monetizationState: monetizationViewModel.state,
                    presentPaywall: presentPaywall
                )
            }
            Tab("Goals", systemImage: "checkmark", value: .goals) {
                Goals(
                    viewModel: goalsViewModel,
                    monetizationState: monetizationViewModel.state,
                    presentPaywall: presentPaywall
                )
            }
            Tab("Records", systemImage: "star.fill", value: .records) {
                Records(
                    viewModel: recordsViewModel,
                    monetizationState: monetizationViewModel.state,
                    presentPaywall: presentPaywall
                )
            }
            Tab("Presets", systemImage: "heart.fill", value: .presets) {
                NavigationStack {
                    Presets(
                        viewModel: presetsViewModel,
                        monetizationState: monetizationViewModel.state,
                        presentPaywall: presentPaywall
                    )
                }
            }
        }
        .tint(.indigo)
        .sheet(isPresented: $isShowingPaywall) {
            PaywallSheet(viewModel: monetizationViewModel)
        }
        .onAppear {
            trainingViewModel.setContext(modelContext)
            goalsViewModel.setContext(modelContext)
            recordsViewModel.setContext(modelContext)
            presetsViewModel.setContext(modelContext)
            monetizationViewModel.refresh()
        }
    }

    private func presentPaywall() {
        guard RevenueCatInitializer.configure() else { return }
        isShowingPaywall = true
    }
}

#Preview {
    ContentView()
}
