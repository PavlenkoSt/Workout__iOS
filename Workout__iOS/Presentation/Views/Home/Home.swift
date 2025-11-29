//
//  Home.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftUI

struct Home: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            WeekSwiper()
            Spacer()
        }
    }
}

#Preview {
    Home()
}
