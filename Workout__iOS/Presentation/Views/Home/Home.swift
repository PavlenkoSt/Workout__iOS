//
//  Home.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftUI

struct Home: View {
    var viewModel: TrainingViewModel

    var body: some View {
        HomeContent(
            onLoadExercises: { date in
                viewModel.loadExercises(date: date)
            },
            isLoading: viewModel.isLoading,
            trainingDay: viewModel.trainingDay
        )
    }
}

struct HomeContent: View {
    @State private var selectedDate = Date()
    @State private var isShowingSheet = false
    @State private var detentHeight: CGFloat = 0

    var onLoadExercises: (Date) -> Void
    var isLoading: Bool
    var trainingDay: TrainingDay?

    var body: some View {
        VStack {
            WeekSwiper(
                selectedDate: selectedDate,
                onSelectDate: { date in selectedDate = date }
            )

            TrainingDayHeader(selectedDate: selectedDate)

            if let trainingDay = trainingDay {
                if !trainingDay.exercises.isEmpty {
                    ExercisesList(
                        selectedDate: selectedDate,
                        exercises: trainingDay.exercises
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

        }.onChange(
            of: selectedDate,
            {
                onLoadExercises(selectedDate)
            }
        ).sheet(isPresented: $isShowingSheet) {
            ExerciseSheet(
                onSubmitDefaultExercise: { result in },
                onSubmitLadderExercise: { result in },
                onSubmitSimpleExercise: { result in }
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

    return HomeContent(
        onLoadExercises: { _ in },
        isLoading: false,
        trainingDay: nil
    )
}
