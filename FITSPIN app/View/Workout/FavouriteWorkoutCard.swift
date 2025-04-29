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
    @State private var player: AVPlayer?

    var body: some View {
        HStack(spacing: 12) {
            // 🎥 Video Preview
            if let url = workout.videoURL {
                VideoPlayer(player: player)
                    .frame(width: 100, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onAppear {
                        player = AVPlayer(url: url)
                        player?.isMuted = true
                        player?.play()
                    }
                    .onDisappear {
                        player?.pause()
                    }
            } else {
                Color.gray
                    .frame(width: 100, height: 70)
                    .cornerRadius(8)
            }

            // 📝 Details
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

            // 💔 Heart Toggle
            Button {
                favourites.toggle(workout)
            } label: {
                Image(systemName: favourites.isFavourite(workout) ? "heart.fill" : "heart")
                    .foregroundColor(.fitspinTangerine)
                    .scaleEffect(favourites.isFavourite(workout) ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: favourites.isFavourite(workout))
            }
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

