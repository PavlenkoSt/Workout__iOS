//
//  Record.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Foundation
import SwiftData

@Model
class RecordModel {
    var exercise: String
    var count: Int
    var unit: RecordUnit
    var date: Date

    init(exercise: String, count: Int, unit: RecordUnit, date: Date) {
        self.exercise = exercise
        self.count = count
        self.unit = unit
        self.date = date
    }
}

enum RecordUnit: Int, Codable {
    case reps
    case sec
    case min
    case km
}
