//
//  PresetItem.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 15.12.2025.
//

import SwiftUI

struct PresetItem: View {
    var preset: Preset

    var body: some View {
        Text("\(preset.name) (\(preset.exercises.count) exercises)")
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PresetItem(
        preset: Preset(
            name: "Hardcore training",
        )
    )
}
