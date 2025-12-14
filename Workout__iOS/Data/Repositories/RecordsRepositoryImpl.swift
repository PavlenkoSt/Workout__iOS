//
//  RecordsRepositoryImpl.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Foundation
import SwiftData

@MainActor
final class RecordsRepositoryImpl: RecordsRepository {
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

    func getRecordByExercise(_ exercise: String) -> RecordModel? {
        do {
            let descriptor = FetchDescriptor<RecordModel>(
                predicate: #Predicate { $0.exercise.contains(exercise) },
                sortBy: [SortDescriptor(\.date)]
            )

            guard let dayModel = try internalContext.fetch(descriptor).first
            else {
                return nil
            }

            return dayModel
        } catch {
            return nil
        }
    }
}
