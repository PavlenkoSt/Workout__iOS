//
//  Preset.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 17.12.2025.
//

import SwiftUI

enum SheetType: Identifiable {
    case use
    case addExercise

    var id: Int { hashValue }
}

struct PresetScreen: View {
    @State private var activeSheet: SheetType?

    @State private var exerciseSheetHeight: CGFloat = 0
    @State private var useSheetHeight: CGFloat = 0

    @State private var exerciseToEdit: PresetExercise? = nil

    var preset: Preset
    var onUse: (Preset) -> Void = { _ in }
    var addDefaultExerciseToPreset:
        (DefaultExerciseSubmitResult, Preset) -> Void = { _, _ in }
    var addLadderExerciseToPreset:
        (LadderExerciseSubmitResult, Preset) -> Void = { _, _ in }
    var addSimpleExerciseToPreset:
        (SimpleExerciseSubmitResult, Preset) -> Void = { _, _ in }
    var deleteExerciseFromPreset: (PresetExercise) -> Void = { _ in }
    var createTrainingDayFromPreset: (Date, Preset) -> Void = {
        _,
        _ in
    }

    var exerciseToEditFields: DefaultExerciseFormResult? {
        if let exerciseToEdit = exerciseToEdit {
            DefaultExerciseFormResult(
                name: exerciseToEdit.name,
                reps: exerciseToEdit.reps,
                sets: exerciseToEdit.sets,
                rest: exerciseToEdit.sets
            )
        } else {
            nil
        }
    }

    var body: some View {
        ZStack {
            if preset.exercises.isEmpty {
                VStack {
                    Text("No exercises yet").padding(.vertical, 30)

                    Button(
                        "Add exercise",
                        systemImage: "plus",
                        action: {
                            activeSheet = .addExercise
                        }
                    )
                    .buttonStyle(.glassProminent)

                    Spacer()
                }
            } else {
                List {
                    ForEach(
                        Array(preset.exercises.enumerated()),
                        id: \.element.id
                    ) { index, exercise in
                        PresetExerciseItem(
                            presetExercise: exercise,
                            index: index
                        ).swipeActions(
                            edge: .trailing,
                            allowsFullSwipe: false
                        ) {
                            Button(role: .destructive) {
                                deleteExerciseFromPreset(exercise)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(
                            edge: .leading,
                            allowsFullSwipe: false
                        ) {
                            Button {
                                exerciseToEdit = exercise
                                activeSheet = .addExercise
                            } label: {
                                Label("Edit", systemImage: "square.and.pencil")
                            }.tint(.blue)
                        }
                    }

                    Button(
                        "Add exercise",
                        systemImage: "plus",
                        action: { activeSheet = .addExercise }
                    )
                    .foregroundStyle(.white)
                    .buttonStyle(.glassProminent)
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                }
            }
        }.navigationTitle(preset.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !preset.exercises.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(
                            "Use",
                            action: { activeSheet = .use }
                        )
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .use:
                    UsePresetSheet(
                        preset: preset,
                        createTrainingDayFromPreset: { date, preset in
                            createTrainingDayFromPreset(date, preset)
                            activeSheet = nil
                        }
                    ).readAndBindHeight(
                        to: $useSheetHeight
                    )
                    .presentationDetents([.height(useSheetHeight)])
                case .addExercise:
                    ExerciseSheet(
                        onSubmitDefaultExercise: { result in
                            if let exerciseToEdit = exerciseToEdit {
                                exerciseToEdit.name = result.name
                                exerciseToEdit.sets = result.sets
                                exerciseToEdit.reps = result.reps
                                exerciseToEdit.rest = result.rest
                                exerciseToEdit.type = result.exerciseType
                            } else {
                                addDefaultExerciseToPreset(result, preset)
                            }
                            activeSheet = nil
                        },
                        onSubmitLadderExercise: { result in
                            addLadderExerciseToPreset(result, preset)
                            activeSheet = nil
                        },
                        onSubmitSimpleExercise: { result in
                            if let exerciseToEdit = exerciseToEdit {
                                exerciseToEdit.name = "simple_exercise"
                                exerciseToEdit.sets = 1
                                exerciseToEdit.reps = 1
                                exerciseToEdit.rest = 1
                                exerciseToEdit.type = result.exerciseType
                            } else {
                                addSimpleExerciseToPreset(result, preset)
                            }
                            activeSheet = nil
                        },
                        exerciseToEditFields: exerciseToEditFields
                    )
                    .readAndBindHeight(to: $exerciseSheetHeight)
                    .presentationDetents([.height(exerciseSheetHeight)])
                }
            }.onDisappear {
                exerciseToEdit = nil
            }

    }
}

#Preview {
    PresetScreen(
        preset: Preset(name: "Preset here")
    )
}
