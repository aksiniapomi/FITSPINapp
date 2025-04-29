//
//  CaseInsensitive.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 29/04/2025.
//

import SwiftUI
import UIKit    // for UIImage

extension Image {
  //Try exact, then lowercase, uppercase, then capitalised image variants
  init(caseInsensitive name: String) {
    let candidates = [
      name,
      name.lowercased(),
      name.uppercased(),
      name.capitalized
    ]
    if let found = candidates.first(where: { UIImage(named: $0) != nil }) {
      self = Image(found)
    } else {
      self = Image(name)
    }
  }
}
