//
//  DefaultExerciseForm.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 09.12.2025.
//

import SwiftUI

struct LadderExerciseForm: View {
    var onSubmit: (LadderExerciseSubmitResult) -> Void = { _ in }

    @Binding var savedSeed: ExerciseFormSeed

    // fields
    @State private var exerciseName: String = ""
    @State private var from: String = ""
    @State private var to: String = ""
    @State private var step: String = "1"
    @State private var rest: String = "120"

    // errors
    @State private var nameError: String?
    @State private var fromError: String?
    @State private var toError: String?
    @State private var stepError: String?
    @State private var restError: String?

    private func validateAndSubmit() -> Bool {

        var isValid: Bool = true

        // Validate exercise name
        if exerciseName.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Cannot be empty"
            isValid = false
        }

        if let fromInt = Int(from), fromInt > 0 {
        } else {
            fromError = "Must be > 0"
            isValid = false
        }

        if let toInt = Int(to), toInt > 0 {
        } else {
            toError = "Must be > 0"
            isValid = false
        }

        if let stepInt = Int(step), stepInt > 0 {
        } else {
            stepError = "Must be > 0"
            isValid = false
        }

        if let restInt = Int(step), restInt > 0 {
        } else {
            restError = "Must be > 0"
            isValid = false
        }

        guard let fromInt = Int(from),
            let toInt = Int(to),
            let stepInt = Int(step),
            let restInt = Int(rest)
        else {
            return false
        }

        // All validations passed
        if isValid {
            onSubmit(
                LadderExerciseSubmitResult(
                    name: exerciseName,
                    from: fromInt,
                    to: toInt,
                    step: stepInt,
                    rest: restInt
                )
            )
        }

        return isValid
    }

    var body: some View {
        VStack {
            FormField(
                placeholder: "Exercise",
                text: $exerciseName,
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

            HStack(spacing: 12) {
                FormField(
                    placeholder: "From",
                    text: $from,
                    error: $fromError,
                    keyboardType: .numberPad,
                    inputFilter: { $0.filter { $0.isNumber } },
                    onValueChange: { newValue in
                        if let fromInt = Int(newValue), fromInt > 0 {
                            fromError = nil
                        } else if !newValue.isEmpty {
                            fromError = "Must be > 0"
                        }
                    }
                )

                FormField(
                    placeholder: "To",
                    text: $to,
                    error: $toError,
                    keyboardType: .numberPad,
                    inputFilter: { $0.filter { $0.isNumber } },
                    onValueChange: { newValue in
                        if let toInt = Int(newValue), toInt > 0 {
                            toError = nil
                        } else if !newValue.isEmpty {
                            toError = "Must be > 0"
                        }
                    }
                )

                FormField(
                    placeholder: "Step",
                    text: $step,
                    error: $stepError,
                    keyboardType: .numberPad,
                    inputFilter: { $0.filter { $0.isNumber } },
                    onValueChange: { newValue in
                        if let stepInt = Int(newValue), stepInt > 0 {
                            stepError = nil
                        } else if !newValue.isEmpty {
                            stepError = "Must be > 0"
                        }
                    }
                )

                FormField(
                    placeholder: "Rest",
                    text: $rest,
                    error: $restError,
                    keyboardType: .numberPad,
                    inputFilter: { $0.filter { $0.isNumber } },
                    onValueChange: { newValue in
                        if let restInt = Int(newValue), restInt > 0 {
                            restError = nil
                        } else if !newValue.isEmpty {
                            restError = "Must be > 0"
                        }
                    }
                )
            }

            Button("Save") { validateAndSubmit() }
                .buttonStyle(.glassProminent)
        }.onAppear {
            if let savedName = savedSeed.name {
                exerciseName = savedName
            }

            if let savedReps = savedSeed.reps {
                from = savedReps
            }
        }
    }
}

#Preview {
    @State var seed: ExerciseFormSeed = ExerciseFormSeed()

    DefaultExerciseForm(
        onSubmit: { _ in },
        savedSeed: $seed
    )
}
