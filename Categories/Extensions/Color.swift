//
//  Color.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

/// Create theme to be used throughout app
struct ColorTheme {
    let accent = Color("AccentColor")
    let inputRed = Color("inputRed")
    let markingBlue = Color("markingBlue")
    let background = Color("background")
}
