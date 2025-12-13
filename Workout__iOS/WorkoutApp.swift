//
//  WorkoutApp.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftData
import SwiftUI

@main
struct WorkoutApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: TrainingDay.self,
                TrainingExercise.self,
                Goal.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(container)
    }
}
