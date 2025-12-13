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

    @State var filter: GoalsFilter = .all

    var body: some View {
        GoalsContent(
            filter: $filter,
            addGoal: { result in viewModel.addGoal(goalSubmitResult: result) }
        )
    }
}

struct GoalsContent: View {
    @Binding var filter: GoalsFilter

    @State var isShowingSheet: Bool = false
    @State private var detentHeight: CGFloat = 0

    @Query var goals: [Goal]

    var addGoal: (GoalSubmitResult) -> Void = { _ in }

    var filteredGoals: [Goal] {
        if filter == .all {
            return goals
        } else {
            return goals.filter {
                $0.status == (filter == .completed ? .completed : .pending)
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                GoalsHeader(filter: $filter)

                if !filteredGoals.isEmpty {
                    List(filteredGoals) { goal in
                        GoalItem(goal: goal)
                    }
                } else {
                    Text("No goals yet")
                        .padding(.vertical, 30)
                }

                Spacer()
            }

            Button {
                isShowingSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.title.weight(.semibold))
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .padding()
        }.sheet(isPresented: $isShowingSheet) {
            GoalSheet(
                onSubmit: { result in
                    addGoal(result)
                    isShowingSheet = false
                }
            )
            .presentationDragIndicator(.visible).presentationDetents([
                .height(detentHeight)
            ])
            .readAndBindHeight(to: $detentHeight)
        }
    }
}

#Preview {
    @Previewable @State var filter: GoalsFilter = .all

    GoalsContent(filter: $filter)
}
