////
////  FilterView.swift
////  FITSPIN app
////
////  Created by Derya Baglan on 21/04/2025.
////
import SwiftUI

struct FilterView: View {
//    @State private var searchText = ""
//
    var body: some View {
//        VStack(spacing: 0) {
//            TopBarView(selectedTab: .constant(.filter))
//
//            ScrollView(showsIndicators: false) {
//                VStack(spacing: 20) {
//                    // Search Bar
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(.gray)
//                        TextField("Search workout categories", text: $searchText)
//                            .foregroundColor(.white)
//                    }
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//
//                    // Category: Park Workout
//                    VStack(alignment: .leading, spacing: 8) {
//                        Image("parkWorkout") // Make sure this asset exists
//                            .resizable()
//                            .scaledToFit()
//                            .cornerRadius(12)
//                            .padding(.horizontal)
//
//                        Text("Trending")
//                            .font(.headline)
//                            .foregroundColor(.fitspinYellow)
//                            .padding(.horizontal)
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 20) {
//                                ForEach(sampleCategories) { category in
//                                    VStack {
//                                        Image(category.imageName)
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 60, height: 60)
//                                            .clipShape(Circle())
//
//                                        Text(category.title)
//                                            .foregroundColor(.fitspinTangerine)
//                                            .font(.caption)
//                                    }
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
//
//                    // Category: Strength Training
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack {
//                            Text("Strength Training")
//                                .font(.headline)
//                                .foregroundColor(.fitspinYellow)
//
//                            Spacer()
//
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(.fitspinYellow)
//                        }
//                        .padding(.horizontal)
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(sampleWorkouts) { workout in
//                                    WorkoutCardView(workout: workout)
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
//                }
//                .padding(.top, 12)
//            }
//        }
//        .background(Color.fitspinBackground)
//        .ignoresSafeArea()
    }
}
//
#Preview {
    FilterView()
}
//struct WorkoutCategory: Identifiable {
//    let id = UUID()
//    let title: String
//    let imageName: String
//}
//
//struct Workout: Identifiable {
//    let id = UUID()
//    let title: String
//    let type: String
//    let imageName: String
//}
//let sampleCategories: [WorkoutCategory] = [
//    WorkoutCategory(title: "Yoga", imageName: "yoga"),
//    WorkoutCategory(title: "Upper Body", imageName: "upperbody"),
//    WorkoutCategory(title: "Lower Body", imageName: "lowerbody"),
//    WorkoutCategory(title: "Running", imageName: "running")
//]
//
//let sampleWorkouts: [Workout] = [
//    Workout(title: "Lower Body Strength", type: "STRENGTH", imageName: "strength1"),
//    Workout(title: "Bodyweight Training", type: "STRENGTH", imageName: "strength2"),
//    Workout(title: "HIIT", type: "STRENGTH", imageName: "strength3")
//]
//struct WorkoutCardView: View {
//    let workout: Workout
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            Image(workout.imageName)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 150, height: 120)
//                .clipped()
//                .cornerRadius(10)
//
//            Text(workout.type.uppercased())
//                .font(.caption2)
//                .foregroundColor(.fitspinBlue)
//
//            Text(workout.title)
//                .font(.caption)
//                .foregroundColor(.white)
//        }
//        .frame(width: 150)
//        .background(Color.gray.opacity(0.2))
//        .cornerRadius(12)
//    }
//}
//
