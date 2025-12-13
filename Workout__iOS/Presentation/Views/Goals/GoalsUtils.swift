//
//  utils.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

func getGoalsFilterName(filter: GoalsFilter) -> String {
    switch filter {
    case .all:
        return "All"
    case .completed:
        return "Completed"
    case .pending:
        return "Pending"
    }
}

func getGoalUnitName(unit: GoalUnit) -> String {
    switch unit {
    case .km:
        "Km"
    case .reps:
        "Reps"
    case .sec:
        "Sec"
    case .min:
        "Min"
    }
}
