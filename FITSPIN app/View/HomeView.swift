//
//  HomeView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)

            Text("Overview of the day, weather-based suggestions, and quick stats.")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
        .fullScreenBackground()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

