//
//  TrainingDayRepository.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import Foundation

protocol TrainingDayRepository {
    func getTrainingDay(date: Date) async throws -> TrainingDay
    func deleteTrainingDay(trainingDay: TrainingDay) async throws
    func addTrainingDay(_ trainingDay: TrainingDay) async throws
    func deleteExercise(_ exercise: TrainingExercise) async throws
    func addExercise(_ exercise: TrainingExercise) async throws
    func addExercises(_ exercises: [TrainingExercise]) async throws
}
