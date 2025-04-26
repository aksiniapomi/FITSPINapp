//
//  WorkoutCardView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI
import AVKit

struct WorkoutCardView: View {
    let workout: Workout

    @State private var isPlaying = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var player: AVPlayer?
    @State private var animateHeart = false
    @State private var showToast = false
    @State private var toastMessage = ""

    @EnvironmentObject var favouritesStore: FavouritesStore

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 🎥 Video
            if let url = workout.videoURL {
                VideoPlayer(player: player)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .onAppear {
                        player = AVPlayer(url: url)
                    }
            } else {
                Color.gray.opacity(0.3)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.white.opacity(0.7))
                    )
            }

            // 📋 Info + Heart
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.category.uppercased())
                        .font(.caption2)
                        .foregroundColor(.fitspinBlue)

                    HStack {
                        Text(workout.name)
                            .font(.headline)
                            .foregroundColor(.white)

                        Spacer()

                        ZStack(alignment: .topTrailing) {
                            Button(action: {
                                favouritesStore.toggle(workout)
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    animateHeart = true
                                    toastMessage = favouritesStore.isFavourite(workout) ? "Added to Favourites" : "Removed from Favourites"
                                    showToast = true
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    animateHeart = false
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation { showToast = false }
                                }
                            }) {
                                Image(systemName: favouritesStore.isFavourite(workout) ? "heart.fill" : "heart")
                                    .resizable()
                                    .frame(width: 26, height: 24)
                                    .foregroundColor(favouritesStore.isFavourite(workout) ? .fitspinTangerine : .gray)
                                    .scaleEffect(animateHeart ? 1.3 : 1.0)
                                    .shadow(color: favouritesStore.isFavourite(workout) ? .fitspinTangerine.opacity(0.6) : .clear,
                                            radius: animateHeart ? 6 : 0)
                            }

                            if !favouritesStore.isFavourite(workout) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.fitspinTangerine)
                                    .background(Color.black.opacity(0.8).clipShape(Circle()))
                                    .offset(x: 8, y: -4)
                            }
                        }
                    }

                    if !workout.equipment.isEmpty {
                        Text("Equipment: \(workout.equipment.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }

            // ✅ Toast Feedback
            if showToast {
                Text(toastMessage)
                    .font(.caption)
                    .padding(8)
                    .background(Color.fitspinTangerine.opacity(0.95))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .padding(.top, 4)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.13))
        .cornerRadius(6)
        .onDisappear {
            pause()
            player?.pause()
        }
    }

    // MARK: - Timer Logic
    private func start() {
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }

    private func pause() {
        isPlaying = false
        timer?.invalidate()
    }

    private func reset() {
        elapsedTime = 0
        timer?.invalidate()
    }

    private func timeString(from seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: - Preview
#if DEBUG
struct WorkoutCardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardView(workout: Workout(
            exerciseId: 301,
            name: "Barbell Lunges Standing",
            description: "Lower body strength with form focus.",
            videoURL: URL(string: "https://wger.de/media/exercise-images/65/barbell-lunges-1.jpg"),
            equipment: ["Barbell"],
            category: "Legs",
            comments: []
        ))
        .preferredColorScheme(.dark)
        .environmentObject(FavouritesStore())
    }
}
#endif



