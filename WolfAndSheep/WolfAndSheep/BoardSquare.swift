//
//  BoardSquare.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import SwiftUI

struct BoardSquare: View {
    var color: Color

    var body: some View {
        Rectangle().fill(color)
    }
}



#Preview {
    BoardSquare(color: Color.orange)
}
