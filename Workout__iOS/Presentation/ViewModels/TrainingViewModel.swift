//
//  TrainingViewModel.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 08.12.2025.
//

import Foundation
import Combine

@MainActor
class TrainingViewModel: ObservableObject {
    @Published var trainingDay: TrainingDay? = nil
    @Published var isLoading: Bool = false
    
    private let repository: TrainingRepositoryImpl

    init(repository: TrainingRepositoryImpl) {
        self.repository = repository
    }
    
    func loadExercises(date: Date) {
        isLoading = true
        Task {
            do {
                let trainingDay = try await repository.getTrainingDay(date: date)
                self.trainingDay = trainingDay
            } catch {
                print("Failed to load exercises. Error: \(error)")
            }
            isLoading = false
        }
    }
}
