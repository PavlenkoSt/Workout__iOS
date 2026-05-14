//
//  WeekSwiperHeader.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftUI

struct WeekSwiperHeader: View {
    let onBackArrowClick: () -> Void
    let onForwardArrowClick: () -> Void
    let weekRangeText: () -> String
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onBackArrowClick()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.indigo)
                    .frame(width: 36, height: 36)
                    .background(.white.opacity(0.9), in: Circle())
            }
            
            Spacer()
            
            Text(weekRangeText())
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.primary)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onForwardArrowClick()
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.indigo)
                    .frame(width: 36, height: 36)
                    .background(.white.opacity(0.9), in: Circle())
            }
        }
        .padding(.horizontal)
    }
}
