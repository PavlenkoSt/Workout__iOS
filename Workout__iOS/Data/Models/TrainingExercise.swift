//
//  TrainingExercise.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftData

@Model
class TrainingExercise {
    var order: Int
    var name: String
    var sets: Int
    var setsDone: Int
    var reps: Int
    var rest: Int
    var type: ExerciseType
    
    var trainingDay: TrainingDay
    
    init(name: String, order: Int = 0, sets: Int, reps: Int, rest: Int, setsDone: Int = 0, trainingDay: TrainingDay, type: ExerciseType) {
        self.name = name
        self.order = order
        self.rest = rest
        self.reps = reps
        self.sets = sets
        self.setsDone = setsDone
        self.trainingDay = trainingDay
        self.type = type
    }
}

enum ExerciseType: Int, Codable {
    case dynamic
    case staticType
    case ladder
    case warmup
    case flexibilitySession
    case handBalanceSession
}

