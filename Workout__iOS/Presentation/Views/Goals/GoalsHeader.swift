//
//  GoalsHeader.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import SwiftUI

struct GoalsHeader: View {
    @Binding var filter: GoalsFilter

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
                Button(
                    getGoalsFilterName(filter: filter),
                    systemImage: "arrow.uturn.down"
                ) {}
                .buttonStyle(.glassProminent).frame(width: 300).padding(
                    .vertical,
                    5
                )
            }
        }
    }
}

#Preview {
    @Previewable @State var filter: GoalsFilter = .all

    GoalsHeader(filter: $filter)
}
