//
//  RecordsRepository.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Foundation
import SwiftData

@MainActor
final class RecordsRepository {
    private var internalContext: ModelContext

    var context: ModelContext { internalContext }

    init(context: ModelContext) {
        self.internalContext = context
    }

    func updateContext(_ newContext: ModelContext) {
        self.internalContext = newContext
    }

    func addRecord(_ record: RecordModel) async throws {
        self.internalContext.insert(record)
        try self.internalContext.save()
    }

    func deleteRecord(_ record: RecordModel) async throws {
        self.internalContext.delete(record)
        try self.internalContext.save()
    }

    func getRecordByExercise(
        _ exercise: String,
        unit: RecordUnit
    ) -> RecordModel? {
        do {
            let descriptor = FetchDescriptor<RecordModel>(
                sortBy: [SortDescriptor(\.count, order: .reverse)]
            )

            let normalizedExercise = normalizeExerciseName(exercise)

            return try internalContext.fetch(descriptor).first {
                normalizeExerciseName($0.exercise) == normalizedExercise
                    && $0.unit == unit
            }
        } catch {
            return nil
        }
    }

    func save() async throws {
        try internalContext.save()
    }

    private func normalizeExerciseName(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
