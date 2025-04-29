//
//  TopTabsScreen.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct TopTabsScreen: View {
    @State private var selectedTopTab: TopTab = .shuffle
    
    @EnvironmentObject var filterVM: FilterViewModel
    @EnvironmentObject var exerciseListVM: ExerciseListViewModel
    @EnvironmentObject var notificationsVM: NotificationsViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(selectedTab: $selectedTopTab)
            
            ZStack {
                switch selectedTopTab {
                case .shuffle:
                    ShuffleView()
                    
                case .filter:
                    FilterView()
                        .environmentObject(filterVM)
                    
                case .favourites:
                    FavouritesView()
                        .environmentObject(exerciseListVM)
                    
                case .notifications:
                    NotificationsView()
                        .environmentObject(notificationsVM)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.fitspinBackground)
        }
    }
}

struct TopTabsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TopTabsScreen()
            .environmentObject(FilterViewModel())
            .environmentObject(ExerciseListViewModel())
            .environmentObject(NotificationsViewModel.shared)
    }
}

