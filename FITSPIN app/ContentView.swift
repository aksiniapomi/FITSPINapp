//
//  ContentView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 04/04/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "clock")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, FITSPIN!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
