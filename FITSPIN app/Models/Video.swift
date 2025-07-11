//
//  Video.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 25/04/2025.
//

import Foundation

struct Video: Codable, Identifiable {
    let id: Int
    let exercise: Int
    let video: URL
}
