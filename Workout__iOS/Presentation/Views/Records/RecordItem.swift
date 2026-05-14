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
        HStack(spacing: 12) {
            Image(systemName: "trophy.fill")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(
                    LinearGradient(
                        colors: [.indigo, .teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: Circle()
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(record.exercise)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(formatDateToDay(record.date))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(getRecordResult(record))
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.indigo)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.indigo.opacity(0.1), in: Capsule())
        }
        .padding(14)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.75))
        )
        .shadow(color: .black.opacity(0.07), radius: 14, y: 7)
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
