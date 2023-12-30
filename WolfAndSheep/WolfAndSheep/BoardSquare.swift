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
        Rectangle()
            .fill(color)
            .border(Color.black, width: 1)
    }
}



#Preview {
    BoardSquare(color: Color.orange)
}
