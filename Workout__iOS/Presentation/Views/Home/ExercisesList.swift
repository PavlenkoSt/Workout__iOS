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

    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(Array(exercises.enumerated()), id: \.element.id) {
                index,
                item in
                ExerciseItem(exercise: item, index: index)
            }
        }
    }
}

#Preview {
    let trainingDay = getTrainingDayForPreview()

    return ExercisesList(selectedDate: Date(), exercises: trainingDay.exercises)
}
