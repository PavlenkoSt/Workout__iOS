//
//  GoalsRepository.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import Foundation
import SwiftData

@MainActor
final class GoalsRepositoryImpl: GoalsRepository {
    private var internalContext: ModelContext

    var context: ModelContext { internalContext }

    init(context: ModelContext) {
        self.internalContext = context
    }

    func updateContext(_ newContext: ModelContext) {
        self.internalContext = newContext
    }

    func addGoal(goal: Goal) async throws {
        internalContext.insert(goal)
        try internalContext.save()
    }
}
