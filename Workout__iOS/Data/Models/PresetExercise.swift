//
//  PresetExercise.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Foundation
import SwiftData

@Model
class PresetExercise {
    var order: Int
    var name: String
    var sets: Int
    var reps: Int
    var rest: Int
    var type: ExerciseType

    var preset: Preset

    init(
        name: String,
        order: Int,
        sets: Int,
        reps: Int,
        rest: Int,
        preset: Preset,
        type: ExerciseType
    ) {
        self.name = name
        self.order = order
        self.rest = rest
        self.reps = reps
        self.sets = sets
        self.preset = preset
        self.type = type
    }
}
