//
//  Goal.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import Foundation
import SwiftData

@Model
class Goal {
    var name: String
    var count: Int
    var targetCount: Int
    var unit: GoalUnit

    var status: GoalStatus {
        return count >= targetCount ? .completed : .pending
    }

    init(name: String, count: Int, targetCount: Int, unit: GoalUnit) {
        self.name = name
        self.count = count
        self.targetCount = targetCount
        self.unit = unit
    }
}

enum GoalUnit: Int, Codable {
    case reps
    case sec
    case min
    case km
}

enum GoalStatus: Int, Codable {
    case pending
    case completed
}
