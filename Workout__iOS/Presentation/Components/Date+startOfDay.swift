//
//  Date+startOfDay.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 11.12.2025.
//

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
