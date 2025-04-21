//
//  HydrationView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct HydrationView: View {
    var body: some View {
        VStack {
            Text("Hydration Tracker")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)

            Text("This screen will show a calendar and let users log water intake.")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
        .fullScreenBackground()
    }
}

struct HydrationView_Previews: PreviewProvider {
    static var previews: some View {
        HydrationView()
    }
}

