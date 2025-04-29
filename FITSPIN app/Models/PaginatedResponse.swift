//
//  PaginatedResponse.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 25/04/2025.
//

import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [T]
}
