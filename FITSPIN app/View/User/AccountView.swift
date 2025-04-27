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
    @EnvironmentObject private var hydVM:  HydrationViewModel
    
    @State private var showingChart = false
    
    //onboarding state
   // @State private var age: Int = 25
 //   @State private var height: Int = 170
  //  @State private var weight: Int = 70
   // @State private var fitnessLevel: String = "Beginner"
   // @State private var selectedGoals: Set<FitnessGoalsView.Goal> = []
    
    @EnvironmentObject private var profileVM: ProfileViewModel
    
    private var displayName: String {
        authVM.user?.displayName ?? "Guest"
    }
    
    private var emailAddress: String {
        authVM.user?.email ?? ""
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fitspinBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    //top bar
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
                    
                    HStack(spacing: 12) {
                        Image("profile_picture") //placeholder image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.fitspinYellow, lineWidth: 2)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(displayName)
                                .font(.headline)
                                .foregroundColor(.fitspinYellow)
                            
                            Text(emailAddress)
                                .font(.subheadline)
                                .foregroundColor(.fitspinYellow)
                            
                            // show age/height/weight line
                            Text("\(profileVM.age) yrs • \(profileVM.height) cm • \(profileVM.weight) kg")
                                .font(.caption).foregroundColor(.fitspinYellow.opacity(0.8))
                            
                            HStack(spacing: 4) {
                                Image(systemName: "mappin.and.ellipse")
                                Text(homeVM.city ?? "Unknown city") //take the same location CCLocation pulled from weather call and feed into Apple's reverse-geocoder. Reverse gecoding will give CLPlacemark that contains locality as well (city)
                            }
                            .font(.subheadline)
                            .foregroundColor(.fitspinYellow)
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 32)
                    .padding(.trailing, 20)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    //menu rows
                    VStack(spacing: 30) {
                        AccountRow(
                            icon: "checkmark.square",
                            label: "Completed Workouts",
                            value: "4",
                            valueColor: .fitspinBlue
                        )
                        
                        // Level from UserInfoView
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
                        
                        // Goals from FitnessGoalsView
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
                        
                        /*  AccountRow(
                         icon: "circle.grid.3x3.fill",
                         label: "Level",
                         value: "Beginner",
                         valueColor: .fitspinBlue
                         )
                         AccountRow(
                         icon: "target",
                         label: "Goals",
                         value: "Muscle Gain",
                         valueColor: .fitspinBlue
                         )
                         
                         */
                        AccountRow(icon: "drop",
                                   label: "Hydration",
                                   value: String(format: "%.1f L", hydVM.todayIntake),
                                   trailingIcon: "calendar")
                        .onTapGesture { showingChart = true }
                        
                        AccountRow(
                            icon: "bell.badge.fill",
                            label: "Notifications",
                            value: "On",
                            valueColor: .fitspinBlue
                        )
                        AccountRow(
                            icon: "bubble.left",
                            label: "Feedback",
                            value: nil
                        )
                        
                        //logout row
                        AccountRow(icon: "arrow.backward.circle",
                                   label: "Log Out",
                                   value: nil)
                        .onTapGesture {
                            // handle sign‑out logic
                            authVM.signOut()
                        }
                    }
                    .padding(.leading, 32)
                    .padding(.trailing, 20)
                    .padding(.top, 2)
                    
                    Spacer(minLength: 50)
                    
                    Button { /* refer action */ } label: {
                        HStack {
                            Image(systemName: "network")
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
            // Present the chart when needed
            .sheet(isPresented: $showingChart) {
                IntakeChartView()
                    .environmentObject(hydVM)
            }
        }
    }
}

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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel())
            .environmentObject(HomeViewModel())
            .environmentObject(HydrationViewModel())
            .environmentObject(ProfileViewModel())
    }
}
