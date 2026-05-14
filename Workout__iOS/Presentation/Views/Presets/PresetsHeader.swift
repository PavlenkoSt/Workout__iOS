//
//  PresetsHeader.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 16.12.2025.
//

import SwiftUI

struct PresetsHeader: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search", text: $searchText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(height: 50)
        .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.75))
        )
        .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    @Previewable @State var searchText = ""
    PresetsHeader(searchText: $searchText)
}
