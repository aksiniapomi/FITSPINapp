//
//  WorkoutCardView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI
import AVKit   // for VideoPlayer

// Model for each workout
struct Workout: Identifiable {
    let id = UUID()
    let name: String
    let videoURL: URL?
    let suggestions: [String]
    let sets: Int
    let reps: Int
}

struct WorkoutCardView: View {
    let workout: Workout
    @Binding var isPlaying: Bool
    @Binding var elapsedTime: TimeInterval
    
    let onReset: () -> Void
    
    @State private var timer: Timer?
    //local state for liked
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
                    Text("\(workout.sets) sets of \(workout.reps)")
                        .font(.subheadline).bold()
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
                    // 1) Circular “R” reset
                    Button {
                        onReset()
                    } label: {
                        Text("R")
                            .font(.headline)
                            .foregroundColor(.fitspinBlue)
                    }
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .stroke(Color.fitspinBlue, lineWidth: 2)
                    )
                    // Pause button
                    Button {
                        isPlaying = false
                        timer?.invalidate()
                    } label: {
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.fitspinTangerine)
                    }
                    
                    // Play button
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
                    
                    // Elapsed timer
                    Text(timeString(from: elapsedTime))
                        .font(.subheadline.monospacedDigit())
                        .foregroundColor(.fitspinOffWhite)
                }
                .padding(.bottom, 8)
            }
            .padding()
            
            // Floating favorite toggable button
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
    
    private func togglePlay() {
        if isPlaying {
            // stop timer
        } else {
            // start timer
        }
        isPlaying.toggle()
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
                name: "Squats",
                videoURL: nil,
                suggestions: ["Use weights", "Keep back straight"],
                sets: 4, reps: 10
            ),
            isPlaying: $playing,
            elapsedTime: $time,
            onReset: { playing = false; time = 0 }
        )
        .preferredColorScheme(.dark)
        .frame(width: 300, height: 400)
    }
}
