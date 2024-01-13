//
//  ShadowWithStrength.swift
//  WolfAndSheep
//
//  Created by Rafał on 01/01/2024.
//

import SwiftUI

struct ShadowWithStrength: ViewModifier {
    var color: Color
    var strength: Int

    func body(content: Content) -> some View {
        if strength == 0 {
            content
        }
        ForEach(0..<strength, id: \.self) { _ in
            content.shadow(color: color, radius: 5)
        }
    }
}

extension View {
    func shadowWithStrength(color: Color, strength: Int) -> some View {
        self.modifier(ShadowWithStrength(color: color, strength: strength))
    }
}
