//
//  TransformIntoButton.swift
//  WolfAndSheep
//
//  Created by Rafał on 13/01/2024.
//

import SwiftUI


struct GameButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .background(Color.orange)
            .cornerRadius(10)
    }
}

extension View {
    func transformIntoButton() -> some View {
        self.modifier(GameButton())
    }
}
