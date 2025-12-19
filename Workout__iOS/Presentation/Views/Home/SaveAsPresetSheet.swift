//
//  SaveAsPresetSheet.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 19.12.2025.
//

import SwiftUI

struct SaveAsPresetSubmitResult {
    var name: String
}

struct SaveAsPresetSheet: View {
    @State private var name: String = ""
    @State private var nameError: String? = nil

    var onSubmit: (SaveAsPresetSubmitResult) -> Void = { _ in }

    private func validateAndSubmit() -> Bool {

        var isValid: Bool = true

        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Cannot be empty"
            isValid = false
        }

        // All validations passed
        if isValid {
            onSubmit(
                SaveAsPresetSubmitResult(
                    name: name
                )
            )
        }

        return isValid
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Save as preset")
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

            Button("Save") {
                validateAndSubmit()
            }
            .buttonStyle(.glassProminent)

        }
        .padding(10)
    }
}

#Preview {
    SaveAsPresetSheet()
}
