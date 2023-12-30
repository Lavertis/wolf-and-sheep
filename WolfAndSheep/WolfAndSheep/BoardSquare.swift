//
//  BoardSquare.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import SwiftUI

struct BoardSquare: View {
    var color: Color
    var checker: BoardModel.Checker?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(color)
                    .border(Color.black, width: 1)
                
                if let checker = checker {
                    Circle()
                        .fill(checker.type == .wolf ? Color.yellow : Color.green)
                        .stroke(
                            checker.isSelected ? Color.red : Color.clear,
                            lineWidth: 5
                        )
                        .frame(
                            width: geometry.size.width * 0.8,
                            height: geometry.size.height * 0.8
                        )
                }
            }
        }
    }
}



#Preview {
    BoardSquare(
        color: Color.orange,
        checker: BoardModel.Checker(row: 0, column: 0, type: .wolf)
    )
}
