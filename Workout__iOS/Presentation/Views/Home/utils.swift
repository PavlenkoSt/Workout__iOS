//
//  utils.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 08.12.2025.
//

import Foundation

func getTrainingDayForPreview() -> TrainingDay {
    let trainingDay: TrainingDay = TrainingDay(date: Date())

    let exercises: [TrainingExercise] = [
        TrainingExercise(
            name: "Push ups",
            sets: 4,
            reps: 12,
            rest: 120,
            trainingDay: trainingDay,
            type: ExerciseType.dynamic
        ),
        TrainingExercise(
            name: "Pull ups",
            sets: 2,
            reps: 20,
            rest: 60,
            trainingDay: trainingDay,
            type: ExerciseType.dynamic
        ),
    ]
    trainingDay.exercises = exercises

    return trainingDay
}

func getExerciseName(exercise: TrainingExercise) -> String {
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
