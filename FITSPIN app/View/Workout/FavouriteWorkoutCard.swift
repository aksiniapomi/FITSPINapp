//
//  FavouriteWorkoutCard.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 26/04/2025.
//

import SwiftUI
import AVKit

struct FavouriteWorkoutCard: View {
    let workout: Workout
    @EnvironmentObject var favourites: FavouritesStore

    var body: some View {
        HStack(spacing: 12) {
            if let url = workout.videoURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure: Color.gray
                    @unknown default: Color.gray
                    }
                }
                .frame(width: 100, height: 70)
                .clipped()
                .cornerRadius(8)
            } else {
                Color.gray
                    .frame(width: 100, height: 70)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(workout.category.capitalized)
                    .font(.caption)
                    .foregroundColor(.fitspinBlue)

                if !workout.equipment.isEmpty {
                    Text(workout.equipment.joined(separator: ", "))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }

                if let date = favourites.dateLiked(for: workout) {
                    Text("Liked: \(formatted(date))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Image(systemName: "heart.fill")
                .foregroundColor(.fitspinTangerine)
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }

    private func formatted(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .short
        return df.string(from: date)
    }
}

