//
//  Goals.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftData
import SwiftUI

struct Presets: View {
    @ObservedObject var viewModel: PresetsViewModel

    @Query var presets: [Preset]

    var body: some View {
        PresetsContent(
            presets: presets
        )
    }
}

struct PresetsContent: View {
    var presets: [Preset]

    var body: some View {
        Text("Hello, Presets!")
    }
}

#Preview {
    PresetsContent(
        presets: [
            Preset(name: "Bar training"),
            Preset(name: "Handbalance training"),
        ]
    )
}
