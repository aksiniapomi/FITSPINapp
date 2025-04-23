//
//  Styles.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 21/04/2025.
//

import SwiftUI

//shared styles and palette for the app
extension Color {
    
    //FITSPIN Color Palette
    static let fitspinBackground = Color(hex: "232323")
    static let fitspinBlue       = Color(hex: "4B61DE")
    static let fitspinTangerine  = Color(hex: "FF9B71")
    static let fitspinYellow     = Color(hex: "F9DC5C")
    static let fitspinOffWhite   = Color(hex: "FDFFFC")
    static let fitspinInputBG    = Color(hex: "F5F5F5") //muted off-white
    
    //initialise from a 6- or 8-digit hex string
    init(hex: String) {
        let cleanedHex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        
        //add to the shared scanner
        var intValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&intValue)
        
        let a, r, g, b: UInt64
        switch cleanedHex.count {
        case 6:
            a = 255
            r = (intValue >> 16) & 0xFF
            g = (intValue >> 8)  & 0xFF
            b =  intValue        & 0xFF
        case 8:
            a = (intValue >> 24) & 0xFF
            r = (intValue >> 16) & 0xFF
            g = (intValue >> 8)  & 0xFF
            b =  intValue        & 0xFF
        default:
            // Fallback to white if the string is invalid
            a = 255; r = 255; g = 255; b = 255
        }
        
        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Common button styling
//Filled tangerine button
struct FPOutlineTangerineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.fitspinTangerine)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.fitspinTangerine, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

//Full-width yellow button
struct FPButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Color.fitspinYellow
                    .opacity(configuration.isPressed ? 0.7 : 1.0)
            )
            .foregroundColor(.fitspinBackground)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
//Outline blue button
struct FPOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.fitspinBlue)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.fitspinBlue, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

//Filled tangerine button
struct FPFilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                Color.fitspinTangerine
                    .opacity(configuration.isPressed ? 0.7 : 1.0)
            )
            .foregroundColor(.fitspinInputBG)
            .cornerRadius(8)
    }
}

