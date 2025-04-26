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

// MARK: - Equipment Icon
struct EquipmentIcon: View {
    let name: String

    var body: some View {
        VStack(spacing: 6) {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(name)
                .font(.caption2)
                .foregroundColor(.white)
                .frame(width: 70)
                .lineLimit(1)
        }
    }
}

// MARK: - Timer View
struct ExerciseTimerView: View {
    @State private var remainingTime: Int = 30
    @State private var selectedTime: Int = 30
    @State private var isRunning: Bool = false
    @State private var timer: Timer?

    let exerciseName: String
    let equipment: [String]

    var body: some View {
        VStack(spacing: 8) {
            // ⏱️ Time Display
            Text(timeString(from: remainingTime))
                .font(.system(size: 28, weight: .medium, design: .monospaced))
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.2))
                .cornerRadius(12)

            // 🔧 Slider
            VStack(spacing: 4) {
                Text("Duration: \(selectedTime) sec")
                    .font(.caption2)
                    .foregroundColor(.gray)

                Slider(value: Binding(
                    get: { Double(selectedTime) },
                    set: { newValue in
                        selectedTime = Int(newValue)
                        if !isRunning {
                            remainingTime = selectedTime
                        }
                    }
                ), in: 10...180, step: 5)
                .accentColor(.fitspinYellow)
            }

            // 🎮 Controls (Smaller)
            HStack(spacing: 20) {
                Button(action: reset) {
                    Image(systemName: "gobackward")
                }

                Button(action: toggleTimer) {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                }

                Button(action: stopNow) {
                    Image(systemName: "stop.fill")
                }
            }
            .font(.body)
            .foregroundColor(.white)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(8)
        .background(Color.black.opacity(0.2))
        .cornerRadius(16)
    }


    // MARK: - Timer Logic
    private func toggleTimer() {
        isRunning.toggle()
        isRunning ? startTimer() : stopTimer()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func stopNow() {
        stopTimer()
        remainingTime = 0
        isRunning = false
    }

    private func reset() {
        stopTimer()
        remainingTime = selectedTime
        isRunning = false

    }

    private func timeString(from seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
#if DEBUG
struct ExerciseDetailLoadedView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailLoadedView(workout: Workout(
            exerciseId: 123,
            name: "Barbell Lunges Standing",
            description: """
                Put barbell on the back of your shoulders. Stand upright, then take the first step forward. \
                Step should bring you forward so that your supporting leg’s knee can touch the floor. \
                Then stand back up and repeat with the other leg. Remember to keep good posture.
            """,
            videoURL: URL(string: "https://wger.de/media/exercise-images/65/barbell-lunges-1.jpg"),
            equipment: ["Barbell"],
            category: "Legs",
            comments: [
                "Keep back straight at all times.",
                "Control your step to avoid knee stress.",
                "Engage your glutes during the rise."
            ]
        ))
        .preferredColorScheme(.dark)
    }
}
#endif

