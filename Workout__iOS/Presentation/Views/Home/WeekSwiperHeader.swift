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
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text(weekRangeText())
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onForwardArrowClick()
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
}
