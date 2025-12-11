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
        let tempContainer = try! ModelContainer(
            for: TrainingDay.self,
            TrainingExercise.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        let tempContext = ModelContext(tempContainer)

        let repository = TrainingRepositoryImpl(context: tempContext)
        _trainingViewModel = StateObject(
            wrappedValue: TrainingViewModel(repository: repository)
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
        }.onAppear {
            trainingViewModel.setContext(modelContext)
        }
    }
}

#Preview {
    ContentView()
}
