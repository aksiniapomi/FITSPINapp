//
//  WorkoutsForDayView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 28/04/2025.
//

import SwiftUI

struct WorkoutsForDayView: View {
    let date: Date
    @EnvironmentObject var completedStore: CompletedWorkoutsStore
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var selectedWorkout: Workout? = nil

    var workoutsForDate: [Workout] {
        let matchingEntries = completedStore.completed.filter {
            Calendar.current.isDate($0.dateOnly, inSameDayAs: date)
        }
        return matchingEntries.compactMap { entry in
            workoutStore.workouts.first(where: { $0.exerciseId == entry.exerciseId })
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Completed Workouts")
                        .font(.title.bold())
                        .foregroundColor(.fitspinYellow)
                        .padding(.horizontal)

                    Text(dateFormatted)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    if workoutsForDate.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No workouts logged for this day")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 50)
                    } else {
                        ForEach(workoutsForDate) { workout in
                            WorkoutCard(workout: workout) {
                                selectedWorkout = workout
                            }
                            .padding(.horizontal)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .animation(.spring(), value: workoutsForDate)
                        }
                    }
                }
                .padding(.top)
            }
            .background(Color.fitspinBackground.ignoresSafeArea())
            .sheet(item: $selectedWorkout) { workout in
                ExerciseDetailLoadedView(workout: workout)
            }
        }
    }

    private var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct WorkoutCard: View {
    let workout: Workout
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)

                VStack(alignment: .leading, spacing: 6) {
                    Text(workout.name)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(workout.category.capitalized)
                        .font(.caption)
                        .foregroundColor(.fitspinTangerine)

                    if let comment = workout.comments.first {
                        Text(comment)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .italic()
                    }
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
    }
}
