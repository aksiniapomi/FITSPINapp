//
//  ExerciseDetailLoadedView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//
import SwiftUI
import AVKit

struct ExerciseDetailLoadedView: View {
    let workout: Workout

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 🎥 Video
                if let url = workout.videoURL {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                }

                // 🏷️ Name + Category
                VStack(alignment: .leading, spacing: 12) {
                    Text(workout.name)
                        .font(.title.bold())
                        .foregroundColor(.white)

                    HStack {
                        Text(workout.category.uppercased())
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.15))
                            .cornerRadius(8)

                        Spacer()
                        Text("\(workout.equipment.count) Equipment")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                // 🧰 Equipment First
                if !workout.equipment.isEmpty {
                    sectionCard(title: "You'll Need") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(workout.equipment, id: \.self) { item in
                                    EquipmentIcon(name: item)
                                }
                            }
                        }
                    }
                }

                // 📄 Description
                sectionCard(title: "Description") {
                    Text(cleanHTML(workout.description))
                        .foregroundColor(.white)
                }

                // 💬 Tips
                if !workout.comments.isEmpty {
                    sectionCard(title: "Tips") {
                        ForEach(workout.comments, id: \.self) { tip in
                            Text("💡 \(tip)")
                                .foregroundColor(.white)
                        }
                    }
                }

                // ⏱️ Slim Timer
                sectionCard(title: "Timer") {
                    ExerciseTimerView(
                        exerciseName: workout.name,
                        equipment: workout.equipment,
                    )
                    .frame(height: 150)
                }
            }
            .padding(.vertical)
        }
        .background(Color.fitspinBackground.ignoresSafeArea())
    }

    // MARK: - Section Card
    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.fitspinYellow)
            content()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }

    // MARK: - HTML Cleaner
    private func cleanHTML(_ html: String) -> String {
        html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


