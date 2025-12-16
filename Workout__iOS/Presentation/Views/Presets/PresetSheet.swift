//
//  PresetSheet.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 16.12.2025.
//

import SwiftUI

struct PresetSubmitResult {
    let name: String
}

struct PresetSheet: View {
    @State private var name: String = ""
    @State private var nameError: String? = nil

    var presetToUpdate: Preset? = nil
    var onSubmit: (PresetSubmitResult) -> Void = { _ in }

    private func validateAndSubmit() -> Bool {

        var isValid: Bool = true

        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Cannot be empty"
            isValid = false
        }

        // All validations passed
        if isValid {
            onSubmit(
                PresetSubmitResult(
                    name: name
                )
            )
        }

        return isValid
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(presetToUpdate != nil ? "Update preset" : "Add new preset ")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)

            FormField(
                placeholder: "Name",
                text: $name,
                error: $nameError,
                keyboardType: .default,
                onValueChange: { newValue in
                    if newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                        nameError = "Cannot be empty"
                    } else {
                        nameError = nil
                    }
                }
            )

            Button(presetToUpdate != nil ? "Update" : "Create") {
                validateAndSubmit()
            }
            .buttonStyle(.glassProminent)

        }
        .padding(10)
        .onAppear {
            if let presetToUpdate = presetToUpdate {
                name = presetToUpdate.name
            }
        }.onChange(of: presetToUpdate) { oldValue, newValue in
            if let presetToUpdate = newValue {
                name = presetToUpdate.name
            }
        }
    }
}

#Preview {
    PresetSheet()
}
