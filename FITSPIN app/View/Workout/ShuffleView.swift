//  View/Workout/ShuffleView.swift
import SwiftUI
import AVKit

struct ShuffleView: View {
    // point these at real files in your bundle:
    private let workouts: [Workout] = [
        Workout(
            title: "Squats",
            type: "Strength",
            imageName: "", // not used when videoURL != nil
            videoURL: Bundle.main.url(forResource: "squatDemo", withExtension: "mp4"),
            suggestions: [
                "Use water bottles or gym weights to push yourself",
                "Make sure posture is correct to avoid injuries"
            ],
            sets: 4,
            reps: 10
        ),
        Workout(
            title: "Lunges",
            type: "Strength",
            imageName: "",
            videoURL: Bundle.main.url(forResource: "lungeDemo", withExtension: "mp4"),
            suggestions: [
                "Keep your front knee over your ankle",
                "Maintain a straight back"
            ],
            sets: 3,
            reps: 12
        )
    ]

    @State private var currentIndex = 0
    @State private var isPlaying = false
    @State private var elapsedTime: TimeInterval = 0

    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 32)

            Text("Today’s Workout")
                .font(.title).bold()
                .foregroundColor(.fitspinYellow)

            TabView(selection: $currentIndex) {
                ForEach(Array(workouts.enumerated()), id: \.element.id) { idx, workout in
                    WorkoutCardView(
                        workout: workout,
                        isPlaying: $isPlaying,
                        elapsedTime: $elapsedTime,
                        onReset: resetTimer
                    )
                    .tag(idx)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 360)
            .padding(.horizontal)

            Spacer()
        }
        .background(Color.fitspinBackground)
    }

    private func resetTimer() {
        isPlaying = false
        elapsedTime = 0
    }
}


struct ShuffleView_Previews: PreviewProvider {
    static var previews: some View {
        ShuffleView()
            .preferredColorScheme(.dark)
    }
}
