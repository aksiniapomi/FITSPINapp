//
//  AccountView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject private var authVM: AuthViewModel
    
    var body: some View {
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
                    Image("profile_picture")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.fitspinYellow, lineWidth: 2)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Xenia Pominova")
                            .font(.headline)
                            .foregroundColor(.fitspinYellow)
                        
                        Text("xeniapominova@domain.com")
                            .font(.subheadline)
                            .foregroundColor(.fitspinYellow)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.and.ellipse")
                            Text("London")
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
                
                VStack(spacing: 30) {
                    AccountRow(
                        icon: "checkmark.square",
                        label: "Completed Workouts",
                        value: "4",
                        valueColor: .fitspinBlue
                    )
                    AccountRow(
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
                    AccountRow(
                        icon: "drop",
                        label: "Hydration",
                        value: "On",
                        valueColor: .fitspinBlue,
                        trailingIcon: "calendar"
                    )
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
    }
}
