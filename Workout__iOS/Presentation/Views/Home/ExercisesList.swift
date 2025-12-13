//
//  ExercisesList.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 30.11.2025.
//

import SwiftUI

struct CustomListData: Identifiable {
    let id = UUID()
    let title: String
}

struct ExercisesList: View {
    let selectedDate: Date
    var exercises: [TrainingExercise]

    var onAddExercisePress: () -> Void = {}
    var onDeleteExercise: (TrainingExercise) -> Void = { _ in }
    var onUpdateExercise: (TrainingExercise) -> Void = { _ in }

    private func handleMove(from source: IndexSet, to destination: Int) {
        var mutableExercises = Array(exercises)  // Create a mutable copy of the fetched results
        mutableExercises.move(fromOffsets: source, toOffset: destination)

        for (newIndex, exercise) in mutableExercises.enumerated() {
            if exercise.order != newIndex {
                exercise.order = newIndex
            }
        }
    }

    private func incrementExercise(exercise: TrainingExercise) {
        withAnimation(.bouncy(duration: 0.2)) {
            exercise.setsDone += 1
        }
    }

    private func decrementExercise(exercise: TrainingExercise) {
        guard exercise.setsDone > 0 else { return }
        withAnimation(.bouncy(duration: 0.2)) {
            exercise.setsDone -= 1
        }
    }

    var body: some View {
        List {
            ForEach(Array(exercises.enumerated()), id: \.element.id) {
                index,
                item in
                ExerciseItem(
                    exercise: item,
                    index: index,
                    onIncrement: incrementExercise,
                    onDecrement: decrementExercise
                )
                .swipeActions(
                    edge: .trailing,
                    allowsFullSwipe: false
                ) {
                    Button(role: .destructive) {
                        onDeleteExercise(item)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(
                    edge: .leading,
                    allowsFullSwipe: false
                ) {
                    Button {
                        onUpdateExercise(item)
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                    }.tint(.blue)
                }
            }.onMove(perform: handleMove)

            Button(action: onAddExercisePress) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("Add exercise")
                }
            }
            .foregroundStyle(.white)
            .buttonStyle(.glassProminent)
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)

        }.listStyle(.inset)
    }
}

#Preview {
    let trainingDay = getTrainingDayForPreview()

    return ExercisesList(selectedDate: Date(), exercises: trainingDay.exercises)
}
