//
//  CompletedWorkoutCalendarView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 26/04/2025.
//
import SwiftUI

struct CompletedWorkoutCalendarView: View {
    @EnvironmentObject var completedStore: CompletedWorkoutsStore

    private var groupedByDate: [Date: Int] {
        Dictionary(grouping: completedStore.completed) { $0.dateOnly }
            .mapValues { $0.count }
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    private let calendar = Calendar.current
    private let currentDate = Date()

    private var monthDates: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))
        else { return [] }

        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workout Calendar")
                .font(.title.bold())
                .foregroundColor(.fitspinYellow)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }

                ForEach(monthDates, id: \.self) { date in
                    let count = groupedByDate[date, default: 0]
                    ZStack {
                        Circle()
                            .fill(count > 0 ? Color.fitspinTangerine.opacity(0.7) : Color.clear)
                            .frame(width: 36, height: 36)

                        Text("\(calendar.component(.day, from: date))")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .background(Color.fitspinBackground.ignoresSafeArea())
    }
}

// MARK: - Preview
#Preview {
    CompletedWorkoutCalendarView()
        .environmentObject(CompletedWorkoutsStore())
        .preferredColorScheme(.dark)
}
