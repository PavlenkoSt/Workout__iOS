//
//  GoalsViewModel.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

@MainActor
class GoalsViewModel: ObservableObject {
    private let repository: GoalsRepositoryImpl

    init(repository: GoalsRepositoryImpl) {
        self.repository = repository
    }

    func setContext(_ context: ModelContext) {
        self.repository.updateContext(context)
    }

    func addGoal(goalSubmitResult: GoalSubmitResult) {
        Task {
            do {
                try await self.repository.addGoal(
                    goal: Goal(
                        name: goalSubmitResult.name,
                        count: 0,
                        targetCount: goalSubmitResult.targetCount,
                        unit: goalSubmitResult.units,
                    )
                )
            } catch {
                print("Error on add goal. Error \(error.localizedDescription)")
            }
        }
    }

    func deleteGoal(goal: Goal) {
        Task {
            do {
                try await self.repository.deleteGoal(goal: goal)
            } catch {
                print(
                    "Error on delete goal. Error \(error.localizedDescription)"
                )
            }
        }
    }
}
