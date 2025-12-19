//
//  RecordsViewModel.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

class RecordsViewModel: ObservableObject {
    private let repository: RecordsRepository

    init(repository: RecordsRepository) {
        self.repository = repository
    }

    func setContext(_ context: ModelContext) {
        self.repository.updateContext(context)
    }

    func addRecord(_ record: RecordModel) {
        Task {
            do {
                try await self.repository.addRecord(record)
            } catch {
                print(
                    "Error on add record. Error \(error.localizedDescription)"
                )
            }
        }
    }

    func deleteRecord(_ record: RecordModel) {
        Task {
            do {
                try await self.repository.deleteRecord(record)
            } catch {
                print(
                    "Error on delete record. Error \(error.localizedDescription)"
                )
            }
        }
    }

    func updateRecord(
        recordToUpdate: RecordModel,
        submitedForm: RecordSubmitResult
    ) {
        recordToUpdate.exercise = submitedForm.exercise
        recordToUpdate.count = submitedForm.count
        recordToUpdate.unit = submitedForm.units
        recordToUpdate.date = Date()
    }
}
