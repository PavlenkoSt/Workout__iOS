//
//  Home.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftData
import SwiftUI
import _SwiftData_SwiftUI

struct Home: View {
    @ObservedObject var viewModel: TrainingViewModel

    @State var selectedDay: Date = Date().startOfDay
    @State var exerciseToEdit: TrainingExercise? = nil

    @Query var trainingDays: [TrainingDay]

    var trainingDay: TrainingDay? {
        let result = trainingDays.first {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDay)
        }
        return result
    }

    var exercises: [TrainingExercise] {
        return trainingDay?.exercises.sorted(by: { $0.order < $1.order }) ?? []
    }

    var body: some View {
        HomeContent(
            exerciseToEdit: $exerciseToEdit,
            selectedDate: $selectedDay,
            isLoading: false,
            trainingDay: trainingDay,
            trainingDays: trainingDays,
            exercises: exercises,
            onSubmitDefaultExercise: { result in
                if let exerciseToEdit = exerciseToEdit {
                    viewModel.updateDefaultExercise(
                        exerciseToEdit: exerciseToEdit,
                        exerciseFormResult: result
                    )
                } else {
                    viewModel.addDefaultExercise(
                        date: selectedDay,
                        exerciseFormResult: result
                    )
                }
            },
            onSubmitLadderExercise: { result in
                viewModel.addLadderExercise(
                    date: selectedDay,
                    exerciseFormResult: result
                )
            },
            onSubmitSimpleExercise: { result in
                if let exerciseToEdit = exerciseToEdit {
                    viewModel.updateSimpleExercise(
                        exerciseToEdit: exerciseToEdit,
                        exerciseFormResult: result
                    )
                } else {
                    viewModel.addSimpleExercise(
                        date: selectedDay,
                        exerciseFormResult: result
                    )
                }
            },
            onDeleteTrainingDay: { trainingDay in
                viewModel.deleteTrainingDay(trainingDay: trainingDay)
            },
            onDeleteExercise: { exercise in
                viewModel.deleteExercise(exercise)
            }
        )
    }
}

struct HomeContent: View {
    @State private var isShowingSheet = false
    @State private var detentHeight: CGFloat = 0

    @Binding var exerciseToEdit: TrainingExercise?
    @Binding var selectedDate: Date

    var isLoading: Bool
    var trainingDay: TrainingDay?
    var trainingDays: [TrainingDay]
    var exercises: [TrainingExercise]

    // callbacks
    var onSubmitDefaultExercise: (DefaultExerciseSubmitResult) -> Void = { _ in
    }
    var onSubmitLadderExercise: (LadderExerciseSubmitResult) -> Void = { _ in }
    var onSubmitSimpleExercise: (SimpleExerciseSubmitResult) -> Void = { _ in }

    var onDeleteTrainingDay: (TrainingDay) -> Void = { _ in }
    var onDeleteExercise: (TrainingExercise) -> Void = { _ in }

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
        VStack {
            WeekSwiper(selectedDate: $selectedDate, trainingDays: trainingDays)

            if let trainingDay = trainingDay {
                Menu {
                    Button(
                        role: .destructive,
                        action: { onDeleteTrainingDay(trainingDay) }
                    ) {
                        Label("Delete training day", systemImage: "trash")
                    }
                } label: {
                    TrainingDayHeader(
                        selectedDate: selectedDate,
                        status: trainingDay.status
                    )
                }
            } else {
                TrainingDayHeader(selectedDate: selectedDate, status: nil)
            }

            if let trainingDay = trainingDay {
                if !trainingDay.exercises.isEmpty {
                    ExercisesList(
                        selectedDate: selectedDate,
                        exercises: exercises,
                        onAddExercisePress: {
                            isShowingSheet = true
                        },
                        onDeleteExercise: onDeleteExercise,
                        onUpdateExercise: { exercise in
                            exerciseToEdit = exercise
                            isShowingSheet = true
                        }
                    )
                } else {
                    Empty(
                        text: "No exercises yet",
                        btnText: "Add exercise"
                    ) {
                        isShowingSheet = true
                    }
                }
            } else {
                Empty(
                    text: "No training yet",
                    btnText: "Create training"
                ) {
                    isShowingSheet = true
                }
            }

        }.sheet(isPresented: $isShowingSheet) {
            ExerciseSheet(
                onSubmitDefaultExercise: { result in
                    onSubmitDefaultExercise(result)
                    isShowingSheet = false
                },
                onSubmitLadderExercise: { result in
                    onSubmitLadderExercise(result)
                    isShowingSheet = false
                },
                onSubmitSimpleExercise: { result in
                    onSubmitSimpleExercise(result)
                    isShowingSheet = false
                },
                exerciseToEditFields: exerciseToEditFields
            )
            .presentationDragIndicator(.visible).presentationDetents([
                .height(detentHeight)
            ])
            .readAndBindHeight(to: $detentHeight)
            .onDisappear {
                exerciseToEdit = nil
            }
        }
    }
}

struct Empty: View {
    var text: String
    var btnText: String
    var btnAction: () -> Void = {}

    var body: some View {
        VStack {
            Text(text).padding(12)
            Button(btnText, systemImage: "plus") {
                btnAction()
            }.buttonStyle(.glassProminent)
            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var selectedDate = Date()
    @Previewable @State var exerciseToEdit: TrainingExercise? = nil

    let trainingDay = getTrainingDayForPreview()

    HomeContent(
        exerciseToEdit: $exerciseToEdit,
        selectedDate: $selectedDate,
        isLoading: false,
        trainingDay: trainingDay,
        trainingDays: [],
        exercises: [
            TrainingExercise(
                name: "Pull ups",
                sets: 4,
                reps: 10,
                rest: 120,
                trainingDay: trainingDay,
                type: ExerciseType.dynamic
            )
        ]
    )
}
