import SwiftUI

struct WeekSwiper: View {
    @State private var currentWeekOffset = 0

    let selectedDate: Date
    let onSelectDate: (Date) -> Void

    var body: some View {
        VStack(spacing: 4) {
            // Navigation buttons
            WeekSwiperHeader(
                onBackArrowClick: {
                    currentWeekOffset -= 1
                    handleWeekChange()
                },
                onForwardArrowClick: {
                    currentWeekOffset += 1
                    handleWeekChange()
                },
                weekRangeText: weekRangeText
            )

            // Week carousel with TabView
            TabView(
                selection: Binding(
                    get: { currentWeekOffset },
                    set: { newOffset in
                        withAnimation {
                            currentWeekOffset = newOffset
                            handleWeekChange()
                        }
                    }
                )
            ) {
                ForEach(-52...52, id: \.self) { offset in
                    HStack(spacing: 5) {
                        ForEach(0..<7, id: \.self) { dayIndex in
                            let day = getDayInfo(
                                for: dayIndex,
                                weekOffset: offset
                            )
                            DayCard(
                                day: day,
                                isSelected: isDateSelected(day.date),
                                onSelectDate: onSelectDate
                            )
                        }
                    }
                    .padding(.horizontal)
                    .tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 100)
        }
        .padding(.top, 16)
    }

    private func handleWeekChange() {
        let today = Date().startOfDay

        // If viewing current week (offset = 0), select today
        if currentWeekOffset == 0 {
            onSelectDate(today)
        } else {
            // Otherwise, select Monday of the viewed week
            let monday = getMondayOfWeek(weekOffset: currentWeekOffset)
                .startOfDay
            onSelectDate(monday)
        }
    }

    private func getMondayOfWeek(weekOffset: Int) -> Date {
        let calendar = Calendar.current
        let today = Date().startOfDay

        // Get Monday of current week
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday - 2 + 7) % 7

        let monday = calendar.date(
            byAdding: .day,
            value: -daysFromMonday,
            to: today
        )!

        // Apply the offset to get Monday of the target week
        let offsetMonday = calendar.date(
            byAdding: .day,
            value: weekOffset * 7,
            to: monday
        )!

        return offsetMonday
    }

    private func isDateSelected(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }

    private func getDayInfo(for index: Int, weekOffset: Int) -> (
        name: String, number: Int, isToday: Bool, date: Date
    ) {
        let calendar = Calendar.current
        let today = Date().startOfDay

        // Get Monday of current week
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday - 2 + 7) % 7

        let monday = calendar.date(
            byAdding: .day,
            value: -daysFromMonday,
            to: today
        )!

        // Add offset weeks and the day index
        let date = calendar.date(
            byAdding: .day,
            value: (weekOffset * 7) + index,
            to: monday
        )!

        let dayName = calendar.shortWeekdaySymbols[
            calendar.component(.weekday, from: date) - 1
        ]
        let dayNumber = calendar.component(.day, from: date)

        // Check if it's today
        let isToday = calendar.isDateInToday(date) && weekOffset == 0

        return (dayName, dayNumber, isToday, date)
    }

    private func weekRangeText() -> String {
        let calendar = Calendar.current
        let today = Date().startOfDay

        // Get Monday of current week
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday - 2 + 7) % 7

        let monday = calendar.date(
            byAdding: .day,
            value: -daysFromMonday,
            to: today
        )!

        // Apply the offset to get the correct week
        let offsetMonday = calendar.date(
            byAdding: .day,
            value: currentWeekOffset * 7,
            to: monday
        )!
        let sunday = calendar.date(byAdding: .day, value: 6, to: offsetMonday)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"

        return
            "\(dateFormatter.string(from: offsetMonday)) - \(dateFormatter.string(from: sunday))"
    }
}

struct DayCard: View {
    let day: (name: String, number: Int, isToday: Bool, date: Date)
    let isSelected: Bool
    let onSelectDate: (Date) -> Void

    var body: some View {
        VStack(spacing: 2) {
            Text(day.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(isSelected ? .white : .gray)

            Text("\(day.number)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isSelected ? .white : .black)

            if day.isToday {
                Text("Today")
                    .font(.system(size: 12))
                    .foregroundColor(isSelected ? .white : .black)
            }
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.blue : Color(.systemGray6))
        .cornerRadius(12)
        .onTapGesture {
            onSelectDate(day.date)
        }
    }
}

#Preview {
    WeekSwiper(selectedDate: Date(), onSelectDate: { _ in })
}
