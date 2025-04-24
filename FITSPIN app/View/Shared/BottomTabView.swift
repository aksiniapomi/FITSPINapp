//
//  BottomTabView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct BottomTabView: View {
    
    var body: some View {
        TabView {
          HomeView()
              .fullScreenBackground()
              .tabItem {
                   Image(systemName: "house")
                   Text("Home")
              }

            TopTabsScreen()
                .tabItem {
                    Image(systemName: "map")
                    Text("Workouts")
                }

            HydrationView()
                .tabItem {
                    Image(systemName: "drop")
                    Text("Hydration")
                }

            AccountView()
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

            .preferredColorScheme(.dark)
                 .previewDisplayName("Full App Tabs")
        
    }
}

        

