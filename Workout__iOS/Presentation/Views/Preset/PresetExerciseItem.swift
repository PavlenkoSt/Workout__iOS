//
//  PresetExerciseItem.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 17.12.2025.
//

import SwiftUI

struct PresetExerciseItem: View {
    var presetExercise: PresetExercise
    var index: Int

    var body: some View {
        HStack {
            Text(
                "\(index + 1). \(getPresetExerciseName(exercise: presetExercise))"
            )
            Spacer()
            if presetExercise.type == .dynamic
                || presetExercise.type == .staticType
            {
                PresetExerciseStatItem(
                    title: presetExercise.type == .staticType ? "Hold" : "Reps",
                    value: String(presetExercise.reps)
                )
                PresetExerciseStatItem(
                    title: "Sets",
                    value: String(presetExercise.sets)
                )
                PresetExerciseStatItem(
                    title: "Rest",
                    value: String(presetExercise.rest)
                )
            }
        }
    }
}

private struct PresetExerciseStatItem: View {
    var title: String
    var value: String

    var body: some View {
        VStack {
            Text(title)
            Text(value).font(.system(size: 13))
        }.padding(.horizontal, 4)
    }
}

#Preview {
    PresetExerciseItem(
        presetExercise: PresetExercise(
            name: "Pull ups",
            order: 0,
            sets: 10,
            reps: 20,
            rest: 120,
            preset: Preset(name: "Some preset"),
            type: ExerciseType.dynamic
        ),
        index: 0
    )
}
