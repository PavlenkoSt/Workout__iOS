//
//  DefaultExerciseForm.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 09.12.2025.
//

import SwiftUI

struct DefaultExerciseFormResult: Equatable {
    let name: String
    let reps: Int
    let sets: Int
    let rest: Int
}

struct DefaultExerciseForm: View {
    var onSubmit: (DefaultExerciseFormResult) -> Void = { _ in }

    var saveBtnText: String
    var exerciseToEditFields: DefaultExerciseFormResult?

    @Binding var savedSeed: ExerciseFormSeed

    // fields
    @State private var exerciseName: String = ""
    @State private var reps: String = ""
    @State private var sets: String = ""
    @State private var rest: String = "120"

    // errors
    @State private var nameError: String?
    @State private var repsError: String?
    @State private var setsError: String?
    @State private var restError: String?

    private func validateAndSubmit() -> Bool {

        var isValid: Bool = true

        // Validate exercise name
        if exerciseName.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Cannot be empty"
            isValid = false
        }

        if let repsInt = Int(reps), repsInt > 0 {
        } else {
            repsError = "Must be > 0"
            isValid = false
        }

        if let setsInt = Int(sets), setsInt > 0 {
        } else {
            setsError = "Must be > 0"
            isValid = false
        }

        if let restInt = Int(rest), restInt > 0 {
        } else {
            restError = "Must be > 0"
            isValid = false
        }

        guard let repsInt = Int(reps),
            let setsInt = Int(sets),
            let restInt = Int(rest)
        else {
            return false
        }

        // All validations passed
        if isValid {
            onSubmit(
                DefaultExerciseFormResult(
                    name: exerciseName,
                    reps: repsInt,
                    sets: setsInt,
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
                    savedSeed.name = newValue
                }
            )

            HStack(spacing: 12) {
                FormField(
                    placeholder: "Reps",
                    text: $reps,
                    error: $repsError,
                    keyboardType: .numberPad,
                    inputFilter: { $0.filter { $0.isNumber } },
                    onValueChange: { newValue in
                        if let repsInt = Int(newValue), repsInt > 0 {
                            repsError = nil
                        } else if !newValue.isEmpty {
                            repsError = "Must be > 0"
                        }
                        savedSeed.reps = newValue
                    }
                )

                FormField(
                    placeholder: "Sets",
                    text: $sets,
                    error: $setsError,
                    keyboardType: .numberPad,
                    inputFilter: { $0.filter { $0.isNumber } },
                    onValueChange: { newValue in
                        if let setsInt = Int(newValue), setsInt > 0 {
                            setsError = nil
                        } else if !newValue.isEmpty {
                            setsError = "Must be > 0"
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

            Button(saveBtnText) { validateAndSubmit() }
                .buttonStyle(.glassProminent)
        }.onAppear {
            if let exerciseToEditFields = exerciseToEditFields {
                exerciseName = exerciseToEditFields.name
                reps = String(exerciseToEditFields.reps)
                sets = String(exerciseToEditFields.sets)
                rest = String(exerciseToEditFields.rest)
            }

            if let savedName = savedSeed.name, savedSeed.name != "",
                savedSeed.name != nil
            {
                exerciseName = savedName
            }

            if let savedReps = savedSeed.reps, savedSeed.reps != "",
                savedSeed.reps != nil
            {
                reps = savedReps
            }
        }.onChange(of: exerciseToEditFields) { oldValue, newValue in
            if let exerciseToEditFields = newValue {
                exerciseName = exerciseToEditFields.name
                reps = String(exerciseToEditFields.reps)
                sets = String(exerciseToEditFields.sets)
                rest = String(exerciseToEditFields.rest)
            }
        }
    }
}

#Preview {
    @Previewable @State var seed = ExerciseFormSeed()

    DefaultExerciseForm(
        saveBtnText: "Add",
        savedSeed: $seed
    )
}
