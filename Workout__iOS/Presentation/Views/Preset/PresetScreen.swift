//
//  Preset.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 17.12.2025.
//

import SwiftUI

struct PresetScreen: View {
    var preset: Preset

    var body: some View {
        Text(preset.name)
    }
}

#Preview {
    PresetScreen(
        preset: Preset(name: "Preset here")
    )
}
