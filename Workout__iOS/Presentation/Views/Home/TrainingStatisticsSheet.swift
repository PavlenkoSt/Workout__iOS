//
//  TrainingStatisticsSheet.swift
//  Workout__iOS
//

import SwiftUI

struct TrainingStatisticsSheet: View {
    let exercises: [TrainingExercise]

    private var statisticItems: [TrainingStatisticsItem] {
        exercises.compactMap { exercise in
            guard exercise.type == .dynamic || exercise.type == .staticType else {
                return nil
            }

            return TrainingStatisticsItem(
                exerciseName: getExerciseName(exercise: exercise),
                units: exercise.type == .staticType ? "sec" : "reps",
                done: exercise.setsDone * exercise.reps,
                target: exercise.sets * exercise.reps
            )
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Training statistics")
                .font(.headline)
                .frame(maxWidth: .infinity)

            if statisticItems.isEmpty {
                Text("No statistics available")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 20)
            } else {
                ForEach(statisticItems) { item in
                    HStack {
                        Text(item.exerciseName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(item.done)/\(item.target) \(item.units)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        if item.done >= item.target {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.green)
                        }
                    }
                    .font(.system(size: 13))
                }
            }
        }
        .padding(16)
    }
}

private struct TrainingStatisticsItem: Identifiable {
    let id = UUID()
    let exerciseName: String
    let units: String
    let done: Int
    let target: Int
}
