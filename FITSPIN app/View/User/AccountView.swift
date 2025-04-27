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
    @EnvironmentObject private var completedStore: CompletedWorkoutsStore
    @EnvironmentObject private var hydVM:  HydrationViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    
    @State private var showingChart = false
    @State private var showCalendar = false
    
    //IOS16 ShareLink functionality
    private let repoURL = URL(string: "https://github.com/aksiniapomi/FITSPINapp.git")!
    
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
                    //Top Bar
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
                    
                    // Profile Header
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
                            
                            // show age/height/weight line
                            Text("\(profileVM.age) yrs • \(profileVM.height) cm • \(profileVM.weight) kg")
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
                    
                    //Menu Items
                    VStack(spacing: 30) {
                        // Completed Workouts with calendar
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
                        
                        //User Details
                        NavigationLink {
                            
                            UserInfoView(
                                age: $profileVM.age,
                                height: $profileVM.height,
                                weight: $profileVM.weight,
                                fitnessLevel: $profileVM.fitnessLevel
                            )
                        } label: {
                            AccountRow(icon: "circle.grid.3x3.fill",
                                       label: "Fitness level and User details",
                                       value: profileVM.fitnessLevel,
                                       valueColor: .fitspinBlue)
                            
                        }
                            //Goals
                            NavigationLink {
                                FitnessGoalsView(selectedGoals: $profileVM.goals)
                            } label: {
                                
                                AccountRow(icon: "target",
                                           label: "Goals",
                                           value: profileVM.goals
                                    .map(\.rawValue)
                                    .sorted()
                                    .joined(separator: ", "),
                                           valueColor: .fitspinBlue)
                            }
                                //Hydration
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
                            
                            //refer action
                            //  ShareLink
                            ShareLink(
                                item: repoURL,
                                preview: SharePreview(
                                    "Check out FITSPIN on GitHub!",
                                    image: Image("FITSPIN_logo")
                                )
                            ) {
                                HStack {
                                    Image(systemName: "link")
                                    Text("Refer a friend")
                                        .bold()
                                    
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
    
    
    //Reusable Row
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
    
    // Preview
    struct AccountView_Previews: PreviewProvider {
        static var previews: some View {
            AccountView()
                .preferredColorScheme(.dark)
                .environmentObject(AuthViewModel())
                .environmentObject(HomeViewModel())
                .environmentObject(HydrationViewModel())
                .environmentObject(ProfileViewModel())
                .environmentObject(CompletedWorkoutsStore())
            
        }
    }
    

