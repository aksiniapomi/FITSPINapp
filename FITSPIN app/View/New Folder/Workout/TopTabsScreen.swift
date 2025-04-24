//
//  TopTabsScreen.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI

struct TopTabsScreen: View {
    @State private var selectedTopTab: TopTab = .shuffle

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(selectedTab: $selectedTopTab)

            ZStack {
                switch selectedTopTab {
                case .shuffle:
                    ShuffleView()
                case .filter:
                 FilterView()
                case .favourites:
                    FavouritesView()
                case .notifications:
                    NotificationsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.fitspinBackground)
        }
    }
}
struct TopTabsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TopTabsScreen().preferredColorScheme(.dark)
        .previewDisplayName("Workouts Screen")
    }
}
