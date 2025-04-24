//
//  FilterView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

//  FilterView.swift
//  FITSPIN app

import SwiftUI

struct FilterView: View {
    @State private var searchText = ""
    @State private var selectedWorkout: Workout? = nil
    @State private var selectedCategory: String? = nil

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // 🔍 Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search workout types", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    // 🌤 Suggested Workout
                    SuggestedWorkoutBanner()

                    // 🔥 Trending Categories
                    SectionHeaderView(title: "Trending")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(sampleCategories.filter {
                                searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText)
                            }) { category in
                                NavigationLink(value: category.title) {
                                    TrendingCategoryCard(category: category, isSelected: false)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // 💪 Focus Areas
                    SectionHeaderView(title: "By Focus Area")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(focusAreas) { focus in
                                NavigationLink(value: focus.title) {
                                    FocusAreaCard(focus: focus)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationDestination(for: String.self) { filterTitle in
                FilteredWorkoutListView(
                    filterTitle: filterTitle,
                    matchingWorkouts: sampleWorkouts.filter { $0.type.localizedCaseInsensitiveContains(filterTitle) },
                    selectedWorkout: $selectedWorkout
                )
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedWorkout != nil },
                set: { if !$0 { selectedWorkout = nil } }
            )) {
                if let workout = selectedWorkout {
                    WorkoutDeckViewFromSingle(workout: workout)
                }
            }
            .background(Color.fitspinBackground)
            .ignoresSafeArea()
        }
    }
}

struct FilteredWorkoutListView: View {
    let filterTitle: String
    let matchingWorkouts: [Workout]
    @Binding var selectedWorkout: Workout?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(matchingWorkouts) { workout in
                    Button(action: {
                        selectedWorkout = workout
                    }) {
                        WorkoutCard(workout: workout)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("\(filterTitle) Workouts")
        .background(Color.fitspinBackground)
    }
}

struct WorkoutDeckViewFromSingle: View {
    let workout: Workout

    var body: some View {
        VStack {
            Text("Shuffle Preview")
                .font(.title2)
                .foregroundColor(.white)
                .padding()

            WorkoutCard(workout: workout)
                .padding()

            Spacer()
        }
        .background(Color.fitspinBackground)
        .ignoresSafeArea()
    }
}


struct SuggestedWorkoutBanner: View {
    var weatherCondition: String = "sunny" // can come from a weather API

    var body: some View {
        let suggestedType = (weatherCondition == "sunny") ? "Park Workout" : "Indoor Training"
        let imageName = (weatherCondition == "sunny") ? "parkWorkout" : "indoorWorkout" // your asset names

        VStack(alignment: .leading, spacing: 8) {
            Text("Suggested Workout of the Day")
                .font(.headline)
                .foregroundColor(.fitspinYellow)
                .padding(.horizontal)

            ZStack(alignment: .bottomLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
                    .cornerRadius(12)

                Text(suggestedType)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .padding(10)
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

struct TrendingCategoryCard: View {
    let category: WorkoutCategory
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Image(category.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())

                if isSelected {
                    Circle()
                        .stroke(Color.fitspinTangerine, lineWidth: 3)
                        .frame(width: 74, height: 74)
                }
            }

            Text(category.title)
                .foregroundColor(isSelected ? .fitspinTangerine : .white)
                .font(.caption)
                .multilineTextAlignment(.center)
                .frame(width: 70)
        }
    }
}

struct WorkoutDeckView: View {
    let selectedFilter: WorkoutCategory?

    var body: some View {
        VStack {
            Text("Shuffle View")
                .font(.title)
                .foregroundColor(.white)
                .padding(.top)

            if let filter = selectedFilter {
                Text("Showing workouts for: \(filter.title)")
                    .foregroundColor(.fitspinTangerine)
            }

            Spacer()
        }
        .background(Color.fitspinBackground)
        .ignoresSafeArea()
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
struct FocusAreaCard: View {
    let focus: FocusArea

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(focus.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 130)
                .clipped()
                .cornerRadius(10)

            Text(focus.title.uppercased())
                .font(.caption2)
                .foregroundColor(.fitspinOffWhite)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

        }
        .frame(width: 160)
        .cornerRadius(5)
    }
}

struct WorkoutCard: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(workout.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
                .clipped()
                .cornerRadius(10)

            Text(workout.type.uppercased())
                .font(.caption2)
                .foregroundColor(.fitspinBlue)

            Text(workout.title)
                .font(.body)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}


struct WorkoutCategory: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct Workout: Identifiable {
    let id = UUID()
    let title: String
    let type: String
    let imageName: String
}
struct FocusArea: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}


let sampleWorkouts: [Workout] = [
    .init(title: "Lower Body Strength", type: "Strength", imageName: "strength1"),
    .init(title: "Bodyweight HIIT", type: "HIIT", imageName: "strength2"),
    .init(title: "Full Body Burn", type: "Cardio", imageName: "strength3")
]

let sampleCategories: [WorkoutCategory] = [
    .init(title: "Full Body", imageName: "fullbody"),
    .init(title: "Cardio", imageName: "cardio"),
    .init(title: "HIIT", imageName: "hiit"),
    .init(title: "Strength", imageName: "strength"),
    .init(title: "Stretching", imageName: "stretching"),
    .init(title: "Pilates", imageName: "pilates"),
    .init(title: "Abs & Core", imageName: "core"),
    .init(title: "Glutes", imageName: "glutes"),
    .init(title: "Arms", imageName: "arms"),
    .init(title: "Back", imageName: "back"),
    .init(title: "Chest", imageName: "chest"),
    .init(title: "Legs", imageName: "legs"),
]

let focusAreas: [FocusArea] = [
    .init(title: "Upper Body", imageName: "back"),
    .init(title: "Lower Body", imageName: "glutes"),
    .init(title: "Core & Abs", imageName: "core"),
    .init(title: "Flexibility", imageName: "stretching"),
    .init(title: "Bodyweight", imageName: "hiit"),
    .init(title: "Quick Workouts", imageName: "strength")
]


#Preview {
    FilterView()
        .preferredColorScheme(.dark)
}
