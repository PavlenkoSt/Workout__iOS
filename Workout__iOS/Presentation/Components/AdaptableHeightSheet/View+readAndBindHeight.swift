//
//  View+readAndBindHeight.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 09.12.2025.
//

import SwiftUI

extension View {
    func readAndBindHeight(to height: Binding<CGFloat>) -> some View {
        self.modifier(AdaptableHeightModifier(currentHeight: height))
    }
}
