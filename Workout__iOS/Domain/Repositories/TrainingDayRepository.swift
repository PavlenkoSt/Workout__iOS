//
//  TrainingDayRepository.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import Foundation

protocol TrainingDayRepository {
    func getTrainingDay(date: Date) async throws -> TrainingDay
    func addTrainingDay(_ trainingDay: TrainingDay) async throws
    func addExercise(_ exercise: TrainingExercise) async throws
    func updateExercise(_ exercise: TrainingExercise) async throws
}
