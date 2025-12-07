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

// TODO hardcoded, use data from db instead
let trainingDay: TrainingDay = TrainingDay(date: Date())
let exercises: [TrainingExercise] = [
    TrainingExercise(
        name: "Push ups",
        sets: 4,
        reps: 12,
        rest: 120,
        trainingDay: trainingDay,
        type: ExerciseType.dynamic
    ),
    TrainingExercise(
        name: "Pull ups",
        sets: 2,
        reps: 20,
        rest: 60,
        trainingDay: trainingDay,
        type: ExerciseType.dynamic
    ),
]

struct ExercisesList: View {
    let selectedDate: Date

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(Array(exercises.enumerated()), id: \.element.id) {
                    index,
                    item in
                    ExerciseItem(exercise: item, index: index)
                }
            }
        }.padding(.horizontal, 8)
    }
}

#Preview {
    ExercisesList(selectedDate: Date())
}
