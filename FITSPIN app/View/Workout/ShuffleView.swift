//
//  ShuffleView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//

import SwiftUI
import AVKit

//struct ShuffleView: View {
//    // MARK: - Sample Workouts
//    private let workouts: [Workout] = [
//        Workout(
//            apiId: 101,
//            title: "Squats",
//            type: "Strength",
//            imageName: "squats",
//            videoURL: Bundle.main.url(forResource: "squatDemo", withExtension: "mp4"),
//            suggestions: [
//                "Use water bottles or gym weights to push yourself",
//                "Make sure posture is correct to avoid injuries"
//            ],
//            sets: 4,
//            reps: 10,
//            equipment: ["Dumbbells", "Bodyweight"],
//            description: "Squats build strength in your glutes, hamstrings, and quads.",
//            muscleIds: [10, 8]
//        ),
//        Workout(
//            apiId: 102,
//            title: "Lunges",
//            type: "Strength",
//            imageName: "lunges",
//            videoURL: Bundle.main.url(forResource: "lungeDemo", withExtension: "mp4"),
//            suggestions: [
//                "Keep your front knee over your ankle",
//                "Maintain a straight back"
//            ],
//            sets: 3,
//            reps: 12,
//            equipment: ["Bodyweight", "Dumbbells"],
//            description: "Lunges target your legs and glutes while improving balance.",
//            muscleIds: [10, 12]
//        )
//    ]
//
//    // MARK: - State
//    @State private var currentIndex = 0
//    @State private var isPlaying = false
//    @State private var elapsedTime: TimeInterval = 0
//
//    // MARK: - Body
   //var body: some View {
//        VStack(spacing: 16) {
//            Spacer().frame(height: 32)
//
//            Text("Today’s Workout")
//                .font(.title).bold()
//                .foregroundColor(.fitspinYellow)
//
//            TabView(selection: $currentIndex) {
//                ForEach(Array(workouts.enumerated()), id: \.element.id) { idx, workout in
//                    WorkoutCardView(
//                        workout: workout,
//                        isPlaying: $isPlaying,
//                        elapsedTime: $elapsedTime,
//                        onReset: resetTimer
//                    )
//                    .tag(idx)
//                }
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .frame(height: 360)
//            .padding(.horizontal)
//
//            Spacer()
//        }
//        .background(Color.fitspinBackground)
//    }
//
//    // MARK: - Helper
//    private func resetTimer() {
//        isPlaying = false
//        elapsedTime = 0
 //}
//}
//
//// MARK: - Preview
//struct ShuffleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShuffleView()
//            .preferredColorScheme(.dark)
 //   }
//}
//
    //
  

    struct ShuffleView: View {
      var body: some View {
        VStack {
          Text("Shuffle")
            .font(.largeTitle)
            .foregroundColor(.fitspinYellow)
          Spacer()
        }
        .background(Color.fitspinBackground)
      }
    }

    struct ShuffleView_Previews: PreviewProvider {
      static var previews: some View {
        ShuffleView()
      }
    }
