//
//  WorkoutCardView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI
import AVKit   // for VideoPlayer

struct WorkoutCardView: View {
    let workout: Workout             // this comes from Models/Workout.swift
    @Binding var isPlaying: Bool
    @Binding var elapsedTime: TimeInterval
    let onReset: () -> Void

    @State private var timer: Timer?
    @State private var isLiked = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.fitspinInputBG.opacity(0.2))
                .shadow(radius: 4)

            VStack(spacing: 12) {
                Spacer()

                // Video or placeholder
                if let url = workout.videoURL {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: 180)
                        .cornerRadius(12)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 180)
                        .cornerRadius(12)
                        .overlay(
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.fitspinOffWhite.opacity(0.7))
                        )
                }

                // Workout info
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.title)
                        .font(.headline)
                        .foregroundColor(.fitspinTangerine)
                    Text("\(workout.sets) sets of \(workout.reps)")
                        .font(.subheadline)
                        .foregroundColor(.fitspinOffWhite)
                    Text("SUGGESTIONS")
                        .font(.caption2).bold()
                        .foregroundColor(.fitspinOffWhite.opacity(0.7))
                    ForEach(workout.suggestions, id: \.self) { s in
                        Text("• \(s)")
                            .font(.caption2)
                            .foregroundColor(.fitspinOffWhite)
                    }
                }
                .padding(.horizontal)

                // Timer + controls
                HStack(spacing: 24) {
                    Button(action: onReset) {
                        Text("R")
                            .font(.headline)
                            .foregroundColor(.fitspinBlue)
                            .frame(width: 40, height: 40)
                            .background(Circle().stroke(Color.fitspinBlue, lineWidth: 2))
                    }
                    Button {
                        isPlaying = false
                        timer?.invalidate()
                    } label: {
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.fitspinTangerine)
                    }
                    Button {
                        isPlaying = true
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            elapsedTime += 1
                        }
                    } label: {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.fitspinBlue)
                    }
                    Text(timeString(from: elapsedTime))
                        .font(.subheadline.monospacedDigit())
                        .foregroundColor(.fitspinOffWhite)
                }
                .padding(.bottom, 8)
            }
            .padding()

            // Like button
            Button {
                isLiked.toggle()
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor(isLiked ? .fitspinTangerine : .fitspinOffWhite)
            }
            .offset(x: -16, y: -16)
        }
    }

    private func timeString(from seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

struct WorkoutCardView_Previews: PreviewProvider {
    @State static var playing = false
    @State static var time: TimeInterval = 0

    static var previews: some View {
        WorkoutCardView(
            workout: Workout(
                apiId:       101,
                title:       "Squats",
                type:        "Strength",
                imageName:   "squats",
                videoURL:    nil,
                suggestions: ["Use weights", "Keep back straight"],
                sets:        4,
                reps:        10,
                equipment:   ["Bodyweight", "Dumbbells"],
                description: "Squats are a foundational movement for building lower body strength.",
                muscleIds:   [10, 12]
            ),
            isPlaying: $playing,
            elapsedTime: $time,
            onReset: {
                playing = false
                time = 0
            }
        )
        .preferredColorScheme(.dark)
        .frame(width: 320, height: 450)
    }
}




///
