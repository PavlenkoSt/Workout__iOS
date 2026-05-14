//
//  GoalItem.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import SwiftUI

struct GoalItem: View {
    var goal: Goal
    var onGoalChanged: () -> Void = {}

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(getGoalUnitName(unit: goal.unit))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: goal.status == .completed ? "checkmark.seal.fill" : "target")
                    .font(.title3)
                    .foregroundStyle(goal.status == .completed ? .green : .indigo)
            }

            HStack {
                CounterBtn(
                    text: "-",
                    action: {
                        guard goal.count > 0 else { return }
                        withAnimation(.bouncy(duration: 0.2)) {
                            goal.count -= 1
                        }
                        onGoalChanged()
                    }
                )

                CounterProgress(
                    count: goal.count,
                    targetCount: goal.targetCount,
                    showsCompletionBadge: false
                )

                CounterBtn(
                    text: "+",
                    action: {
                        withAnimation(.bouncy(duration: 0.2)) {
                            goal.count += 1
                        }
                        onGoalChanged()
                    }
                )
            }
        }
        .padding(12)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.75))
        )
        .shadow(color: .black.opacity(0.07), radius: 14, y: 7)
    }
}

#Preview {
    GoalItem(
        goal: Goal(
            name: "Pull ups",
            count: 5,
            targetCount: 15,
            unit: GoalUnit.reps
        )
    )
}
