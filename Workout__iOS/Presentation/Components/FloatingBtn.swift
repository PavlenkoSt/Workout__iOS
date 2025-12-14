//
//  FloatingBtn.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import SwiftUI

struct FloatingBtn: View {
    var body: some View {
        Image(systemName: "plus")
            .font(.title.weight(.semibold))
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}
