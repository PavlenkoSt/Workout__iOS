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

    @Query var trainingDays: [TrainingDay]

    var trainingDay: TrainingDay? {
        let result = trainingDays.first {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDay)
        }
        return result
    }

    var body: some View {
        HomeContent(
            selectedDate: selectedDay,
            isLoading: false,
            trainingDay: trainingDay,
            onSubmitDefaultExercise: {
                result in
                viewModel.addDefaultExercise(
                    date: selectedDay,
                    exerciseFormResult: result
                )
            },
            onSubmitLadderExercise: { result in },
            onSubmitSimpleExercise: { result in },
            onChangeDate: { date in selectedDay = date }
        )
    }
}

struct HomeContent: View {
    @State private var isShowingSheet = false
    @State private var detentHeight: CGFloat = 0

    var selectedDate: Date
    var isLoading: Bool
    var trainingDay: TrainingDay?

    // callbacks
    var onSubmitDefaultExercise: (DefaultExerciseSubmitResult) -> Void = { _ in
    }
    var onSubmitLadderExercise: (LadderExerciseSubmitResult) -> Void = { _ in }
    var onSubmitSimpleExercise: (SimpleExerciseSubmitResult) -> Void = { _ in }
    var onChangeDate: (Date) -> Void = { _ in }

    var body: some View {
        VStack {
            WeekSwiper(
                selectedDate: selectedDate,
                onSelectDate: onChangeDate
            )

            TrainingDayHeader(selectedDate: selectedDate)

            if let trainingDay = trainingDay {
                if !trainingDay.exercises.isEmpty {
                    ScrollView {
                        ExercisesList(
                            selectedDate: selectedDate,
                            exercises: trainingDay.exercises
                        )

                        Button("Add exercise", systemImage: "plus") {
                            isShowingSheet = true
                        }.buttonStyle(.glassProminent)

                        Spacer().frame(height: 10)

                    }.padding(.horizontal, 8)
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
                onSubmitLadderExercise: onSubmitLadderExercise,
                onSubmitSimpleExercise: onSubmitSimpleExercise
            )
            .presentationDragIndicator(.visible).presentationDetents([
                .height(detentHeight)
            ])
            .readAndBindHeight(to: $detentHeight)
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
    let trainingDay = getTrainingDayForPreview()

    HomeContent(
        selectedDate: Date(),
        isLoading: false,
        trainingDay: nil,
        onSubmitDefaultExercise: { result in },
        onSubmitLadderExercise: { result in },
        onSubmitSimpleExercise: { result in },
        onChangeDate: { date in }
    )
}
