//
//  PresetsViewModel.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

@MainActor
class PresetsViewModel: ObservableObject {
    private let repository: PresetsRepositoryImpl

    init(repository: PresetsRepositoryImpl) {
        self.repository = repository
    }

    func setContext(_ context: ModelContext) {
        self.repository.updateContext(context)
    }
}
