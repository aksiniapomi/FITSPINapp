//
//  ViewModifiers.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 21/04/2025.
//
import SwiftUI

extension View {
    func fullScreenBackground(_ color: Color = .fitspinBackground) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
            .ignoresSafeArea()
    }
}

