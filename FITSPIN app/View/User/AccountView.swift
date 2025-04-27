//
//  AccountView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var homeVM: HomeViewModel
    @EnvironmentObject private var hydVM: HydrationViewModel
    @EnvironmentObject private var completedStore: CompletedWorkoutsStore

    @State private var showCalendar = false
    @State private var showingChart = false

    @State private var age: Int = 25
    @State private var height: Int = 170
    @State private var weight: Int = 70
    @State private var fitnessLevel: String = "Beginner"
    @State private var selectedGoals: Set<FitnessGoalsView.Goal> = []

    private var completedWorkoutsCount: Int {
        completedStore.completed.count
    }

    private var displayName: String {
        authVM.user?.displayName ?? "Guest"
    }

    private var emailAddress: String {
        authVM.user?.email ?? ""
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.fitspinBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: - Top Bar
                    HStack {
                        Button {
                            // open side menu
                        } label: {
                            Image(systemName: "line.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.fitspinOffWhite)
                        }

                        Spacer()

                        Text("Account")
                            .font(.headline)
                            .foregroundColor(.fitspinOffWhite)

                        Spacer()

                        Image(systemName: "line.horizontal.3")
                            .opacity(0)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    Spacer()

                    // MARK: - Profile Header
                    HStack(spacing: 12) {
                        Image("profile_picture")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.fitspinYellow, lineWidth: 2))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(displayName)
                                .font(.headline)
                                .foregroundColor(.fitspinYellow)

                            Text(emailAddress)
                                .font(.subheadline)
                                .foregroundColor(.fitspinYellow)

                            Text("\(age) yrs • \(height) cm • \(weight) kg")
                                .font(.caption)
                                .foregroundColor(.fitspinYellow.opacity(0.8))

                            HStack(spacing: 4) {
                                Image(systemName: "mappin.and.ellipse")
                                Text(homeVM.city ?? "Unknown city")
                            }
                            .font(.subheadline)
                            .foregroundColor(.fitspinYellow)
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    Spacer()

                    // MARK: - Menu Items
                    VStack(spacing: 30) {
                        // ✅ Completed Workouts with calendar
                        HStack {
                            NavigationLink {
                                CompletedWorkoutsView()
                            } label: {
                                AccountRow(
                                    icon: "checkmark.square",
                                    label: "Completed Workouts",
                                    value: "\(completedWorkoutsCount)",
                                    valueColor: .fitspinBlue
                                )
                            }

                            Spacer()

                            Button {
                                showCalendar = true
                            } label: {
                                Image(systemName: "calendar")
                                    .foregroundColor(.fitspinYellow)
                            }
                        }

                        // 🧍 User Details
                        NavigationLink {
                            UserInfoView(age: $age, height: $height, weight: $weight, fitnessLevel: $fitnessLevel)
                        } label: {
                            AccountRow(
                                icon: "circle.grid.3x3.fill",
                                label: "Fitness level and User details",
                                value: fitnessLevel,
                                valueColor: .fitspinBlue
                            )
                        }

                        // 🎯 Goals
                        NavigationLink {
                            FitnessGoalsView(selectedGoals: $selectedGoals)
                        } label: {
                            AccountRow(
                                icon: "target",
                                label: "Goals",
                                value: selectedGoals.map(\.rawValue).sorted().joined(separator: ", "),
                                valueColor: .fitspinBlue
                            )
                        }

                        // 💧 Hydration
                        AccountRow(
                            icon: "drop",
                            label: "Hydration",
                            value: String(format: "%.1f L", hydVM.todayIntake),
                            trailingIcon: "calendar"
                        )
                        .onTapGesture { showingChart = true }

                        // 🔔 Notifications
                        AccountRow(
                            icon: "bell.badge.fill",
                            label: "Notifications",
                            value: "On",
                            valueColor: .fitspinBlue
                        )

                        // 💬 Feedback
                        AccountRow(
                            icon: "bubble.left",
                            label: "Feedback",
                            value: nil
                        )

                        // 🚪 Log Out
                        AccountRow(
                            icon: "arrow.backward.circle",
                            label: "Log Out",
                            value: nil
                        )
                        .onTapGesture {
                            authVM.signOut()
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 50)

                    // 🌍 Refer a Friend
                    Button {
                        // refer logic
                    } label: {
                        HStack {
                            Image(systemName: "network")
                            Text("Refer a friend").bold()
                        }
                        .foregroundColor(.fitspinYellow)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 12)
                    .background(Color.fitspinBackground)
                }
            }
            .sheet(isPresented: $showingChart) {
                IntakeChartView().environmentObject(hydVM)
            }
            .sheet(isPresented: $showCalendar) {
                CompletedWorkoutCalendarView()
            }
        }
    }
}

// MARK: - Reusable Row
fileprivate struct AccountRow: View {
    let icon: String
    let label: String
    let value: String?
    var valueColor: Color = .fitspinBlue
    var trailingIcon: String? = nil

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(.fitspinYellow)

            Text(label)
                .foregroundColor(.fitspinYellow)

            Spacer()

            if let val = value {
                Text(val)
                    .foregroundColor(valueColor)
            }

            if let ti = trailingIcon {
                Image(systemName: ti)
                    .foregroundColor(valueColor)
            }
        }
        .font(.subheadline)
    }
}

// MARK: - Preview
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel())
            .environmentObject(HomeViewModel())
            .environmentObject(HydrationViewModel())
            .environmentObject(CompletedWorkoutsStore())
    }
}
