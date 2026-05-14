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
        HStack(spacing: 12) {
            Image(systemName: "rectangle.stack.fill")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(
                    LinearGradient(
                        colors: [.indigo, .teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: Circle()
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(preset.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text("\(preset.exercises.count) exercises")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(14)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.75))
        )
        .shadow(color: .black.opacity(0.07), radius: 14, y: 7)
    }
}

#Preview {
    PresetItem(
        preset: Preset(
            name: "Hardcore training"
        )
    )
}
