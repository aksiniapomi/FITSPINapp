//
//  EquipmentIcon.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 26/04/2025.
//

import SwiftUI

struct EquipmentIcon: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(name)
                .font(.caption2)
                .foregroundColor(.white)
                .frame(width: 70)
                .lineLimit(1)
        }
    }
}
