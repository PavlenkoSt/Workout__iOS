//
//  View+roundedBorder.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 09.12.2025.
//

import SwiftUI

struct RoundedBorderModifier: ViewModifier {
    var cornerRadius: CGFloat = 6
    var strokeColor: Color = .gray
    var lineWidth: CGFloat = 1
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: lineWidth)
            )
    }
}

extension View {
    func roundedBorder(cornerRadius: CGFloat = 6, color: Color = .gray, lineWidth: CGFloat = 1) -> some View {
        modifier(RoundedBorderModifier(cornerRadius: cornerRadius, strokeColor: color, lineWidth: lineWidth))
    }
}
