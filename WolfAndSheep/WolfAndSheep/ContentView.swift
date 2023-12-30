//
//  ContentView.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import SwiftUI



struct ContentView: View {
    @ObservedObject var viewModel : BoardViewModel
    
    let boardPadding: CGFloat = 10
    let columns = Array(repeating: GridItem(), count: 8)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(viewModel.squares) { square in
                let color = (square.row + square.column).isMultiple(of: 2) ? Color.orange : Color.black
                BoardSquare()
                    .fill(color)
                    .frame(
                        width: squareSize(),
                        height: squareSize()
                    ).clipped()
            }
        }
        .padding(boardPadding)
        .cornerRadius(5)
    }
    
    func squareSize() -> CGFloat {
        let width = UIScreen.main.bounds.width
        return width / 8
    }
}

#Preview {
    ContentView(viewModel: BoardViewModel())
}
