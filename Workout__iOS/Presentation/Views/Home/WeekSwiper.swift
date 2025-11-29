import SwiftUI

struct WeekSwiper: View {
    @State private var currentWeekOffset = 0
    
    var body: some View {
        VStack(spacing: 16) {
            // Navigation buttons
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentWeekOffset -= 1
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
                        currentWeekOffset += 1
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            // Week carousel with TabView
            TabView(selection: $currentWeekOffset) {
                ForEach(-52...52, id: \.self) { offset in
                    HStack(spacing: 12) {
                        ForEach(0..<7, id: \.self) { dayIndex in
                            DayCard(day: getDayInfo(for: dayIndex, weekOffset: offset))
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
    
    private func getDayInfo(for index: Int, weekOffset: Int) -> (name: String, number: Int, isToday: Bool) {
        let calendar = Calendar.current
        let today = Date()
        
        // Get Monday of current week
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday - 2 + 7) % 7
        
        let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!
        
        // Add offset weeks and the day index
        let date = calendar.date(byAdding: .day, value: (weekOffset * 7) + index, to: monday)!
        
        let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
        let dayNumber = calendar.component(.day, from: date)
        
        // Check if it's today
        let isToday = calendar.isDateInToday(date) && weekOffset == 0
        
        return (dayName, dayNumber, isToday)
    }
    
    private func weekRangeText() -> String {
        let calendar = Calendar.current
        let today = Date()
        
        // Get Monday of current week
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday - 2 + 7) % 7
        
        let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!
        
        // Apply the offset to get the correct week
        let offsetMonday = calendar.date(byAdding: .day, value: currentWeekOffset * 7, to: monday)!
        let sunday = calendar.date(byAdding: .day, value: 6, to: offsetMonday)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        return "\(dateFormatter.string(from: offsetMonday)) - \(dateFormatter.string(from: sunday))"
    }
}

struct DayCard: View {
    let day: (name: String, number: Int, isToday: Bool)
    
    var body: some View {
        VStack(spacing: 8) {
            Text(day.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(day.isToday ? .white : .gray)
            
            Text("\(day.number)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(day.isToday ? .white : .black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(day.isToday ? Color.blue : Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    WeekSwiper()
}
