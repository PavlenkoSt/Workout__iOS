//
//  TrainingRepositoryImpl.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import Foundation
import SwiftData

enum TrainingRepositoryError: Error {
    case notFound
    case failedToSave
    case failedToFetch
}

@MainActor
final class TrainingRepositoryImpl: TrainingDayRepository {
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func getTrainingDay(date: Date) async throws -> TrainingDay {
        let descriptor = FetchDescriptor<TrainingDay>(
            predicate: #Predicate{ $0.date == date },
            sortBy: [SortDescriptor(\.date)]
        )
        
        guard let dayModel = try context.fetch(descriptor).first else {
            throw TrainingRepositoryError.notFound
        }
        
        return dayModel
    }
}
