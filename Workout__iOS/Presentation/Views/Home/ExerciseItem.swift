//
//  ExerciseItem.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 30.11.2025.
//

import SwiftUI

struct ExerciseItem: View {
    var exercise: TrainingExercise
    var index: Int

    var onIncrement: (TrainingExercise) -> Void = { _ in }
    var onDecrement: (TrainingExercise) -> Void = { _ in }

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(String(index + 1))
                    Text(getExerciseName(exercise: exercise))
                }
                Spacer()
                if exercise.type == .dynamic
                    || exercise.type == .staticType
                    || exercise.type == .ladder
                {
                    HStack {
                        StatItem(title: "Reps", value: String(exercise.reps))
                        StatItem(title: "Sets", value: String(exercise.sets))
                        StatItem(title: "Rest", value: "\(exercise.rest) sec.")
                    }
                } else {
                    Spacer().frame(height: 40)
                }
            }

            HStack {
                CounterBtn(
                    text: "-",
                    action: { onDecrement(exercise) }
                )

                CounterProgress(
                    count: exercise.setsDone,
                    targetCount: exercise.sets
                )

                CounterBtn(
                    text: "+",
                    action: { onIncrement(exercise) }
                )
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .border(Color(.systemGray4), width: 1)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

private struct StatItem: View {
    var title: String
    var value: String

    var body: some View {
        VStack {
            Text(title)
            Text(value)
        }.padding(8).font(.system(size: 12))
    }
}

#Preview {
    ExerciseItem(
        exercise: TrainingExercise(
            name: "Push ups",
            sets: 4,
            reps: 12,
            rest: 120,
            trainingDay: TrainingDay(date: Date()),
            type: ExerciseType.dynamic
        ),
        index: 0
    )
}
