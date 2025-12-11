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

    func setContext(_ context: ModelContext) {
        self.repository.updateContext(context)
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

                    let warmup = TrainingExercise(
                        name: "Warmup",
                        sets: 1,
                        reps: 1,
                        rest: 0,
                        trainingDay: trainingDay,
                        type: ExerciseType.warmup
                    )
                    let exercise = TrainingExercise(
                        name: exerciseFormResult.name,
                        sets: exerciseFormResult.sets,
                        reps: exerciseFormResult.reps,
                        rest: exerciseFormResult.rest,
                        trainingDay: trainingDay,
                        type: exerciseFormResult.exerciseType
                    )
                    try await repository.addExercise(warmup)
                    try await repository.addExercise(exercise)
                }
            } catch {
                print("Failed to add default exercise. Error: \(error)")
            }
        }
    }

    func addLadderExercise(
        date: Date,
        exerciseFormResult: LadderExerciseSubmitResult
    ) {
        Task {
            do {
                let trainingDayExists = try? await repository.getTrainingDay(
                    date: date
                )

                if let trainingDay = trainingDayExists {
                    let exercises = mapLadderExercises(
                        exerciseFormResult: exerciseFormResult,
                        trainingDay: trainingDay
                    )

                    try await repository.addExercises(exercises)
                } else {
                    let trainingDay = TrainingDay(date: date)
                    
                    let warmup = TrainingExercise(
                        name: "Warmup",
                        sets: 1,
                        reps: 1,
                        rest: 0,
                        trainingDay: trainingDay,
                        type: ExerciseType.warmup
                    )

                    let exercises = mapLadderExercises(
                        exerciseFormResult: exerciseFormResult,
                        trainingDay: trainingDay
                    )

                    try await repository.addTrainingDay(trainingDay)
                    try await repository.addExercise(warmup)
                    try await repository.addExercises(exercises)
                }
            } catch {
                print("Failed to add ladder exercise. Error: \(error)")
            }
        }
    }

    func addSimpleExercise(
        date: Date,
        exerciseFormResult: SimpleExerciseSubmitResult
    ) {
        Task {
            do {
                let trainingDayExists = try? await repository.getTrainingDay(
                    date: date
                )

                if let trainingDay = trainingDayExists {
                    let exercise = TrainingExercise(
                        name: "simple_exercise",
                        sets: 1,
                        reps: 1,
                        rest: 1,
                        trainingDay: trainingDay,
                        type: exerciseFormResult.exerciseType
                    )

                    try await repository.addExercise(exercise)
                } else {
                    let trainingDay = TrainingDay(date: date)
                    
                    let warmup = TrainingExercise(
                        name: "Warmup",
                        sets: 1,
                        reps: 1,
                        rest: 0,
                        trainingDay: trainingDay,
                        type: ExerciseType.warmup
                    )

                    let exercise = TrainingExercise(
                        name: "simple_exercise",
                        sets: 1,
                        reps: 1,
                        rest: 1,
                        trainingDay: trainingDay,
                        type: exerciseFormResult.exerciseType
                    )

                    try await repository.addTrainingDay(trainingDay)
                    try await repository.addExercise(warmup)
                    try await repository.addExercise(exercise)
                }
            } catch {
                print("Failed to add simple exercise. Error: \(error)")
            }
        }
    }

    private func mapLadderExercises(
        exerciseFormResult: LadderExerciseSubmitResult,
        trainingDay: TrainingDay
    ) -> [TrainingExercise] {
        var exercises: [TrainingExercise] = []

        let shouldIncrement = exerciseFormResult.from < exerciseFormResult.to

        var current = exerciseFormResult.from

        repeat {
            exercises.append(
                TrainingExercise(
                    name: exerciseFormResult.name,
                    order: exercises.count,
                    sets: 1,
                    reps: current,
                    rest: exerciseFormResult.rest,
                    trainingDay: trainingDay,
                    type: ExerciseType.dynamic
                )
            )
            if shouldIncrement {
                current += exerciseFormResult.step
            } else {
                current -= exerciseFormResult.step
            }

        } while shouldIncrement
            ? current <= exerciseFormResult.to
            : current >= exerciseFormResult.to

        return exercises
    }
}
