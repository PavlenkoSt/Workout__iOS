//
//  TrainingDayHeader.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 30.11.2025.
//

import SwiftUI
import Foundation

struct TrainingDayHeader: View {
    let selectedDate: Date
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM dd yyyy"
        return formatter
    }()
    
    var body: some View {
        Text("Workout Session - \(formatter.string(from: selectedDate))")
            .font(Font.title)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
    }
}

#Preview {
    TrainingDayHeader(selectedDate: Date())
}
