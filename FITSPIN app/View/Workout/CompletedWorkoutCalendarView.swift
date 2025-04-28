//
//  CompletedWorkoutCalendarView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 26/04/2025.
//
// CompletedWorkoutCalendarView.swift

import SwiftUI

struct CompletedWorkoutCalendarView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var completedStore: CompletedWorkoutsStore
    @EnvironmentObject var workoutStore: WorkoutStore

    @State private var selectedDate: Date? = nil
    @State private var showDetails = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Workout Calendar")
                .font(.title)
                .bold()
                .foregroundColor(.fitspinYellow)

            DatePicker(
                "",
                selection: Binding(
                    get: { selectedDate ?? Date() },
                    set: { selectedDate = $0; showDetails = true }
                ),
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .accentColor(.fitspinYellow)
            .padding()

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showDetails) {
            if let date = selectedDate {
                WorkoutsForDayView(date: date)
                    .environmentObject(completedStore)
                    .environmentObject(workoutStore)
            }
        }
        .background(Color.fitspinBackground.ignoresSafeArea())
    }
}


// MARK: - Preview
#Preview {
    CompletedWorkoutCalendarView()
        .environmentObject(CompletedWorkoutsStore())
        .preferredColorScheme(.dark)
}
