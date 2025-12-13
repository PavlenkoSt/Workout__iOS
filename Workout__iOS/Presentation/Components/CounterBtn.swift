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
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 24, weight: Font.Weight.medium))
        }
        .padding(.vertical, 6)
        .background(Color.blue)
        .cornerRadius(CGFloat(8))
        .foregroundStyle(.white)
        .buttonStyle(.borderless)
    }
}
