//
//  RecordsUtils.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import Foundation

func getRecordUnitName(unit: RecordUnit) -> String {
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

func formatDateToDay(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yy"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: date)
}
