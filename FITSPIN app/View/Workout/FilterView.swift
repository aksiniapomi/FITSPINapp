//
//  FilterView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct FilterView: View {
    @State private var searchText = ""

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

                    // 🌤 Suggested Workout Banner
                    SuggestedWorkoutBanner()

                    // 🔥 Trending Categories
                    SectionHeaderView(title: "Trending", hasChevron: true)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(sampleCategories) { category in
                                NavigationLink(value: category.title) {
                                    TrendingCategoryCard(category: category)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // 💪 Focus Areas
                    SectionHeaderView(title: "By Focus Area", hasChevron: true)
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
            .navigationTitle("Find a Workout")
            // When a category or focus is tapped, go to filtered list
            .navigationDestination(for: String.self) { filterTitle in
                FilteredWorkoutListView(
                    filterTitle: filterTitle,
                    matchingWorkouts: sampleWorkouts.filter {
                        $0.type.localizedCaseInsensitiveContains(filterTitle)
                    }
                )
            }
            // When a workout is tapped in the filtered list, go to detail
            .navigationDestination(for: Workout.self) { workout in
                ExerciseDetailLoadedView(exercise: workout)
            }
            .background(Color.fitspinBackground.ignoresSafeArea())
        }
    }
}

// MARK: – Filtered List

struct FilteredWorkoutListView: View {
    let filterTitle: String
    let matchingWorkouts: [Workout]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(matchingWorkouts) { workout in
                    NavigationLink(value: workout) {
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

// MARK: – Suggested Workout Banner

struct SuggestedWorkoutBanner: View {
    var weatherCondition: String = "sunny" // replace with real data

    var body: some View {
        let suggestedType = (weatherCondition == "sunny") ? "Park Workout" : "Indoor Training"
        let imageName = (weatherCondition == "sunny") ? "parkWorkout" : "indoorWorkout"

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
                    .font(.title3).bold()
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(8)
                    .padding(10)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: – Section Header

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

// MARK: – Trending Category Card

struct TrendingCategoryCard: View {
    let category: WorkoutCategory

    var body: some View {
        VStack(spacing: 6) {
            Image(category.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())

            Text(category.title)
                .foregroundColor(.white)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .frame(width: 70)
        }
        .padding(4)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

// MARK: – Focus Area Card

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
                .frame(width: 160)
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

// MARK: – Workout Card

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

// MARK: – Supporting Types & Sample Data

struct WorkoutCategory: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct FocusArea: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

let sampleWorkouts: [Workout] = [
    Workout(
        apiId: 1,
        title: "Lower Body Strength",
        type: "Strength",
        imageName: "strength1",
        videoURL: nil,
        suggestions: ["Slow reps", "Engage core"],
        sets: 4,
        reps: 12,
        equipment: ["Dumbbells"],
        description: "This lower body strength workout targets your quads, glutes, and hamstrings.",
        muscleIds: [10, 11, 12]      // wger muscle‐group IDs, or empty if you're mocking
    ),
    Workout(
        apiId: 2,
        title: "Bodyweight HIIT",
        type: "HIIT",
        imageName: "hiit1",
        videoURL: nil,
        suggestions: ["Jump squats", "High knees"],
        sets: 3,
        reps: 15,
        equipment: ["None"],
        description: "A high-intensity routine to get your heart pumping without any equipment.",
        muscleIds: []               // no specific muscle IDs here
    ),
    Workout(
        apiId: 3,
        title: "Full Body Burn",
        type: "Cardio",
        imageName: "cardio1",
        videoURL: nil,
        suggestions: ["No rest", "Keep moving"],
        sets: 5,
        reps: 20,
        equipment: ["Yoga Mat"],
        description: "A full-body cardio blast to increase endurance and burn calories fast.",
        muscleIds: [1, 2, 3]        // placeholder IDs
    )
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

// MARK: – Preview

#Preview {
    FilterView()
        .preferredColorScheme(.dark)
}
