//
//  ContentView.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftUI

enum Tabs: Equatable, Hashable {
    case home
    case goals
    case records
    case presets
}

struct ContentView: View {
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                Home()
            }
            Tab("Goals", systemImage: "checkmark", value: .goals) {
                Goals()
            }
            Tab("Records", systemImage: "star.fill", value: .records) {
                Records()
            }
            Tab("Presets", systemImage: "heart.fill", value: .presets) {
                Presets()
            }
        }
    }
}

#Preview {
    ContentView()
}
