//
//  TrainingDayHeader.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 30.11.2025.
//

import Foundation
import SwiftUI

struct TrainingDayHeader: View {
    let selectedDate: Date
    let status: TrainingDayStatus?

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM dd yyyy"
        return formatter
    }()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                Text("Workout Session")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)

                Text(formatter.string(from: selectedDate))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(0.7))
            )
            .shadow(color: .black.opacity(0.07), radius: 18, y: 8)

            if status == .completed {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .offset(x: 8, y: -8)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    TrainingDayHeader(selectedDate: Date(), status: nil)
}
