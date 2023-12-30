//
//  BoardSquare.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import SwiftUI

struct BoardSquare: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        path.addRect(rect)
        
        return path
    }
}

#Preview {
    BoardSquare()
}
