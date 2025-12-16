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
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray.opacity(0.3))
        )
        .padding(8)
    }
}

#Preview {
    @Previewable @State var searchText = ""
    PresetsHeader(searchText: $searchText)
}
