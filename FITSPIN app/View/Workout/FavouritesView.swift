//
//  FavouritesView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//


import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @EnvironmentObject var FavouritesStore: FavouritesStore
    @State private var sortOption: SortOption = .name
    @State private var showDetail: Workout?

    enum SortOption: String, CaseIterable, Identifiable {
        case name = "Name"
        case category = "Category"
        case likedDate = "Liked Date"
        var id: String { rawValue }
    }

    var sortedFavourites: [Workout] {
        let workouts = workoutFavouritesStore.favourites(from: workoutStore.workouts)
        switch sortOption {
        case .name:
            return workouts.sorted { $0.name < $1.name }
        case .category:
            return workouts.sorted { $0.category < $1.category }
        case .likedDate:
            return workouts.sorted {
                let first = workoutFavouritesStore.dateLiked(for: $0) ?? .distantPast
                let second = workoutFavouritesStore.dateLiked(for: $1) ?? .distantPast
                return first > second
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                // Dropdown Menu Sort Option
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
                        .padding(.horizontal)
                }

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(sortedFavourites) { workout in
                            FavouriteWorkoutCard(workout: workout)
                                .onTapGesture {
                                    showDetail = workout
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        workoutFavouritesStore.remove(workout: workout)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Favourites")
            .background(Color.fitspinBackground.ignoresSafeArea())
            .sheet(item: $showDetail) { workout in
                ExerciseDetailLoadedView(workout: workout)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    FavouritesView()
        .environmentObject(WorkoutStore())
        .environmentObject(FavouritesStore())
        .preferredColorScheme(.dark)
}

