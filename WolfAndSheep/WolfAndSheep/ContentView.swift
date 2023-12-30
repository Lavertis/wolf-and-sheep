//
//  ContentView.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import SwiftUI



struct ContentView: View {
    @ObservedObject var viewModel: BoardViewModel
    @State private var dragOffset = CGSize.zero
    var columns: [GridItem] { Array(repeating: GridItem(), count: viewModel.matrixSize) }
    
    func squareAtLocation(boardSize: CGFloat, location: CGPoint) -> BoardModel.Square? {
        let squareSize = boardSize / CGFloat(viewModel.matrixSize)
        let column = Int(location.x / squareSize)
        let row = Int(location.y / squareSize)
        return viewModel.squareAt(row: row, column: column)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let squareSize = geometry.size.width / CGFloat(viewModel.matrixSize) + 1
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.squares) { square in
                    let checker = viewModel.checker(at: square)
                    BoardSquare(color: viewModel.getSquareColor(square))
                        .frame(width: squareSize, height: squareSize)
                        .overlay {
                            if let checker = viewModel.checker(at: square) {
                                BoardChecker(
                                    color: checker.type == .wolf ? Color.yellow : Color.green,
                                    isHighlighted: viewModel.selectedChecker == checker
                                )
                                .offset(checker == viewModel.selectedChecker ? dragOffset : .zero)
                            }
                        }
                        .zIndex(checker == viewModel.selectedChecker ? 1 : 0)
                        .gesture(DragGesture(coordinateSpace: .named("Board"))
                            .onChanged({ gesture in
                                if let checker = viewModel.checker(at: square) {
                                    if viewModel.selectedChecker == nil {
                                        viewModel.select(checker)
                                    }
                                    dragOffset = gesture.translation
                                }
                            })
                            .onEnded({ gesture in
                                dragOffset = .zero
                                viewModel.select(nil)

                                if let endSquare = squareAtLocation(
                                    boardSize: geometry.size.width,
                                    location: gesture.location
                                ) {
                                    if let checker = checker, viewModel.canMove(checker, to: endSquare) {
                                        viewModel.move(checker, to: endSquare)
                                    }
                                }
                            })
                        )
                }
            }
            .coordinateSpace(name: "Board")
        }.frame(
            width: UIScreen.main.bounds.width * 0.9,
            height: UIScreen.main.bounds.width * 0.9
        )
    }
}

#Preview {
    ContentView(viewModel: BoardViewModel())
}
