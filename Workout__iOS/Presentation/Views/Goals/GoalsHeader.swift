//
//  GoalsHeader.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import SwiftUI

struct GoalsHeader: View {
    @Binding var filter: GoalsFilter

    var width: Double

    var body: some View {
        VStack {
            Menu {
                Button(
                    role: .confirm,
                    action: { filter = .all }
                ) {
                    Label("All", systemImage: "")
                }.tint(.blue)

                Button(
                    role: .confirm,
                    action: { filter = .completed }
                ) {
                    Label("Completed", systemImage: "")
                }.tint(.blue)

                Button(
                    role: .confirm,
                    action: { filter = .pending }
                ) {
                    Label("Pending", systemImage: "")
                }.tint(.blue)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    Text(getGoalsFilterName(filter: filter))
                        .font(.subheadline.weight(.bold))
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(.white)
                .frame(width: width - 32)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [.indigo, .teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .shadow(color: .indigo.opacity(0.18), radius: 12, y: 6)
                .padding(.vertical, 10)
            }
            .padding(.bottom, 6)
        }
    }
}

#Preview {
    @Previewable @State var filter: GoalsFilter = .all

    GoalsHeader(filter: $filter, width: 1000)
}
