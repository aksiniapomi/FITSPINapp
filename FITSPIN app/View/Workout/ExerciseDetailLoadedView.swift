//
//  ExerciseDetailLoadedView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//
import SwiftUI
import AVKit
import Combine

struct ExerciseDetailLoadedView: View {
    let exercise: Workout

    // MARK: – State
    @State private var isFavourite = false
    @State private var timerActive = false
    @State private var timeRemaining = 30

    // A Combine publisher that fires every second
    private let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                videoSection
                titleSection
                equipmentSection
                descriptionSection
                timerSection
            }
            .padding()
        }
        .background(Color.fitspinBackground.ignoresSafeArea())
        .onReceive(timer) { _ in
            guard timerActive, timeRemaining > 0 else { return }
            timeRemaining -= 1
            if timeRemaining == 0 {
                timerActive = false
            }
        }
    }

    // MARK: – Video Preview
    private var videoSection: some View {
        ZStack {
            if let url = exercise.videoURL {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(width: 420, height: 320)
                    .cornerRadius(20)
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 420, height: 320)
                    .overlay {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                    }
            }
        }
        .shadow(radius: 5)
    }

    // MARK: – Title & Type
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.title)
                .font(.largeTitle.bold())
                .foregroundColor(.primary)

            Text(exercise.type.uppercased())
                .font(.caption)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
    }

    // MARK: – Equipment
    private var equipmentSection: some View {
        sectionCard(title: "You'll Need") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(exercise.equipment, id: \.self) { item in

                        // Bodyweight / None fallback
                        if item.lowercased() == "bodyweight" || item.lowercased() == "none" {
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 2)
                                    .frame(width: 80, height: 80)

                                Text("Bodyweight")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 80)

                        // Asset images as squares
                        } else if let name = equipmentAssets
                                        .first(where: { $0.lowercased() == item.lowercased() }) {
                            VStack(spacing: 8) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemBackground))
                                        .stroke(Color.gray, lineWidth: 2)
                                        .frame(width: 80, height: 80)
                                        .shadow(radius: 2)

                                    Image(name)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }

                                Text(item)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 80)
                        }

                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: – Description
    private var descriptionSection: some View {
        sectionCard(title: "Description") {
            Text(exercise.description)
                .foregroundColor(.primary)
        }
    }

    // MARK: – Timer & Controls
    private var timerSection: some View {
        sectionCard(title: "Timer & Controls") {
            VStack(spacing: 16) {
                ProgressView(value: Double(exercise.sets * exercise.reps - timeRemaining), total: Double(exercise.sets * exercise.reps))
                    .scaleEffect(x: 1, y: 1.5)
                    .accentColor(.fitspinYellow)

                Text("Time Remaining: \(timeRemaining)s")
                    .font(.title3)

                HStack(spacing: 32) {
                    Button {
                        withAnimation { isFavourite.toggle() }
                    } label: {
                        Image(systemName: isFavourite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFavourite ? .red : .gray)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.fitspinYellow)

                    Button {
                        timerActive = true
                    } label: {
                        Text("Start").foregroundColor(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.fitspinYellow)

                    Button {
                        timerActive = false
                    } label: {
                        Text("Pause").foregroundColor(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.fitspinYellow)

                    Button {
                        timeRemaining = exercise.sets * exercise.reps
                    } label: {
                        Text("Reset").foregroundColor(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.fitspinYellow)
                }
            }
        }
    }

    // MARK: – Helpers

    private func sectionCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1)
        )
    }

    // Only these asset names will be shown
    private let equipmentAssets = [
        "barbell",
        "bench",
        "dumbbell",
        "gymMat",
        "InclineBench",
        "Kettlebell",
        "Pull-upBar",
        "SZ-Bar"
    ]
}

// MARK: – Preview

struct ExerciseDetailLoadedView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailLoadedView(exercise: Workout(
            apiId:      1,
            title:      "Squats",
            type:       "Strength",
            imageName:  "",
            videoURL:   nil,
            suggestions: ["Keep your chest up", "Drive through your heels"],
            sets:       4,
            reps:       12,
            equipment:  ["Barbell", "Bodyweight"],
            description: "Squats strengthen your lower body and core.",
            muscleIds:  [10, 15]
        ))
        .preferredColorScheme(.dark)
    }
}
