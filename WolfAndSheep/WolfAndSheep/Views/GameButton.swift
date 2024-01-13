//
//  GameButton.swift
//  WolfAndSheep
//
//  Created by Rafał on 13/01/2024.
//

import SwiftUI

struct GameButton: View {
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
    }
    }
}

#Preview {
    GameButton()
}
