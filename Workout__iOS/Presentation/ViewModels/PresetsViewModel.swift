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

    func createPreset(result: PresetSubmitResult) {
        Task {
            do {
                let presets = try await self.repository.getPresets()
                let maxPresetOrder = presets.map { $0.order }.max()
                try await self.repository.createPreset(
                    Preset(
                        name: result.name,
                        order: (maxPresetOrder ?? 0) + 1
                    )
                )
            } catch {
                print("Failed to create preset - \(error.localizedDescription)")
            }
        }
    }

    func updatePreset(presetToUpdate: Preset, result: PresetSubmitResult) {
        presetToUpdate.name = result.name
    }

    func deletePreset(preset: Preset) {
        Task {
            do {
                try await self.repository.deletePreset(preset)
            } catch {
                print("Failed to delete preset - \(error.localizedDescription)")
            }
        }
    }

    func updatePresetOrder(presets: [Preset]) {
        Task {
            do {
                // Update the order property for each preset based on its position
                for (index, preset) in presets.enumerated() {
                    // Assuming `order` is a property on Preset
                    // Note: The move operation in the view should ensure the order is correct.
                    // We just need to ensure the changes are saved.
                    if preset.order != index {
                        preset.order = index
                    }
                }

                // Explicitly save the ModelContext.
                // This is crucial to persist all the order changes.
                try await self.repository.save()

            } catch {
                print(
                    "Failed to update preset order - \(error.localizedDescription)"
                )
            }
        }
    }
}
