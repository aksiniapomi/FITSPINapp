///
//  CompletedWorkoutsView.swift
//  FITSPIN app
//

import SwiftUI

struct CompletedWorkoutsView: View {
    @EnvironmentObject var completedStore: CompletedWorkoutsStore
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var selectedWorkout: Workout?
    @State private var showCalendar = false
    @Environment(\.dismiss) private var dismiss 

    var groupedByDate: [(Date, [CompletedWorkout])] {
        Dictionary(grouping: completedStore.completed) { $0.dateOnly }
            .sorted { $0.key > $1.key }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(groupedByDate, id: \.0) { (date, entries) in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(formatted(date))
                                .font(.headline)
                                .foregroundColor(.fitspinYellow)
                                .padding(.horizontal)

                            ForEach(entries) { entry in
                                if let workout = workoutStore.workouts.first(where: { $0.exerciseId == entry.exerciseId }) {
                                    Button {
                                        selectedWorkout = workout
                                    } label: {
                                        HStack(spacing: 16) {
                                            Image(systemName: "checkmark.seal.fill")
                                                .foregroundColor(.green)
                                                .imageScale(.large)

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(workout.name)
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)

                                                Text(workout.category.capitalized)
                                                    .font(.caption)
                                                    .foregroundColor(.fitspinBlue)
                                            }

                                            Spacer()

                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color.gray.opacity(0.15))
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
               .navigationTitle("Completed Workouts")
               .navigationBarTitleDisplayMode(.inline)
               .navigationBarBackButtonHidden(true)            // hide default
               .toolbar {
                 ToolbarItem(placement: .navigationBarLeading) {
                   Button {
                     dismiss()
                   } label: {
                     HStack(spacing: 4) {
                       Image(systemName: "chevron.left")
                       Text("Account")
                     }
                   }
                 }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCalendar = true
                    }) {
                        Image(systemName: "calendar")
                            .foregroundColor(.fitspinYellow)
                    }
                }
            }
            .sheet(item: $selectedWorkout) { workout in
                ExerciseDetailLoadedView(workout: workout)
            }
            .sheet(isPresented: $showCalendar) {
                CompletedWorkoutCalendarView()
            }
            .background(Color.fitspinBackground.ignoresSafeArea())
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
