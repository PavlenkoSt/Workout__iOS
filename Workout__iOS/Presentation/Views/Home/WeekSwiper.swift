import SwiftUI

private let weekRangeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "MMM d"
    return df
}()

struct WeekSwiper: View {
    @State private var currentWeekOffset = 0

    @Binding var selectedDate: Date
    var trainingDays: [TrainingDay]

    private var mondayOfCurrentWeek: Date {
        let calendar = Calendar.current
        let today = Date().startOfDay
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday - 2 + 7) % 7
        return calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!
    }

    private var statusByDay: [Date: TrainingDayStatus] {
        var result: [Date: TrainingDayStatus] = [:]
        result.reserveCapacity(trainingDays.count)
        for day in trainingDays {
            result[day.date.startOfDay] = day.status
        }
        return result
    }

    var body: some View {
        let monday = mondayOfCurrentWeek
        let statusLookup = statusByDay
        let selectedStart = selectedDate.startOfDay

        VStack(spacing: 10) {
            // Navigation buttons
            WeekSwiperHeader(
                onBackArrowClick: {
                    currentWeekOffset -= 1
                    handleWeekChange(monday: monday)
                },
                onForwardArrowClick: {
                    currentWeekOffset += 1
                    handleWeekChange(monday: monday)
                },
                weekRangeText: { weekRangeText(monday: monday) }
            )

            // Week carousel with TabView
            TabView(
                selection: Binding(
                    get: { currentWeekOffset },
                    set: { newOffset in
                        withAnimation {
                            currentWeekOffset = newOffset
                            handleWeekChange(monday: monday)
                        }
                    }
                )
            ) {
                ForEach(-52...52, id: \.self) { offset in
                    HStack(spacing: 8) {
                        ForEach(0..<7, id: \.self) { dayIndex in
                            let day = getDayInfo(
                                for: dayIndex,
                                weekOffset: offset,
                                monday: monday
                            )
                            DayCard(
                                day: day,
                                isSelected: day.date == selectedStart,
                                onSelectDate: { date in selectedDate = date },
                                status: statusLookup[day.date]
                            )
                        }
                    }
                    .padding(.horizontal)
                    .tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 104)
        }
        .padding(.top, 14)
    }

    private func handleWeekChange(monday: Date) {
        let today = Date().startOfDay

        // If viewing current week (offset = 0), select today
        if currentWeekOffset == 0 {
            selectedDate = today
        } else {
            // Otherwise, select Monday of the viewed week
            let offsetMonday = Calendar.current.date(
                byAdding: .day,
                value: currentWeekOffset * 7,
                to: monday
            )!.startOfDay
            selectedDate = offsetMonday
        }
    }

    private func getDayInfo(
        for index: Int,
        weekOffset: Int,
        monday: Date
    ) -> (name: String, number: Int, isToday: Bool, date: Date) {
        let calendar = Calendar.current

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

    private func weekRangeText(monday: Date) -> String {
        let calendar = Calendar.current

        // Apply the offset to get the correct week
        let offsetMonday = calendar.date(
            byAdding: .day,
            value: currentWeekOffset * 7,
            to: monday
        )!
        let sunday = calendar.date(byAdding: .day, value: 6, to: offsetMonday)!

        return
            "\(weekRangeFormatter.string(from: offsetMonday)) - \(weekRangeFormatter.string(from: sunday))"
    }
}

struct DayCard: View {
    let day: (name: String, number: Int, isToday: Bool, date: Date)
    let isSelected: Bool
    let onSelectDate: (Date) -> Void
    let status: TrainingDayStatus?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 2) {
                Text(day.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSelected ? Color.white.opacity(0.85) : Color.secondary)

                Text("\(day.number)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(isSelected ? Color.white : Color.primary)

                if day.isToday {
                    Text("Today")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(isSelected ? Color.white : Color.indigo)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            (isSelected ? Color.white.opacity(0.18) : Color.indigo.opacity(0.1)),
                            in: Capsule()
                        )
                }
            }
            .padding(.vertical, 10)
            .frame(height: 76)
            .frame(maxWidth: .infinity)
            .background {
                if isSelected {
                    LinearGradient(
                        colors: [.indigo, .teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    Color(.systemBackground).opacity(0.9)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? .white.opacity(0.32) : .black.opacity(0.06))
            )
            .shadow(color: isSelected ? .indigo.opacity(0.2) : .black.opacity(0.05), radius: 10, y: 5)
            .onTapGesture {
                onSelectDate(day.date)
            }

            if let status = status {
                switch status {
                case .completed:
                    Image(systemName: "checkmark.circle")
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(.green)
                        .clipShape(.circle)
                        .offset(x: 4, y: -8)
                case .failed:
                    Image(systemName: "xmark.circle")
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(.orange)
                        .clipShape(.circle)
                        .offset(x: 4, y: -8)
                case .pending:
                    Image(systemName: "circle.circle")
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(.red)
                        .clipShape(.circle)
                        .offset(x: 4, y: -8)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedDate = Date()
    WeekSwiper(selectedDate: $selectedDate, trainingDays: [])
}
