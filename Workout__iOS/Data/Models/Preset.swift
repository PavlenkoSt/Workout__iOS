//
//  Preset.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Foundation
import SwiftData

@Model
class Preset {
    var name: String
    var order: Int

    @Relationship(
        deleteRule: .cascade,
        inverse: \PresetExercise.preset
    )
    var exercises: [PresetExercise] = []

    init(name: String, order: Int = 0) {
        self.name = name
        self.order = order
    }
}
