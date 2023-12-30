//
//  BoardChecker.swift
//  WolfAndSheep
//
//  Created by Rafał on 30/12/2023.
//

import SwiftUI

struct BoardChecker: View {
    var color: Color
    var isHighlighted: Bool
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(color)
                .stroke(
                    isHighlighted ? Color.red : Color.clear,
                    lineWidth: 5
                )
                .frame(
                    width: geometry.size.width * 0.8,
                    height: geometry.size.height * 0.8
                )
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

#Preview {
    BoardChecker(
        color: .green,
        isHighlighted: true
    )
}
