//
//  SignInVew.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 21/04/2025.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var isLoading = false
}

struct SignInView: View {
    
    @EnvironmentObject private var authVM: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            VStack {
                
                Spacer().frame(height:230)
                
                Image("FITSPIN_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Spacer().frame(height:40)
                
                HStack(spacing: 16) {
                    NavigationLink {
                        RegisterView()
                            .environmentObject(authVM)
                    } label: {
                        Text("Sign Up")
                    }
                    .buttonStyle(FPOutlineTangerineButtonStyle())
                    .frame(maxWidth: .infinity)
                    
                    NavigationLink {
                        LoginView()
                            .environmentObject(authVM)
                    } label: {
                        Text("Log In")
                    }
                    .buttonStyle(FPOutlineButtonStyle())
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: 300)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
