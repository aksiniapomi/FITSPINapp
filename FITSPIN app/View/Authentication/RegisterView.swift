//
//  RegisterView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 21/04/2025.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject private var authVM: AuthViewModel
    
    @State private var fullName = ""
    @State private var email    = ""
    @State private var password = ""
    
    @State private var showValidationAlert = false
    
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
                        TextField("Full name", text: $fullName)
                            .padding()
                            .foregroundColor(.fitspinOffWhite)
                            .disableAutocorrection(true)
                            .background(Color.fitspinFieldBlue)
                            .cornerRadius(8)
                        
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress) //for ios autocomlete
                            .foregroundColor(.fitspinOffWhite)
                            .padding()
                            .background(Color.fitspinFieldBlue)
                            .cornerRadius(8)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .foregroundColor(.fitspinOffWhite)
                            .background(Color.fitspinFieldBlue)
                            .cornerRadius(8)
                        
                    }
                    .padding(.horizontal)
                    
                    //Firebase errors
                    if let err = authVM.authError {
                        Text(err)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    //Sign Up Button
                    Button("Sign Up") {
                        //Validation
                        guard !fullName.isEmpty,
                              !email.isEmpty,
                              !password.isEmpty
                        else {
                            showValidationAlert = true
                            return
                        }
                        Task {
                            await authVM.signUp(
                                fullName: fullName,
                                email: email,
                                password: password
                            )
                        }
                    }
                    .buttonStyle(FPButtonStyle())
                    .alert(
                        "Please complete all fields to sign up",
                        isPresented: $showValidationAlert
                    ) {
                        Button("OK", role: .cancel) { }
                    }
                    
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(.fitspinOffWhite.opacity(0.7))
                        NavigationLink("Log In") {
                            LoginView()    //login screen
                                .environmentObject(authVM)
                        }
                        .font(.subheadline).bold()
                        .foregroundColor(.fitspinYellow)
                    }
                    .padding(.top, 8)
                    
                    
                    //Swift divider is vertical by default so using a thin rectangle
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
                            //Google action
                        }
                        SocialSignInButton(
                            text: "Continue with Apple",
                            icon: Image("applelogo")
                        ) {
                            //Apple action
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
        .navigationBarHidden(true)
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
                .environmentObject(AuthViewModel())
            //  .preferredColorScheme(.dark)
        }
    }
}
