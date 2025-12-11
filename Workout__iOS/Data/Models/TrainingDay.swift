//
//  TrainingDay.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import Foundation
import SwiftData

@Model
class TrainingDay {
    @Attribute(.unique)
    var date: Date

    @Relationship(
        deleteRule: .cascade,
        inverse: \TrainingExercise.trainingDay
    )
    var exercises: [TrainingExercise] = []

    init(date: Date) {
        self.date = date
    }
}

enum TrainingDayStatus: Int {
    case completed
    case pending
    case failed
}
