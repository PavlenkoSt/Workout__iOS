//
//  ExerciseSheet.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 09.12.2025.
//

import SwiftUI

// TODO style it nicely
// TODO fix keyboard flicker when changing focus on submit
struct ExerciseSheet: View {
    @State private var exerciseType: ExerciseType = .dynamic

    @State private var exerciseName: String = ""
    @FocusState private var exerciseNameFieldIsFocused: Bool

    @State private var reps: String = ""
    @FocusState private var repsFieldIsFocused: Bool

    @State private var sets: String = ""
    @FocusState private var setsFieldIsFocused: Bool

    @State private var rest: String = ""
    @FocusState private var restFieldIsFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add exercise")
                .font(.headline)
                .frame(maxWidth: .infinity)

            Picker("Exercise type", selection: $exerciseType) {
                Text("Dynamic").tag(ExerciseType.dynamic)
                Text("Static").tag(ExerciseType.staticType)
                Text("Warmup").tag(ExerciseType.warmup)
                Text("Handbalance session").tag(ExerciseType.handBalanceSession)
                Text("Flexibility session").tag(ExerciseType.flexibilitySession)
            }

            TextField(
                "Exercise",
                text: $exerciseName
            )
            .focused($exerciseNameFieldIsFocused)
            .onSubmit {
                repsFieldIsFocused = true
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(false)
            .submitLabel(.continue)
            .textFieldStyle(.roundedBorder)

            HStack(spacing: 12) {
                TextField(
                    "Reps",
                    text: $reps
                )
                .focused($repsFieldIsFocused)
                .onSubmit {
                    setsFieldIsFocused = true
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.continue)
                .textFieldStyle(.roundedBorder)

                TextField(
                    "Sets",
                    text: $sets
                )
                .focused($setsFieldIsFocused)
                .onSubmit {
                    restFieldIsFocused = true
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.continue)
                .textFieldStyle(.roundedBorder)

                TextField(
                    "Rest",
                    text: $rest
                )
                .focused($restFieldIsFocused)
                .onSubmit {
                    // done
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.done)
                .textFieldStyle(.roundedBorder)
            }

            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    ExerciseSheet()
}
