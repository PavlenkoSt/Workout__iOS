//
//  ProIndicator.swift
//  Workout__iOS
//

import SwiftUI

struct ProIndicator: View {
    let monetizationState: MonetizationState
    var presentPaywall: () -> Void = {}

    var body: some View {
        if monetizationState.isRevenueCatConfigured && !monetizationState.isPro {
            Button(action: presentPaywall) {
                HStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Pro")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.accentColor)
                .clipShape(Capsule())
                .shadow(
                    color: .black.opacity(0.2),
                    radius: 6,
                    x: 0,
                    y: 3
                )
            }
            .buttonStyle(.plain)
        }
    }
}
