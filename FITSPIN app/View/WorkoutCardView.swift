//
//  WorkoutCardView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI

struct WorkoutCardView: View {
    var body: some View {
        VStack {
            Text("Workout Deck")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)

            Text("This is where a user sees the shuffled workout cards.")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
        .fullScreenBackground()
    }
}

struct WorkoutCardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardView()
    }
}
