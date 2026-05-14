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
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                Text(String(index + 1))
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(
                        LinearGradient(
                            colors: [.indigo, .teal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: Circle()
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(getExerciseName(exercise: exercise))
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(
                        exercise.type == .dynamic
                            || exercise.type == .staticType
                            || exercise.type == .ladder
                            ? "Structured workout" : "Session block"
                    )
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if exercise.type == .dynamic
                    || exercise.type == .staticType
                    || exercise.type == .ladder
                {
                    HStack(spacing: 6) {
                        StatItem(title: "Reps", value: String(exercise.reps))
                        StatItem(title: "Sets", value: String(exercise.sets))
                        StatItem(title: "Rest", value: "\(exercise.rest)s")
                    }
                } else {
                    Spacer().frame(height: 32)
                }
            }

            HStack(spacing: 12) {
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
        .padding(14)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.8))
        )
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
    }
}

private struct StatItem: View {
    var title: String
    var value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(Color(.systemGray6).opacity(0.85), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
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
