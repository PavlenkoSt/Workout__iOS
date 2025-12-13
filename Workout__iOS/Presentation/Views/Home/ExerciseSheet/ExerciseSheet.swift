//
//  ExerciseSheet.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 09.12.2025.
//

import SwiftUI

struct DefaultExerciseSubmitResult {
    let exerciseType: ExerciseType
    let name: String
    let reps: Int
    let sets: Int
    let rest: Int
}

struct LadderExerciseSubmitResult {
    let name: String
    let from: Int
    let to: Int
    let step: Int
    let rest: Int
}

struct ExerciseFormSeed {
    var name: String? = ""
    var reps: String? = ""
}

struct SimpleExerciseSubmitResult {
    let exerciseType: ExerciseType
}

struct ExerciseSheet: View {
    var onSubmitDefaultExercise: (DefaultExerciseSubmitResult) -> Void = { _ in
    }
    var onSubmitLadderExercise: (LadderExerciseSubmitResult) -> Void = { _ in }
    var onSubmitSimpleExercise: (SimpleExerciseSubmitResult) -> Void = { _ in }

    var exerciseToEdit: TrainingExercise?

    var isEditing: Bool {
        return exerciseToEdit != nil
    }

    var saveBtnText: String {
        if isEditing {
            return "Update"
        } else {
            return "Add"
        }
    }

    @State private var exerciseType: ExerciseType = .dynamic
    @State private var savedSeed: ExerciseFormSeed = ExerciseFormSeed()

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Text(isEditing ? "Update exercise" : "Add exercise")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)

                HStack {
                    Text("Exercise Type")

                    Spacer()

                    Picker("Exercise type", selection: $exerciseType) {
                        Text("Dynamic").tag(ExerciseType.dynamic)
                        Text("Static").tag(ExerciseType.staticType)

                        if exerciseToEdit == nil {
                            Text("Ladder").tag(ExerciseType.ladder)
                        }

                        Text("Warmup").tag(ExerciseType.warmup)
                        Text("Handbalance session").tag(
                            ExerciseType.handBalanceSession
                        )
                        Text("Flexibility session").tag(
                            ExerciseType.flexibilitySession
                        )
                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .frame(minHeight: 50)
                .background(.white)
                .roundedBorder()
            }

            // spacer equal to error fields in forms
            Text(" ").font(.caption)

            if exerciseType == ExerciseType.dynamic
                || exerciseType == ExerciseType.staticType
            {
                DefaultExerciseForm(
                    onSubmit: { result in
                        onSubmitDefaultExercise(
                            DefaultExerciseSubmitResult(
                                exerciseType: exerciseType,
                                name: result.name,
                                reps: result.reps,
                                sets: result.sets,
                                rest: result.rest
                            )
                        )
                    },
                    saveBtnText: saveBtnText,
                    exerciseToEdit: exerciseToEdit,
                    savedSeed: $savedSeed
                )
            } else if exerciseType == ExerciseType.ladder {
                LadderExerciseForm(
                    onSubmit: {
                        result in
                        onSubmitLadderExercise(
                            LadderExerciseSubmitResult(
                                name: result.name,
                                from: result.from,
                                to: result.to,
                                step: result.step,
                                rest: result.rest
                            )
                        )
                    },
                    saveBtnText: saveBtnText,
                    savedSeed: $savedSeed,
                )
            } else {
                Button(saveBtnText) {
                    onSubmitSimpleExercise(
                        SimpleExerciseSubmitResult(exerciseType: exerciseType)
                    )
                }
                .buttonStyle(.glassProminent)
                .onAppear {
                    savedSeed = ExerciseFormSeed()
                }
            }
        }
        .padding(16)
    }
}

#Preview {
    ExerciseSheet()
}
