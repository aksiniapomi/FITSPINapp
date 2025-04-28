//
//  FITSPIN_appApp.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 04/04/2025.
//

import SwiftUI
import FirebaseCore

//Firebase Delegate Setup
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
    //  Firebase Bootstrap
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Global ViewModels / Stores
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var hydVM = HydrationViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var notificationsVM = NotificationsViewModel()
    
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
            .environmentObject(homeVM)
            .environmentObject(hydVM)
            .environmentObject(profileVM)
            .environmentObject(notificationsVM)
            .environmentObject(workoutStore)
            .environmentObject(favouritesStore)
            .environmentObject(completedStore)

            .preferredColorScheme(.dark)
        }
    }
}
