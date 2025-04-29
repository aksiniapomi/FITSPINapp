//
//  NotificationsView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI

struct NotificationsView: View {
    
    @EnvironmentObject private var notificationsVM: NotificationsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            //top bar component
            // TopBarView(selectedTab: .constant(.notifications))
            
            if notificationsVM.items.isEmpty {
                Spacer()
                Text("No notifications yet")
                    .foregroundColor(.fitspinOffWhite.opacity(0.7))
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(notificationsVM.items) { note in
                            NotificationCard(item: note)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color.fitspinBackground.ignoresSafeArea())
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Account")
                    }
                    .foregroundColor(.fitspinYellow)
                }
            }
        }
    }
}

struct NotificationCard: View {
    let item: NotificationItem
    
    // Date formatter for subtitle
    private var timeString: String {
        let fmt = DateFormatter()
        fmt.timeStyle = .short
        fmt.dateStyle = .none
        return fmt.string(from: item.date)
    }
    
    // full date (e.g. “Apr 27, 2025”)
    private var dateString: String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .none
        return fmt.string(from: item.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: item.type.iconName)
                    .foregroundColor(.fitspinYellow)
                Text(item.type.rawValue)
                    .font(.headline)
                    .foregroundColor(.fitspinYellow)
                Spacer()
                Text(timeString)
                    .font(.caption2)
                    .foregroundColor(.fitspinOffWhite.opacity(0.7))
            }
            
            Text(item.message)
                .font(.subheadline)
                .foregroundColor(.fitspinOffWhite)
            
            //date
            Text(dateString)
                .font(.caption2)
                .foregroundColor(.fitspinOffWhite.opacity(0.6))
        }
        
        
        .padding()
        .background(Color.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
            .environmentObject(NotificationsViewModel())
            .preferredColorScheme(.dark)
    }
}
