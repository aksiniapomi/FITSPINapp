//
//  HomeView.swift
//  FITSPIN app
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var completedStore: CompletedWorkoutsStore
    @EnvironmentObject private var favouritesStore: FavouritesStore
    
    @State private var showShuffle = false
    
    private var userName: String {
        if let displayName = authVM.user?.displayName, !displayName.isEmpty {
            return displayName
        }
        let email = authVM.user?.email ?? "User"
        return String(email.split(separator: "@").first ?? Substring(email))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fitspinBackground.ignoresSafeArea()
                
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.fitspinYellow)
                } else if let weather = vm.weather {
                    content(for: weather)
                } else if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.fitspinTangerine)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Color.clear
                        .onAppear {
                            Task { await vm.fetchWeather() }
                        }
                }
            }
        }
        .sheet(isPresented: $showShuffle) {
            ShuffleView()
                .environmentObject(authVM)
                .environmentObject(completedStore)
                .environmentObject(favouritesStore)
                .environmentObject(vm)
                .presentationDetents([.large])
        }
    }
    
    @ViewBuilder
    private func content(for weather: Weather) -> some View {
        VStack(spacing: 24) {
            HStack {
                Image("fitspintext")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                Spacer()
            }
            .padding(.leading, 30)
            Spacer()
            
            Text("HELLO, \(userName.uppercased())!")
                .font(.title2.bold())
                .foregroundColor(.fitspinBlue)
            
            Image(systemName: weather.condition.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.fitspinYellow)
            
            Text(String(format: "%.0fºC", weather.temperature))
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(.fitspinOffWhite)
            
            Text(weather.condition.description)
                .font(.subheadline)
                .foregroundColor(.fitspinYellow.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: {
                showShuffle = true
            }) {
                Text("LET'S GO!")
                    .frame(width: 200)
                    .padding()
                    .background(Color.fitspinTangerine)
                    .foregroundColor(.fitspinBackground)
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 100)
    }
}
