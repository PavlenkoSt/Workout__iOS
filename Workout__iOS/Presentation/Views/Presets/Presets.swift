//
//  Goals.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftData
import SwiftUI
import Toasts

struct Presets: View {
    @Environment(\.presentToast) var presentToast

    @ObservedObject var viewModel: PresetsViewModel
    let monetizationState: MonetizationState
    var presentPaywall: () -> Void = {}

    @Query(sort: [SortDescriptor(\Preset.order)]) var presets: [Preset]

    var body: some View {
        PresetsContent(
            presets: presets,
            monetizationState: monetizationState,
            presentPaywall: presentPaywall,
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
            },
            deleteExercise: { exercise in
                viewModel.deleteExercise(exercise: exercise)
            },
            addDefaultExerciseToPreset: { exerciseFormResult, preset in
                viewModel.addDefaultExerciseToPreset(
                    exerciseFormResult: exerciseFormResult,
                    preset: preset
                )
            },
            addLadderExerciseToPreset: { exerciseFormResult, preset in
                viewModel.addLadderExerciseToPreset(
                    exerciseFormResult: exerciseFormResult,
                    preset: preset
                )
            },
            addSimpleExerciseToPreset: {
                exerciseFormResult,
                preset in
                viewModel.addSimpleExerciseToPreset(
                    exerciseFormResult: exerciseFormResult,
                    preset: preset
                )
            },
            updatePresetOrder: { reorderedPresets in
                viewModel.updatePresetOrder(presets: reorderedPresets)
            },
            updatePresetExercisesOrder: { reorderedPresetExercises in
                viewModel.updatePresetExercisesOrder(
                    presetExercises: reorderedPresetExercises
                )
            },
            createTrainingDayFromPreset: { date, preset in
                Task {
                    try await presentToast(
                        message: "Loading...",
                        task: {
                            try await viewModel.createTrainingDayFromPreset(
                                date: date,
                                preset: preset
                            )
                        },
                        onSuccess: { result in
                            ToastValue(
                                icon: Image(systemName: "checkmark.circle"),
                                message: "Training day has been created"
                            )
                        },
                        onFailure: { error in
                            ToastValue(
                                icon: Image(systemName: "xmark.circle"),
                                message: "Training day already exists"
                            )
                        }
                    )
                }

            },
            saveChanges: {
                viewModel.saveChanges()
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
    let monetizationState: MonetizationState
    var presentPaywall: () -> Void = {}

    var createPreset: (PresetSubmitResult) -> Void = { _ in }
    var updatePreset:
        (_ presetToUpdate: Preset, _ result: PresetSubmitResult) -> Void = {
            _,
            _ in
        }
    var deletePreset: (Preset) -> Void = { _ in }
    var deleteExercise: (PresetExercise) -> Void = { _ in }
    var addDefaultExerciseToPreset:
        (DefaultExerciseSubmitResult, Preset) -> Void = { _, _ in }
    var addLadderExerciseToPreset:
        (LadderExerciseSubmitResult, Preset) -> Void = { _, _ in }
    var addSimpleExerciseToPreset:
        (SimpleExerciseSubmitResult, Preset) -> Void = { _, _ in }

    var presetsWithSearch: [Preset] {
        if searchText.isEmpty {
            return presets
        }

        return presets.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    var updatePresetOrder: ([Preset]) -> Void = { _ in }
    var updatePresetExercisesOrder: ([PresetExercise]) -> Void = { _ in }
    var createTrainingDayFromPreset: (Date, Preset) -> Void = {
        _,
        _ in
    }
    var saveChanges: () -> Void = {}

    private var shouldGatePro: Bool {
        monetizationState.isRevenueCatConfigured && !monetizationState.isPro
    }

    private func handleMove(from source: IndexSet, to destination: Int) {
        guard searchText.isEmpty else { return }

        var mutablePresets = presetsWithSearch

        mutablePresets.move(fromOffsets: source, toOffset: destination)

        for (newIndex, preset) in mutablePresets.enumerated() {
            if preset.order != newIndex {
                preset.order = newIndex
            }
        }

        updatePresetOrder(mutablePresets)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(
                colors: [
                    Color(.systemIndigo).opacity(0.12),
                    Color(.systemTeal).opacity(0.06),
                    Color(.systemGroupedBackground),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            GeometryReader { geometry in
                VStack {
                    PresetsHeader(
                        searchText: $searchText
                    )
                    if !presetsWithSearch.isEmpty {
                        List {
                            ForEach(presetsWithSearch) {
                                preset in
                                NavigationLink(value: preset) {
                                    PresetItem(preset: preset)
                                        .swipeActions(
                                        edge: .trailing,
                                        allowsFullSwipe: false
                                    ) {
                                        Button(role: .destructive) {
                                            deletePreset(preset)
                                        } label: {
                                            Label(
                                                "Delete",
                                                systemImage: "trash"
                                            )
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
                                        }.tint(.indigo)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(
                                    EdgeInsets(top: 7, leading: 16, bottom: 7, trailing: 16)
                                )
                                .listRowBackground(Color.clear)
                            }
                            .onMove(perform: handleMove)
                            .moveDisabled(!searchText.isEmpty)

                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .navigationDestination(for: Preset.self) {
                            preset in
                            PresetScreen(
                                preset: preset,
                                addDefaultExerciseToPreset:
                                    addDefaultExerciseToPreset,
                                addLadderExerciseToPreset:
                                    addLadderExerciseToPreset,
                                addSimpleExerciseToPreset:
                                    addSimpleExerciseToPreset,
                                deleteExerciseFromPreset: deleteExercise,
                                createTrainingDayFromPreset:
                                    createTrainingDayFromPreset,
                                updatePresetExercisesOrder:
                                    updatePresetExercisesOrder,
                                saveChanges: saveChanges
                            )
                        }
                    } else {
                        Text(
                            presets.isEmpty
                                ? "No presets yet" : "Presets not found"
                        )
                        .font(.headline)
                        .padding(12)
                        Spacer()
                    }
                }
            }

            Button {
                if shouldGatePro && presets.count >= MonetizationConfig.freePresetLimit {
                    presentPaywall()
                } else {
                    isShowingSheet = true
                }
            } label: {
                FloatingBtn()
            }
            .padding()

            ProIndicator(
                monetizationState: monetizationState,
                presentPaywall: presentPaywall
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding()
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
        ],
        monetizationState: MonetizationState(isLoading: false)
    )
}
