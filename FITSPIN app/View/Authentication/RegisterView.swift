//
//  RegisterView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 21/04/2025.
//

import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email    = ""
    @Published var password = ""
    @Published var isLoading = false
    
    //validation / registration logic here
}

struct RegisterView: View {
    @StateObject private var vm = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            //ensure the form scrolls on smaller screens
            ScrollView {
                VStack(spacing: 30) {
                    
                    Image("FITSPIN_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .padding(.top, 40)
                    
                    VStack(spacing: 8) {
                        Text("Join our fitness community!")
                            .font(.headline)
                            .foregroundColor(.fitspinYellow)
                        Text("Enter your details to sign up for this app")
                            .font(.subheadline)
                            .foregroundColor(.fitspinTangerine)
                    }
                    
                    //input fields
                    VStack(spacing: 16) {
                        TextField("Full name", text: $vm.fullName)
                            .padding()
                            .background(Color.fitspinOffWhite)
                            .cornerRadius(8)
                        
                        TextField("Email", text: $vm.email)
                            .textContentType(.emailAddress) //for ios autocomlete
                            .padding()
                            .background(Color.fitspinOffWhite)
                            .cornerRadius(8)
                        
                        SecureField("Password", text: $vm.password)
                            .padding()
                            .background(Color.fitspinOffWhite)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    //sign up button
                    Button("Sign up") {
                        // vm.register()
                    }
                    .buttonStyle(FPButtonStyle())   // full-width yellow
                    .disabled(vm.fullName.isEmpty || vm.email.isEmpty || vm.password.isEmpty)
                    
                    //Swift divider is vertical by default so use an thin rectangle
                    HStack(alignment: .center) {
                        Rectangle()
                            .fill(Color.fitspinOffWhite)
                            .frame(height: 1)
                        Text("or")
                            .font(.footnote)
                            .foregroundColor(.fitspinOffWhite)
                            .padding(.horizontal, 8)
                        Rectangle()
                            .fill(Color.fitspinOffWhite)
                            .frame(height: 1)
                    }
                    .padding(.horizontal)
                    
                    
                    VStack(spacing: 16) {
                        SocialSignInButton(
                            text: "Continue with Google",
                            icon: Image("googlelogo")
                        ) {
                            // Google action
                        }
                        SocialSignInButton(
                            text: "Continue with Apple",
                            icon: Image("applelogo")
                        ) {
                            // Apple action
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    Text("By clicking continue, you agree to our Terms of Service and Privacy Policy")
                        .font(.caption2)
                        .foregroundColor(.fitspinOffWhite.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
        }
        // .navigationTitle("Register")
        //.navigationBarTitleDisplayMode(.inline)
    }
}

//social sign buttons
private struct SocialSignInButton: View {
    let text: String
    let icon: Image
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(text)
                    .font(.subheadline)
                    .bold()
            }
            .foregroundColor(.fitspinBackground)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.fitspinOffWhite)
            .cornerRadius(8)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterView()
                .preferredColorScheme(.dark)
        }
    }
}
