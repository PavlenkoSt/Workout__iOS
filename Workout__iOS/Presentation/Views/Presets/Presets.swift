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
            presets: presets,
            createPreset: { result in
                viewModel.createPreset(result: result)
            },
            updatePreset: { presetToUpdate, result in
                viewModel.updatePreset(
                    presetToUpdate: presetToUpdate,
                    result: result
                )
            },
            deletePreset: { preset in
                viewModel.deletePreset(preset: preset)
            }
        )
    }
}

struct PresetsContent: View {
    var presets: [Preset]

    @State private var isShowingSheet = false
    @State private var detentHeight: CGFloat = 0
    @State var searchText: String = ""
    @State var presetToUpdate: Preset? = nil

    var createPreset: (PresetSubmitResult) -> Void = { _ in }
    var updatePreset:
        (_ presetToUpdate: Preset, _ result: PresetSubmitResult) -> Void = {
            _,
            _ in
        }
    var deletePreset: (Preset) -> Void = { _ in }

    var presetsWithSearch: [Preset] {
        if searchText.isEmpty {
            return presets
        }

        return presets.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    PresetsHeader(
                        searchText: $searchText
                    )
                    if !presetsWithSearch.isEmpty {
                        List(presetsWithSearch) { preset in
                            PresetItem(preset: preset).swipeActions(
                                edge: .trailing,
                                allowsFullSwipe: false
                            ) {
                                Button(role: .destructive) {
                                    deletePreset(preset)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(
                                edge: .leading,
                                allowsFullSwipe: false
                            ) {
                                Button {
                                    presetToUpdate = preset
                                    isShowingSheet = true
                                } label: {
                                    Label(
                                        "Edit",
                                        systemImage: "square.and.pencil"
                                    )
                                }.tint(.blue)
                            }
                        }
                    } else {
                        Text(
                            presets.isEmpty
                                ? "No presets yet" : "Presets not found"
                        )
                        .padding(12)
                        Spacer()
                    }
                }

                Button {
                    isShowingSheet = true
                } label: {
                    FloatingBtn()
                }
                .padding()
            }
        }.sheet(isPresented: $isShowingSheet) {
            PresetSheet(
                presetToUpdate: presetToUpdate,
                onSubmit: { result in
                    if let presetToUpdate = presetToUpdate {
                        updatePreset(presetToUpdate, result)
                    } else {
                        createPreset(result)
                    }
                    isShowingSheet = false
                }
            )
            .presentationDragIndicator(.visible).presentationDetents([
                .height(detentHeight)
            ])
            .readAndBindHeight(to: $detentHeight)
            .onDisappear {
                presetToUpdate = nil
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
