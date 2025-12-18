//
//  PresetsViewModel.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

@MainActor
class PresetsViewModel: ObservableObject {
    private let repository: PresetsRepositoryImpl

    init(repository: PresetsRepositoryImpl) {
        self.repository = repository
    }

    func setContext(_ context: ModelContext) {
        self.repository.updateContext(context)
    }

    func createPreset(result: PresetSubmitResult) {
        Task {
            do {
                let presets = try await self.repository.getPresets()
                let maxPresetOrder = presets.map { $0.order }.max()
                try await self.repository.createPreset(
                    Preset(
                        name: result.name,
                        order: (maxPresetOrder ?? 0) + 1
                    )
                )
            } catch {
                print("Failed to create preset - \(error.localizedDescription)")
            }
        }
    }

    func updatePreset(presetToUpdate: Preset, result: PresetSubmitResult) {
        presetToUpdate.name = result.name
    }

    func deletePreset(preset: Preset) {
        Task {
            do {
                try await self.repository.deletePreset(preset)
            } catch {
                print("Failed to delete preset - \(error.localizedDescription)")
            }
        }
    }

    func deleteExercise(exercise: PresetExercise) {
        Task {
            do {
                try await self.repository.deleteExerciseFromPreset(exercise)
            } catch {
                print(
                    "Failed to delete preset exercise - \(error.localizedDescription)"
                )
            }
        }
    }

    func updatePresetOrder(presets: [Preset]) {
        Task {
            do {
                for (index, preset) in presets.enumerated() {
                    if preset.order != index {
                        preset.order = index
                    }
                }

                try await self.repository.save()

            } catch {
                print(
                    "Failed to update preset order - \(error.localizedDescription)"
                )
            }
        }
    }

    func addDefaultExerciseToPreset(
        exerciseFormResult: DefaultExerciseSubmitResult,
        preset: Preset,
    ) {
        Task {
            do {

                if preset.exercises.isEmpty {
                    let warmup = PresetExercise(
                        name: "Warmup",
                        sets: 1,
                        reps: 1,
                        rest: 0,
                        preset: preset,
                        type: ExerciseType.warmup
                    )

                    try await repository.addExerciseToPreset(warmup)
                }

                let exercise = PresetExercise(
                    name: exerciseFormResult.name,
                    sets: exerciseFormResult.sets,
                    reps: exerciseFormResult.reps,
                    rest: exerciseFormResult.rest,
                    preset: preset,
                    type: exerciseFormResult.exerciseType
                )

                try await repository.addExerciseToPreset(exercise)

            } catch {
                print("Failed to add default exercise. Error: \(error)")
            }
        }
    }

    func addLadderExerciseToPreset(
        exerciseFormResult: LadderExerciseSubmitResult,
        preset: Preset
    ) {
        Task {
            do {

                if preset.exercises.isEmpty {
                    let warmup = PresetExercise(
                        name: "Warmup",
                        sets: 1,
                        reps: 1,
                        rest: 0,
                        preset: preset,
                        type: ExerciseType.warmup
                    )

                    try await repository.addExerciseToPreset(warmup)
                }

                let exercises = mapLadderPresetExercises(
                    exerciseFormResult: exerciseFormResult,
                    preset: preset
                )

                try await repository.addExercisesToPreset(exercises)

            } catch {
                print("Failed to add ladder exercise. Error: \(error)")
            }
        }
    }

    func addSimpleExerciseToPreset(
        exerciseFormResult: SimpleExerciseSubmitResult,
        preset: Preset
    ) {
        Task {
            do {
                if preset.exercises.isEmpty {
                    let warmup = PresetExercise(
                        name: "Warmup",
                        sets: 1,
                        reps: 1,
                        rest: 0,
                        preset: preset,
                        type: ExerciseType.warmup
                    )

                    try await repository.addExerciseToPreset(warmup)
                }

                let exercise = PresetExercise(
                    name: "simple_exercise",
                    sets: 1,
                    reps: 1,
                    rest: 1,
                    preset: preset,
                    type: exerciseFormResult.exerciseType
                )

                try await repository.addExerciseToPreset(exercise)
            } catch {
                print("Failed to add simple exercise. Error: \(error)")
            }
        }
    }

    func createTrainingDayFromPreset(date: Date, preset: Preset) async throws {
        try await repository.createTrainingDayFromPreset(
            date: date,
            preset: preset
        )
    }

    private func mapLadderPresetExercises(
        exerciseFormResult: LadderExerciseSubmitResult,
        preset: Preset
    ) -> [PresetExercise] {
        var exercises: [PresetExercise] = []

        let shouldIncrement = exerciseFormResult.from < exerciseFormResult.to

        var current = exerciseFormResult.from

        repeat {
            exercises.append(
                PresetExercise(
                    name: exerciseFormResult.name,
                    order: exercises.count,
                    sets: 1,
                    reps: current,
                    rest: exerciseFormResult.rest,
                    preset: preset,
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
