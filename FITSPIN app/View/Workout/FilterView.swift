//
//  FilterView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI

struct FilterView: View {
    @StateObject private var vm = FilterViewModel()
    @State private var selectedWorkout: Workout?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                contentBody
            }
            .navigationTitle("Find a Workout")
            .background(Color.fitspinBackground.ignoresSafeArea())
            .sheet(item: $selectedWorkout) { workout in
                ExerciseDetailLoadedView(workout: workout)
            }
        }
    }

    private var contentBody: some View {
        VStack(alignment: .leading, spacing: 24) {
            searchBar
            SuggestedWorkoutBanner(weather: vm.weather)
            trendingCategories
            workoutResults
        }
        .padding(.top)
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search workout types", text: $vm.searchText)
                .foregroundColor(.white)
                .onChange(of: vm.searchText) { _ in vm.search() }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    private var trendingCategories: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeaderView(title: "Trending") // ✅ No chevron

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.categories) { category in
                        let imageName = category.name.replacingOccurrences(of: " ", with: "").capitalized
                        Button(action: {
                            vm.applyCategory(category.name)
                        }) {
                            TrendingCategoryCard(
                                category: WorkoutCategory(title: category.name, imageName: imageName),
                                isSelected: vm.selectedCategory == category.name
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var workoutResults: some View {
        Group {
            if !vm.filteredWorkouts.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeaderView(title: "Results")

                    LazyVStack(spacing: 16) {
                        ForEach(vm.filteredWorkouts) { workout in
                            WorkoutCardView(workout: workout)
                                .onTapGesture {
                                    selectedWorkout = workout
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("No workouts found")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}


struct SectionHeaderView: View {
    let title: String
    var hasChevron: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.fitspinYellow)
            Spacer()
            if hasChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.fitspinYellow)
            }
        }
        .padding(.horizontal)
    }
}

struct WorkoutCategory: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct TrendingCategoryCard: View {
    let category: WorkoutCategory
    var isSelected: Bool = false

    var body: some View {
        VStack(spacing: 6) {
            Image(caseInsensitive: category.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.fitspinBlue : .clear, lineWidth: 3)
                )

            Text(category.title)
                .foregroundColor(.white)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .frame(width: 70)
        }
        .padding(4)
        .background(isSelected ? Color.fitspinBlue.opacity(0.2) : Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}


#Preview {
    FilterView()
        .preferredColorScheme(.dark)
}
