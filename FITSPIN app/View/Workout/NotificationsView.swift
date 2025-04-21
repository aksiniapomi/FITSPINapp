//
//  NotificationsView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI

struct NotificationsView: View {
    let notifications: [NotificationItem] = [
        NotificationItem(message: "We saw that you were smashing your workouts. But did you know stretching is as important as your workout. Here are some stretches you may like."),
        NotificationItem(message: "We just updated our terms and conditions. Why don’t you check the article to see how your personal data will now be handled even more securely."),
        NotificationItem(message: "We wanted to congratulate you as the Fitspin team for achieving your daily water intake goals. You are smashing it!")
    ]

    var body: some View {
        VStack(spacing: 0) {
//            TopBarView(selectedTab: .constant(.notifications))

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(notifications) { notification in
                        NotificationCard(notification: notification)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.fitspinBackground)
        .ignoresSafeArea()
    }
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let message: String
}

struct NotificationCard: View {
    let notification: NotificationItem

    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            // Red dot indicator
            Circle()
                .fill(Color.red)
                .frame(width: 10, height: 10)
                .padding(.top, 6)

            // Logo and Message
            HStack(alignment: .top, spacing: 2) {
                Image("FitsipinNoSlogan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)

                Text(notification.message)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color.fitspinTangerine)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 40)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
