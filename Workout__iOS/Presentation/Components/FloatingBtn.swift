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
            .frame(width: 60, height: 60)
            .background(
                LinearGradient(
                    colors: [.indigo, .teal],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(color: .indigo.opacity(0.35), radius: 18, y: 10)
    }
}
