//
//  CounterBtn.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import SwiftUI

struct CounterBtn: View {
    var text: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(text)
                .frame(maxWidth: .infinity, minHeight: 40, alignment: .center)
                .font(.system(size: 24, weight: .bold))
        }
        .background(
            LinearGradient(
                colors: [.indigo, .teal],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .foregroundStyle(.white)
        .buttonStyle(.borderless)
        .shadow(color: .indigo.opacity(0.18), radius: 8, y: 4)
    }
}
