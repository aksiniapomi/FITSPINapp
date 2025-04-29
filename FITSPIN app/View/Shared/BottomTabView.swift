//
//  BottomTabView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct BottomTabView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var hydVM: HydrationViewModel
    @EnvironmentObject var notificationsVM: NotificationsViewModel
    @EnvironmentObject var filterVM: FilterViewModel
    @EnvironmentObject var exerciseListVM: ExerciseListViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(homeVM)
                .fullScreenBackground()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            TopTabsScreen()
                .environmentObject(filterVM)
                .environmentObject(exerciseListVM)
                .tabItem {
                    Image(systemName: "dumbbell")
                    Text("Workouts")
                }
            
            HydrationView()
                .environmentObject(homeVM)
                .environmentObject(hydVM)
                .environmentObject(notificationsVM)
                .tabItem {
                    Image(systemName: "drop")
                    Text("Hydration")
                }
            
            AccountView()
                .environmentObject(profileVM)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .background(Color.fitspinBackground)
        .accentColor(.fitspinBlue)
    }
}

struct BottomTabView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabView()
            .environmentObject(HomeViewModel())
            .environmentObject(HydrationViewModel())
            .environmentObject(NotificationsViewModel.shared)
            .environmentObject(ProfileViewModel())
            .environmentObject(FilterViewModel())
            .environmentObject(ExerciseListViewModel())
            .preferredColorScheme(.dark)
            .previewDisplayName("Full App Tabs")
    }
}
