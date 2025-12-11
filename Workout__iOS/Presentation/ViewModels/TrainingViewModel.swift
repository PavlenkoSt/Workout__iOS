//
//  TrainingViewModel.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 08.12.2025.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

@MainActor
class TrainingViewModel: ObservableObject {
    private let repository: TrainingRepositoryImpl

    init(repository: TrainingRepositoryImpl) {
        self.repository = repository
    }

    func deleteExercise(_ exercise: TrainingExercise) {
        Task {
            do {
                try await repository.deleteExercise(exercise)
            } catch {
                print("Failed to delete default exercise. Error: \(error)")
            }
        }
    }

    func addDefaultExercise(
        date: Date,
        exerciseFormResult: DefaultExerciseSubmitResult
    ) {
        Task {
            do {
                let trainingDayExists = try? await repository.getTrainingDay(
                    date: date
                )

                if let trainingDay = trainingDayExists {
                    let exercise = TrainingExercise(
                        name: exerciseFormResult.name,
                        sets: exerciseFormResult.sets,
                        reps: exerciseFormResult.reps,
                        rest: exerciseFormResult.rest,
                        trainingDay: trainingDay,
                        type: exerciseFormResult.exerciseType
                    )

                    try await repository.addExercise(exercise)
                } else {
                    let trainingDay = TrainingDay(date: date)
                    try await repository.addTrainingDay(trainingDay)
                    let exercise = TrainingExercise(
                        name: exerciseFormResult.name,
                        sets: exerciseFormResult.sets,
                        reps: exerciseFormResult.reps,
                        rest: exerciseFormResult.rest,
                        trainingDay: trainingDay,
                        type: exerciseFormResult.exerciseType
                    )
                    try await repository.addExercise(exercise)
                }
            } catch {
                print("Failed to add default exercise. Error: \(error)")
            }
        }
    }
}
