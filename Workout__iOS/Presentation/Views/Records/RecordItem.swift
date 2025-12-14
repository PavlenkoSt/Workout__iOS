//
//  RecordItem.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import SwiftUI

struct RecordItem: View {
    var record: RecordModel

    var body: some View {
        HStack {
            Text(record.exercise)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(getRecordResult(record))
                .frame(maxWidth: .infinity, alignment: .center)

            Text(formatDateToDay(record.date))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

private func getRecordResult(_ record: RecordModel) -> String {
    return "\(record.count) \(getRecordUnitName(unit: record.unit))"
}

#Preview {
    RecordItem(
        record: RecordModel(
            exercise: "Pull ups",
            count: 10,
            unit: RecordUnit.reps,
            date: Date()
        )
    )
}
