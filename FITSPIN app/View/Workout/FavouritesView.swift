//
//  FavouritesView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct FavouritesView: View {
//    @State private var selectedTab: TopTab = .favourites

    // Simulate "unlimited" data for now
    let favouriteWorkouts = Array(repeating: FavouriteWorkout.example, count: 20)

    var body: some View {
        VStack(spacing: 0) {
//            TopBarView(selectedTab: $selectedTab)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(favouriteWorkouts.indices, id: \.self) { index in
                        FavouriteWorkoutCard(workout: favouriteWorkouts[index])
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.fitspinBackground)
        .ignoresSafeArea(.container, edges: .top)
    }
}



struct FavouriteWorkout: Identifiable {
    let id = UUID()
    let title: String
    let intensity: String
    let date: String
    let imageName: String

    static let example = FavouriteWorkout(
        title: "SQUATS",
        intensity: "4 sets of 10",
        date: "28/03/2025",
        imageName: "squats"
    )
}

struct FavouriteWorkoutCard: View {
    let workout: FavouriteWorkout

    var body: some View {
        HStack(spacing: 10) {
            Image(workout.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 100)
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(workout.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("workout Intensity: \(workout.intensity)")
                    .font(.subheadline)
                    .foregroundColor(.white)

                Text("Favourited Date: \(workout.date)")
                    .font(.caption)
                    .foregroundColor(.white)
            }

            Image(systemName: "chevron.right")
                .foregroundColor(Color.fitspinTangerine)
                .font(.system(size: 20, weight: .bold))
        }
        .padding(10)
        .background(Color.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
