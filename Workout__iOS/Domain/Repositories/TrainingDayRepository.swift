//
//  TrainingDayRepository.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import Foundation

protocol TrainingDayRepository {
    func getTrainingDay(date: Date) async throws -> TrainingDay
}
