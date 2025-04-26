//
//  WorkoutListView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 25/04/2025.
//
import SwiftUI

struct WorkoutListView: View {
    let workouts: [Workout]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(workouts) { workout in
                    NavigationLink(value: workout) {
                        WorkoutCardView(workout: workout)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

