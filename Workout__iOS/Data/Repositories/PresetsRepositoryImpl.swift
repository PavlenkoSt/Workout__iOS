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
}
