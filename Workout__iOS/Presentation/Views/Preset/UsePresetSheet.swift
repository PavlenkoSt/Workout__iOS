//
//  UsePresetSheet.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 19.12.2025.
//

import SwiftUI

struct UsePresetSheet: View {
    @State private var date: Date = Date()

    var preset: Preset
    var createTrainingDayFromPreset: (Date, Preset) -> Void = {
        _,
        _ in
    }

    var body: some View {
        VStack(spacing: 10) {
            DatePicker(
                "Training day",
                selection: $date,
                displayedComponents: [.date],
            )
            .datePickerStyle(.graphical)

            Button("Create") {
                createTrainingDayFromPreset(date, preset)
                
            }.buttonStyle(.glassProminent)
        }
    }
}

#Preview {
    UsePresetSheet(preset: Preset(name: "Preset"))
}
