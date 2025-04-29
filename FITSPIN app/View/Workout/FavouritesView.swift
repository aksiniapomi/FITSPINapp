//
//  FavouritesView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//


import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @EnvironmentObject var favouritesStore: FavouritesStore
    @State private var sortOption: SortOption = .name
    @State private var showDetail: Workout?

    enum SortOption: String, CaseIterable, Identifiable {
        case name = "Name"
        case category = "Category"
        case likedDate = "Liked Date"
        var id: String { rawValue }
    }

    var sortedFavourites: [Workout] {
        let workouts = favouritesStore.favourites(from: workoutStore.workouts)
        switch sortOption {
        case .name:
            return workouts.sorted { $0.name < $1.name }
        case .category:
            return workouts.sorted { $0.category < $1.category }
        case .likedDate:
            return workouts.sorted {
                let a = favouritesStore.dateLiked(for: $0) ?? .distantPast
                let b = favouritesStore.dateLiked(for: $1) ?? .distantPast
                return a > b
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Favourites")
                    .font(.largeTitle.bold())
                    .padding(.horizontal)

                HStack {
                    Spacer()
                    Menu {
                        ForEach(SortOption.allCases) { option in
                            Button {
                                sortOption = option
                            } label: {
                                Label(option.rawValue, systemImage: sortOption == option ? "checkmark" : "")
                            }
                        }
                    } label: {
                        Label("Sort by: \(sortOption.rawValue)", systemImage: "arrow.up.arrow.down")
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing)
                }

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(sortedFavourites) { workout in
                            workoutCard(for: workout)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .sheet(item: $showDetail) { workout in
                ExerciseDetailLoadedView(workout: workout)
            }
            .background(Color.fitspinBackground.ignoresSafeArea())
        }
    }

    @ViewBuilder
    private func workoutCard(for workout: Workout) -> some View {
        FavouriteWorkoutCard(workout: workout)
            .onTapGesture {
                showDetail = workout
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    favouritesStore.toggle(workout)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
    }
}

