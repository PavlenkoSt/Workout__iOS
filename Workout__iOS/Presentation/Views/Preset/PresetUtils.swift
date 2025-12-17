//
//  PresetUtils.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 17.12.2025.
//

func getPresetExerciseName(exercise: PresetExercise) -> String {
    if exercise.type == .flexibilitySession {
        return "Flexibility session"
    } else if exercise.type == .handBalanceSession {
        return "Hand balance session"
    } else if exercise.type == .warmup {
        return "Warmup"
    } else {
        return exercise.name
    }
}
