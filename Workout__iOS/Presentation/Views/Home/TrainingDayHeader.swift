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
        ZStack(alignment: .bottomTrailing) {
            Text("Workout Session - \(formatter.string(from: selectedDate))")
                .font(Font.title)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .foregroundStyle(.black)

            if status == .completed {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .offset(x: 10, y: 0)
            }
        }
    }
}

#Preview {
    TrainingDayHeader(selectedDate: Date(), status: nil)
}
