//
//  GoalSheet.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import SwiftUI

struct GoalSubmitResult {
    let name: String
    let targetCount: Int
    let units: GoalUnit
}

struct GoalSheet: View {
    var onSubmit: (GoalSubmitResult) -> Void = { _ in }

    // fields
    @State private var name: String = ""
    @State private var targetCount: String = ""
    @State private var units: GoalUnit = .reps

    // errors
    @State private var nameError: String?
    @State private var targetCountError: String?

    private func validateAndSubmit() -> Bool {

        var isValid: Bool = true

        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Cannot be empty"
            isValid = false
        }

        if let targetCountInt = Int(targetCount), targetCountInt > 0 {
        } else {
            targetCountError = "Must be > 0"
            isValid = false
        }

        guard let targetCountInt = Int(targetCount)
        else {
            return false
        }

        // All validations passed
        if isValid {
            onSubmit(
                GoalSubmitResult(
                    name: name,
                    targetCount: targetCountInt,
                    units: units
                )
            )
        }

        return isValid
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Add new goal")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)

            FormField(
                placeholder: "Exercise",
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

            FormField(
                placeholder: "Count",
                text: $targetCount,
                error: $targetCountError,
                keyboardType: .numberPad,
                inputFilter: { $0.filter { $0.isNumber } },
                onValueChange: { newValue in
                    if let targetCountInt = Int(newValue), targetCountInt > 0 {
                        targetCountError = nil
                    } else if !newValue.isEmpty {
                        targetCountError = "Must be > 0"
                    }
                }
            )

            HStack {
                Text("Units").padding(10)

                Spacer()

                Picker("Units", selection: $units) {
                    Text("Reps").tag(GoalUnit.reps)
                    Text("Seconds").tag(GoalUnit.sec)
                    Text("Minutes").tag(GoalUnit.min)
                    Text("Kilometers").tag(GoalUnit.km)
                }
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .roundedBorder()

            Spacer().frame(height: 10)

            Button("Save") { validateAndSubmit() }
                .buttonStyle(.glassProminent)

        }.padding(10)
    }
}

#Preview {
    GoalSheet()
}
