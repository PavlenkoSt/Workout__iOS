//
//  TrainingRepository.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import Foundation
import SwiftData

enum TrainingRepositoryError: Error {
    case notFound
    case failedToSave
    case failedToFetch
}

@MainActor
final class TrainingRepository {
    private var internalContext: ModelContext

    var context: ModelContext { internalContext }

    init(context: ModelContext) {
        self.internalContext = context
    }

    func updateContext(_ newContext: ModelContext) {
        self.internalContext = newContext
    }

    func getTrainingDay(date: Date) async throws -> TrainingDay {
        let descriptor = FetchDescriptor<TrainingDay>(
            predicate: #Predicate { $0.date == date },
            sortBy: [SortDescriptor(\.date)]
        )

        guard let dayModel = try internalContext.fetch(descriptor).first else {
            throw TrainingRepositoryError.notFound
        }

        return dayModel
    }

    func addTrainingDay(_ trainingDay: TrainingDay) async throws {
        internalContext.insert(trainingDay)
        try internalContext.save()
    }

    func deleteTrainingDay(trainingDay: TrainingDay) async throws {
        internalContext.delete(trainingDay)
        try internalContext.save()
    }

    func addExercise(_ exercise: TrainingExercise) async throws {
        internalContext.insert(exercise)
        try internalContext.save()
    }

    func addExercises(_ exercises: [TrainingExercise]) async throws {
        for exercise in exercises {
            internalContext.insert(exercise)
        }
        try internalContext.save()
    }

    func deleteExercise(_ exercise: TrainingExercise) async throws {
        internalContext.delete(exercise)

        if let index = exercise.trainingDay.exercises.firstIndex(of: exercise) {
            exercise.trainingDay.exercises.remove(at: index)
        }

        try internalContext.save()
    }
}
