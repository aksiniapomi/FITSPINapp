//
//  SuggestedWorkoutBanner.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 26/04/2025.
//

import SwiftUI

struct SuggestedWorkoutBanner: View {
    var weather: Weather?
    
    private var suggestedType: String {
        guard let weather = weather else { return "Workout" }
        return weather.temperature >= 20 ? "Park Workout" : "Indoor Training"
    }
    
    private var imageName: String {
        guard let weather = weather else { return "indoorWorkout" }
        return weather.temperature >= 20 ? "parkWorkout" : "indoorWorkout"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Suggested Workout of the Day")
                .font(.headline)
                .foregroundColor(.fitspinYellow)
                .padding(.horizontal)
            
            ZStack(alignment: .bottomLeading) {
                Image(caseInsensitive: imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
                    .cornerRadius(12)
                
                Text(suggestedType)
                    .font(.title3).bold()
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(8)
                    .padding(10)
            }
            .padding(.horizontal)
        }
    }
}
