//
//  ShuffleView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI

struct ShuffleView: View {
    // sample data
    private let workouts: [Workout] =
    [
           Workout(
               name: "Squats",
               videoURL: nil,
               suggestions: [
                   "Use water bottles or gym weights to push yourself",
                   "Make sure posture is correct to avoid injuries"
               ],
               sets: 4,
               reps: 10
           ),
           Workout(
               name: "Lunges",
               videoURL: nil,
               suggestions: ["Keep your front knee over your ankle", "Maintain a straight back"],
               sets: 3,
               reps: 12
           )
           // dummy data to test out the view 
       ]

    @State private var currentIndex = 0
    @State private var isPlaying = false
    @State private var elapsedTime: TimeInterval = 0

    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height:32)
            Text("Today’s Workout")
                .font(.title).bold()
                .foregroundColor(.fitspinYellow)

            TabView(selection: $currentIndex) {
                ForEach(Array(workouts.enumerated()), id: \.1.id) { idx, workout in
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
        .padding(.top, 0)
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
