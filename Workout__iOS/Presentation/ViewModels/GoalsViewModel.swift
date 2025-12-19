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
    private let repository: GoalsRepository
    private let recordsRepository: RecordsRepository

    init(
        repository: GoalsRepository,
        recordsRepository: RecordsRepository
    ) {
        self.repository = repository
        self.recordsRepository = recordsRepository
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

    func updateGoal(goalToUpdate: Goal, goalSubmitResult: GoalSubmitResult) {
        goalToUpdate.targetCount = goalSubmitResult.targetCount
        goalToUpdate.name = goalSubmitResult.name
        goalToUpdate.unit = goalSubmitResult.units
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

    func moveToRecords(goal: Goal) async throws {
        let existingRecord = self.recordsRepository
            .getRecordByExercise(
                goal.name
            )

        if let existingRecord = existingRecord {
            if existingRecord.count >= goal.count {
                throw GoalError.alreadyExists(
                    description: "Record already exists"
                )
            } else {
                existingRecord.count = goal.count
            }
        } else {
            try await self.recordsRepository.addRecord(
                RecordModel(
                    exercise: goal.name,
                    count: goal.count,
                    unit: mapGoalUnitsToRecordUnits(goal.unit),
                    date: Date()
                )
            )
        }
    }

    private func mapGoalUnitsToRecordUnits(_ goalUnits: GoalUnit) -> RecordUnit
    {
        switch goalUnits {
        case .km:
            return RecordUnit.km
        case .reps:
            return RecordUnit.reps
        case .min:
            return RecordUnit.min
        case .sec:
            return RecordUnit.sec

        }
    }
}

enum GoalError: Error {
    case alreadyExists(description: String)
}
