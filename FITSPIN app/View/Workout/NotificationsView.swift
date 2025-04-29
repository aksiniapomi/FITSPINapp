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
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            if notificationsVM.items.isEmpty {
                VStack {
                    Spacer()
                    Text("No notifications yet")
                        .font(.body)
                        .foregroundColor(.fitspinOffWhite.opacity(0.7))
                    Spacer()
                }
            } else {
                List {
                    ForEach(notificationsVM.items) { note in
                        NotificationCard(item: note)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        notificationsVM.delete(note)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
            }
        }
        
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
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: item.date)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: item.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: item.type.iconName)
                    .foregroundColor(.fitspinYellow)
                Text(item.type.title)
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
            
            Text(dateString)
                .font(.caption2)
                .foregroundColor(.fitspinOffWhite.opacity(0.6))
        }
        .padding()
        .background(Color.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
