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

    var body: some View {
        List {
            ForEach(Array(exercises.enumerated()), id: \.element.id) {
                index,
                item in
                ExerciseItem(exercise: item, index: index)
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
            }

            VStack {
                HStack {
                    Spacer()
                    Button("Add exercise", systemImage: "plus") {
                        onAddExercisePress()
                    }.buttonStyle(.glassProminent)
                    Spacer()
                }

                Spacer().frame(height: 10)
            }
        }.listStyle(.inset)
    }
}

#Preview {
    let trainingDay = getTrainingDayForPreview()

    return ExercisesList(selectedDate: Date(), exercises: trainingDay.exercises)
}
