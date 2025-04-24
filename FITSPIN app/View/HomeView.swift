//
//  HomeView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI
import CoreLocation  //location

//Simple weather model
struct Weather {
    let temperature: Double
    let condition: Condition
    
    enum Condition: String {
        case clear, partlyCloudy = "partly_cloudy", rain, snow, thunderstorm
        
        var iconName: String {
            switch self {
            case .clear: return "sun.max.fill"
            case .partlyCloudy: return "cloud.sun.fill"
            case .rain: return "cloud.rain.fill"
            case .snow: return "cloud.snow.fill"
            case .thunderstorm: return "cloud.bolt.rain.fill"
            }
        }
        var description: String {
            switch self {
            case .clear:         return "Perfect weather for a park workout!"
            case .partlyCloudy:  return "A few clouds - still great! Let's train outside"
            case .rain:          return "Might want an indoor session today."
            case .snow:          return "Wrap up warm or hit the treadmill!"
            case .thunderstorm:  return "Better stay inside—storm’s coming."
            }
        }
    }
}

//ViewModel to fetch & publish weather
@MainActor
class HomeViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchWeather() async {
        isLoading = true
        errorMessage = nil
        do {
            // simulate network delay; replace with real API call
            try await Task.sleep(nanoseconds: 500_000_000)
            let dummy = Weather(temperature: 22.0, condition: .partlyCloudy)
            weather = dummy
        } catch {
            errorMessage = "Unable to load weather."
        }
        isLoading = false
    }
}

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    let userName = "Xenia"   //make dynamic later

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

