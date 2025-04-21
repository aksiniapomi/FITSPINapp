//
//  LogInView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 21/04/2025.
//

import SwiftUI

/// ViewModel stub for future login logic
class LoginViewModel: ObservableObject {
    @Published var email    = ""
    @Published var password = ""
    @Published var isLoading = false
    
    func login() {
        // implement your Firebase auth call here
    }
}

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.fitspinBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
         
                    Image("fitspin_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .padding(.top, 40)
                    
               
                    VStack(spacing: 8) {
                        Text("Welcome Back!")
                            .font(.headline)
                            .foregroundColor(.fitspinYellow)
                        Text("Log in to continue")
                            .font(.subheadline)
                            .foregroundColor(.fitspinTangerine)
                    }
                    
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $vm.email)
                            .textContentType(.emailAddress)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color.fitspinOffWhite)
                            .cornerRadius(8)
                        
                        SecureField("Password", text: $vm.password)
                            .padding()
                            .background(Color.fitspinOffWhite)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
           
                    Button {
                        vm.login()
                    } label: {
                        Text(vm.isLoading ? "Logging In…" : "Log In")
                    }
                    .buttonStyle(FPButtonStyle())
                    .disabled(vm.email.isEmpty || vm.password.isEmpty || vm.isLoading)
                    
            
                    Button("Forgot Password?") {
                        // navigate to PasswordResetView
                    }
                    .foregroundColor(.fitspinOffWhite)
                    .font(.footnote)
                    
             
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.fitspinOffWhite.opacity(0.8))
                            .font(.footnote)
                        Button("Sign Up") {
                            // navigate back to SignInView or RegisterView
                        }
                        .foregroundColor(.fitspinTangerine)
                        .font(.footnote).bold()
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
                .preferredColorScheme(.dark)
        }
    }
}
