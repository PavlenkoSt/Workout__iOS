//
//  CounterProgress.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 13.12.2025.
//

import SwiftUI

struct CounterProgress: View {
    @State private var showCheckmark = false
    
    var count: Int
    var targetCount: Int
    var showsCompletionBadge: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if showsCompletionBadge {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.green)
                    .scaleEffect(showCheckmark ? 1 : 0.3)
                    .opacity(showCheckmark ? 1 : 0)
                    .offset(x: 4, y: -12)
            }

            VStack(spacing: 6) {
                Text("\(count)/\(targetCount)")
                    .font(.subheadline.weight(.bold))
                ProgressView(
                    value: Float(count)
                        / Float(targetCount)
                )
                .tint(.indigo)
            }
            .padding(.bottom, 8)
                .onAppear(perform: {
                    guard showsCompletionBadge else { return }
                    if count >= targetCount {
                        withAnimation(
                            .spring(response: 0.4, dampingFraction: 0.7)
                        ) {
                            showCheckmark = true
                        }
                    }
                })
                .onChange(
                    of: count,
                    perform: {
                        newValue in
                        guard showsCompletionBadge else { return }
                        if newValue >= targetCount {
                            withAnimation(
                                .spring(
                                    response: 0.4,
                                    dampingFraction: 0.7
                                )
                            ) {
                                showCheckmark = true
                            }
                        } else if newValue < targetCount {
                            // Hide checkmark if user “rolls back”
                            withAnimation(.easeOut(duration: 0.2)) {
                                showCheckmark = false
                            }
                        }

                    }
                )
        }
    }
}

#Preview {
    CounterProgress(count: 5, targetCount: 10)
}
