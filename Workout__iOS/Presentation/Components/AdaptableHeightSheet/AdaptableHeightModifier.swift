//
//  AdaptableHeightModifier.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 09.12.2025.
//

import SwiftUI

struct AdaptableHeightModifier: ViewModifier {
    @Binding var currentHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .fixedSize(horizontal: false, vertical: true)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            currentHeight = geometry.size.height
                        }
                        .onChange(of: geometry.size.height) { oldValue, newValue in
                            if newValue != oldValue {
                                currentHeight = newValue
                            }
                        }
                }
            )
    }
}
