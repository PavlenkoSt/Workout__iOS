//
//  GoalItem.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import SwiftUI

struct GoalItem: View {
    var goal: Goal

    var body: some View {
        VStack {
            Text("\(goal.name) (\(getGoalUnitName(unit: goal.unit)))")
            HStack {
                CounterBtn(
                    text: "-",
                    action: {
                        guard goal.count > 0 else { return }
                        withAnimation(.bouncy(duration: 0.2)) {
                            goal.count -= 1
                        }
                    }
                )

                CounterProgress(
                    count: goal.count,
                    targetCount: goal.targetCount
                )

                CounterBtn(
                    text: "+",
                    action: {
                        withAnimation(.bouncy(duration: 0.2)) {
                            goal.count += 1
                        }
                    }
                )
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
