//
//  HomeView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @EnvironmentObject private var authVM: AuthViewModel
  
    // derive a name from Firebase.User
    private var userName: String {
      if let displayName = authVM.user?.displayName,
         !displayName.isEmpty {
        return displayName
      }
      // fallback to the part before the “@” in their email
      let email = authVM.user?.email ?? "User"
      return String(email.split(separator: "@").first ?? Substring(email))
    }

    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()

            if vm.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.fitspinYellow)
            }
            else if let weather = vm.weather {
                content(for: weather)
            }
            else if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.fitspinTangerine)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            else {
                Color.clear
                    .onAppear {
                        Task { await vm.fetchWeather() }
                    }
            }
        }
    }

    @ViewBuilder
    private func content(for w: Weather) -> some View {
        VStack(spacing: 24) {
            // Logo
            HStack {
                    Image("fitspintext")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                Spacer()
                }
                .padding(.leading, 30)  
                .padding(.top, 80)
            
            // Greeting
            Text("HELLO, \(userName.uppercased())!")
                .font(.title2).bold()
                .foregroundColor(.fitspinBlue)

            // Weather Icon
            Image(systemName: w.condition.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.fitspinYellow)

            // Temperature
            Text(String(format: "%.0fºC", w.temperature))
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(.fitspinOffWhite)

            // Description
            Text(w.condition.description)
                .font(.subheadline)
                .foregroundColor(.fitspinYellow.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Action button
            Button("LET’S GO!") {
                // Navigate to Workout Cards tab, e.g. via a binding or router
            }
           .buttonStyle(FPFilledButtonStyle())
            .frame(width: 200)

     Spacer()
            
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}

