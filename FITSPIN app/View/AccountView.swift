//
//  AccountView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack {
            Text("Account / Profile")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)

            Text("This is where users can manage their profile and settings.")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
        .fullScreenBackground()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}


