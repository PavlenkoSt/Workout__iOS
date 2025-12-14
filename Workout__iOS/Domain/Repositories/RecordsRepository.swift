//
//  RecordsRepository.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Foundation

protocol RecordsRepository {
    func addRecord(_ record: RecordModel) async throws
    func deleteRecord(_ record: RecordModel) async throws
}
