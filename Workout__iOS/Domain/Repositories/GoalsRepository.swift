//
//  GoalsRepository.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import Foundation

protocol GoalsRepository {
    func addGoal(goal: Goal) async throws
}
