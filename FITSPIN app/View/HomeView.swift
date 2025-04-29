//
//  HomeView.swift
//  FITSPIN app
//
//  Updated by ChatGPT on 28/04/2025 to include navigation to ShuffleView.

import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @EnvironmentObject private var authVM: AuthViewModel
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
            .navigationDestination(isPresented: $showShuffle) {
                ShuffleView()
                    .environmentObject(authVM)
                    .environmentObject(CompletedWorkoutsStore())
                    .environmentObject(FavouritesStore())
            }
        }
    }

    @ViewBuilder
    private func content(for w: Weather) -> some View {
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
                .font(.title2).bold()
                .foregroundColor(.fitspinBlue)

            Image(systemName: w.condition.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.fitspinYellow)

            Text(String(format: "%.0fºC", w.temperature))
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(.fitspinOffWhite)

            Text(w.condition.description)
                .font(.subheadline)
                .foregroundColor(.fitspinYellow.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            NavigationLink(
                destination: ShuffleView()
                    .environmentObject(authVM)
                    .environmentObject(CompletedWorkoutsStore())
                    .environmentObject(FavouritesStore())
            ) {
                Text("LET’S GO!")
                    .frame(width: 200)
                    .padding()
                    .background(Color.fitspinTangerine)
                    .foregroundColor(.fitspinBackground)
                    .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle()) // Optional to preserve your custom look

            Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 100)

    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
