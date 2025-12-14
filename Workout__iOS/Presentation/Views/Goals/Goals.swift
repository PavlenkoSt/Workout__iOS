//
//  Goals.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftData
import SwiftUI
import _SwiftData_SwiftUI

enum GoalsFilter {
    case all
    case completed
    case pending
}

struct Goals: View {
    @ObservedObject var viewModel: GoalsViewModel

    @Query var goals: [Goal]

    @State var filter: GoalsFilter = .all
    @State var goalToUpdate: Goal? = nil

    var body: some View {
        GoalsContent(
            filter: $filter,
            goalToUpdate: $goalToUpdate,
            goals: goals,
            addGoal: { result in
                viewModel.addGoal(goalSubmitResult: result)
            },
            updateGoal: { goalToUpdate, result in
                viewModel.updateGoal(
                    goalToUpdate: goalToUpdate,
                    goalSubmitResult: result
                )
            },
            deleteGoal: { goal in
                viewModel.deleteGoal(goal: goal)
            }
        )
    }
}

struct GoalsContent: View {
    @Binding var filter: GoalsFilter
    @Binding var goalToUpdate: Goal?

    @State var isShowingSheet: Bool = false
    @State private var detentHeight: CGFloat = 0

    var goals: [Goal]
    var addGoal: (GoalSubmitResult) -> Void = { _ in }
    var updateGoal: (Goal, GoalSubmitResult) -> Void = { _, _ in }
    var deleteGoal: (Goal) -> Void = { _ in }

    var pendingGoals: [Goal] {
        if filter == .completed {
            return []
        }

        return goals.filter {
            $0.status
                == GoalStatus.pending
        }
    }

    var completedGoals: [Goal] {
        if filter == .pending {
            return []
        }
        return goals.filter {
            $0.status
                == GoalStatus.completed
        }
    }

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                GoalsHeader(filter: $filter)

                if !pendingGoals.isEmpty || !completedGoals.isEmpty {
                    ScrollView {
                        if !pendingGoals.isEmpty && filter != .completed {
                            if filter == .all {
                                Text("Pending")
                                    .padding(12)
                                    .frame(maxWidth: .infinity).cornerRadius(12)
                                    .background(.gray.opacity(0.25))
                            }

                            LazyVGrid(columns: columns) {
                                ForEach(pendingGoals) { goal in
                                    GoalItem(goal: goal).contextMenu {
                                        Button {
                                            goalToUpdate = goal
                                            isShowingSheet = true
                                        } label: {
                                            Label(
                                                "Update",
                                                systemImage: "pencil"
                                            )
                                        }

                                        Button(role: .destructive) {
                                            deleteGoal(goal)
                                        } label: {
                                            Label(
                                                "Delete",
                                                systemImage: "trash"
                                            )
                                        }
                                    }
                                }
                            }.padding(.horizontal)
                        }

                        if !completedGoals.isEmpty && filter != .pending {
                            if filter == .all {
                                Text("Competed")
                                    .padding(12)
                                    .frame(maxWidth: .infinity).cornerRadius(12)
                                    .background(.gray.opacity(0.25))
                            }

                            LazyVGrid(columns: columns) {
                                ForEach(completedGoals) { goal in
                                    GoalItem(goal: goal)
                                }
                            }.padding(.horizontal)
                        }
                    }
                } else {
                    Text(
                        filter == .all
                            ? "No goals yet"
                            : filter == .completed
                                ? "No completed goals yet"
                                : "No pending goals yet"
                    )
                    .padding(.vertical, 30)
                }

                Spacer()
            }

            Button {
                isShowingSheet = true
            } label: {
                FloatingBtn()
            }
            .padding()
        }.sheet(isPresented: $isShowingSheet) {
            GoalSheet(
                onSubmit: { result in
                    if let goalToUpdate = goalToUpdate {
                        updateGoal(goalToUpdate, result)
                    } else {
                        addGoal(result)
                    }
                    isShowingSheet = false
                },
                goalToUpdate: goalToUpdate
            )
            .presentationDragIndicator(.visible).presentationDetents([
                .height(detentHeight)
            ])
            .readAndBindHeight(to: $detentHeight)
            .onDisappear {
                goalToUpdate = nil
            }
        }
    }
}

#Preview {
    @Previewable @State var filter: GoalsFilter = .all
    @Previewable @State var goalToUpdate: Goal? = nil

    GoalsContent(
        filter: $filter,
        goalToUpdate: $goalToUpdate,
        goals: [
            Goal(name: "Test", count: 10, targetCount: 20, unit: GoalUnit.reps),
            Goal(
                name: "Test 2",
                count: 10,
                targetCount: 20,
                unit: GoalUnit.reps
            ),
            Goal(
                name: "Test 3",
                count: 10,
                targetCount: 20,
                unit: GoalUnit.reps
            ),
        ]
    )
}
