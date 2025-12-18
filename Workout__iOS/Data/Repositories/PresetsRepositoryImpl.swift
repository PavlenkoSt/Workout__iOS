//
//  PresetsRepositoryImpl.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Foundation
import SwiftData

@MainActor
final class PresetsRepositoryImpl: PresetsRepository {
    private var internalContext: ModelContext

    var context: ModelContext { internalContext }

    init(context: ModelContext) {
        self.internalContext = context
    }

    func updateContext(_ newContext: ModelContext) {
        self.internalContext = newContext
    }

    func getPresets() async throws -> [Preset] {
        let descriptor = FetchDescriptor<Preset>()
        return try self.internalContext.fetch(descriptor)
    }

    func createPreset(_ preset: Preset) async throws {
        self.internalContext.insert(preset)
        try self.internalContext.save()
    }

    func addExerciseToPreset(_ presetExercise: PresetExercise) async throws {
        self.internalContext.insert(presetExercise)
        try self.internalContext.save()
    }

    func addExercisesToPreset(_ presetExercises: [PresetExercise]) async throws
    {
        for exercise in presetExercises {
            internalContext.insert(exercise)
        }
        try internalContext.save()
    }

    func deletePreset(_ preset: Preset) async throws {
        self.internalContext.delete(preset)
        try self.internalContext.save()
    }

    func deleteExerciseFromPreset(_ presetExercise: PresetExercise) async throws
    {
        self.internalContext.delete(presetExercise)
        try self.internalContext.save()
    }

    func save() async throws {
        try self.internalContext.save()
    }

    func createTrainingDayFromPreset(date: Date, preset: Preset) async throws {
        let calendar = Calendar.current
            
        let startDate = calendar.startOfDay(for: date)
        
        let descriptor = FetchDescriptor<TrainingDay>(
            predicate: #Predicate { $0.date == startDate }
        )

        let trainingDay = try self.internalContext.fetch(descriptor).first

        if trainingDay != nil {
            throw TrainingError.dayAlreadyExists
        }

        let createdTrainingDay = TrainingDay(date: startDate)
        var exercises: [TrainingExercise] = []

        preset.exercises.forEach { presetExercise in
            exercises.append(
                TrainingExercise(
                    name: presetExercise.name,
                    order: exercises.count,
                    sets: presetExercise.sets,
                    reps: presetExercise.reps,
                    rest: presetExercise.rest,
                    trainingDay: createdTrainingDay,
                    type: presetExercise.type,
                )
            )
        }

        exercises.forEach { exercise in
            self.internalContext.insert(exercise)
        }
        
        self.internalContext.insert(createdTrainingDay)

        try self.internalContext.save()
    }
}

enum TrainingError: LocalizedError {
    case dayAlreadyExists

    var errorDescription: String? {
        switch self {
        case .dayAlreadyExists:
            return "A training session is already scheduled for this date."
        }
    }
}
