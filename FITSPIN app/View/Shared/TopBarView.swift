//
//  TopBarView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct TopBarView: View {
    @Binding var selectedTab: TopTab
    
    var body: some View {
        VStack(alignment: .center, spacing: -20) {
            
            HStack {
                Image("fitspintext")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                Spacer()
            }
            .padding(.top, -30)
            
            // Tab Items
            HStack(spacing: 55) {
                topTabButton(tab: .shuffle, icon: "calendar", label: "Today")
                topTabButton(tab: .filter, icon: "line.3.horizontal.decrease.circle", label: "Filter")
                topTabButton(tab: .favourites, icon: "heart.fill", label: "Favourites")
                topTabButton(tab: .notifications, icon: "bell", label: "Notifications", badge: "")
            }
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.fitspinBackground)
    }
    
    private func topTabButton(tab: TopTab, icon: String, label: String, badge: String? = nil) -> some View {
        VStack(spacing: 4) {
            Button(action: {
                selectedTab = tab
            }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(selectedTab == tab ? .fitspinYellow : .fitspinOffWhite)
                    
                    if let badge = badge {
                        Text(badge)
                            .font(.caption2)
                            .padding(4)
                            .background(Color.red)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .offset(x: 10, y: -10)
                    }
                }
            }
            
            Text(label)
                .font(.caption2)
                .foregroundColor(selectedTab == tab ? .fitspinYellow : .fitspinOffWhite)
        }
    }
}


struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView(selectedTab: .constant(.shuffle))
            .previewLayout(.sizeThatFits)
            .background(Color.fitspinBackground)
    }
}

