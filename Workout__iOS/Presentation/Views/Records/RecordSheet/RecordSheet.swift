//
//  RecordSheet.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import SwiftUI

struct RecordSubmitResult {
    let exercise: String
    let count: Int
    let units: RecordUnit
}

struct RecordSheet: View {
    var onSubmit: (RecordSubmitResult) -> Void = { _ in }
    var recordToUpdate: RecordModel?

    @State private var exercise: String = ""
    @State private var count: String = ""
    @State private var units: RecordUnit = .reps

    // errors
    @State private var exerciseError: String?
    @State private var countError: String?

    private func validateAndSubmit() -> Bool {

        var isValid: Bool = true

        if exercise.trimmingCharacters(in: .whitespaces).isEmpty {
            exerciseError = "Cannot be empty"
            isValid = false
        }

        if let countInt = Int(count), countInt > 0 {
        } else {
            countError = "Must be > 0"
            isValid = false
        }

        guard let countInt = Int(count)
        else {
            return false
        }

        // All validations passed
        if isValid {
            onSubmit(
                RecordSubmitResult(
                    exercise: exercise,
                    count: countInt,
                    units: units
                )
            )
        }

        return isValid
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(recordToUpdate != nil ? "Update record" : "Add new record")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)

            FormField(
                placeholder: "Exercise",
                text: $exercise,
                error: $exerciseError,
                keyboardType: .default,
                onValueChange: { newValue in
                    if newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                        exerciseError = "Cannot be empty"
                    } else {
                        exerciseError = nil
                    }
                }
            )

            FormField(
                placeholder: "Count",
                text: $count,
                error: $countError,
                keyboardType: .numberPad,
                inputFilter: { $0.filter { $0.isNumber } },
                onValueChange: { newValue in
                    if let targetCountInt = Int(newValue), targetCountInt > 0 {
                        countError = nil
                    } else if !newValue.isEmpty {
                        countError = "Must be > 0"
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

            Button(recordToUpdate != nil ? "Update" : "Create") {
                validateAndSubmit()
            }
            .buttonStyle(.glassProminent)

        }
        .padding(10)
        .onAppear {
            if let recordToUpdate = recordToUpdate {
                exercise = recordToUpdate.exercise
                count = String(recordToUpdate.count)
                units = recordToUpdate.unit
            }
        }.onChange(of: recordToUpdate) { oldValue, newValue in
            if let goalToUpdate = newValue {
                exercise = goalToUpdate.exercise
                count = String(goalToUpdate.count)
                units = goalToUpdate.unit
            }
        }
    }
}

#Preview {
    RecordSheet()
}
