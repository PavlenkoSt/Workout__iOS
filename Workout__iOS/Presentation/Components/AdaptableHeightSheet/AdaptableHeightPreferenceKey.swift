//
//  AdaptableHeightPreferenceKey.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 09.12.2025.
//

import SwiftUI

struct AdaptableHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}
