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

    var status: TrainingDayStatus {
        var isCompleted = true

        exercises.forEach {
            if $0.setsDone < $0.sets {
                isCompleted = false
            }
        }

        if !isCompleted {
            let calendar = Calendar.current
            let comparisonResult = calendar.compare(
                Date(),
                to: date,
                toGranularity: .day
            )
            if comparisonResult == .orderedDescending {
                return .failed
            } else {
                return .pending
            }
        } else {
            return .completed
        }
    }

    init(date: Date) {
        self.date = date
    }
}

enum TrainingDayStatus: Int {
    case completed
    case pending
    case failed
}
