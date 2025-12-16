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

    @State var searchText: String = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    PresetsHeader(
                        searchText: $searchText
                    )
                    if !presets.isEmpty {
                        List(presets) { preset in
                            PresetItem(preset: preset)
                        }
                    } else {
                        Text("No presets yet")
                            .padding(12)
                    }
                }

                Button {
                    // TODO add preset
                } label: {
                    FloatingBtn()
                }
                .padding()
            }
        }
    }
}

#Preview {
    PresetsContent(
        presets: [
            Preset(name: "Bar training"),
            Preset(name: "Handbalance training"),
            Preset(name: "Hardcore training"),
        ]
    )
}
