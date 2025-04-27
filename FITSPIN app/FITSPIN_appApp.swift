//  FITSPIN_appApp.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 04/04/2025.

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        return true
    }
}

@main
struct FITSPIN_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Shared ViewModels / Stores
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var workoutStore = WorkoutStore()
    @StateObject private var favouritesStore = FavouritesStore()
    @StateObject private var completedStore = CompletedWorkoutsStore()


    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.user == nil {
                    NavigationStack {
                        SignInView()
                    }
                } else {
                    BottomTabView()
                }
            }
            .environmentObject(authVM)
            .environmentObject(workoutStore)
            .environmentObject(favouritesStore)
            .environmentObject(completedStore)

            .preferredColorScheme(.dark)
        }
    }
}

