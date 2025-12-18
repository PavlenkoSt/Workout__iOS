//
//  PresetsRepository.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Foundation

protocol PresetsRepository {
    func createPreset(_ preset: Preset) async throws
    func addExerciseToPreset(_ presetExercise: PresetExercise) async throws
    func addExercisesToPreset(_ presetExercises: [PresetExercise]) async throws
    func deletePreset(_ preset: Preset) async throws
    func deleteExerciseFromPreset(_ presetExercise: PresetExercise) async throws
    func getPresets() async throws -> [Preset]
    func save() async throws
    func createTrainingDayFromPreset(date: Date, preset: Preset) async throws
}
