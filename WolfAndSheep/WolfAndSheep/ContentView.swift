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
    let boardSize: CGFloat = UIScreen.main.bounds.width * 0.9
    let coordinateSpaceName: String = "Board"
    var columns: [GridItem] { Array(repeating: GridItem(), count: viewModel.matrixSize) }
    
    
    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: columns, spacing: 0) {
                renderSquares(geometry: geometry)
            }.coordinateSpace(name: coordinateSpaceName)
        }.frame(width: boardSize, height: boardSize)
    }
    
    func renderSquares(geometry: GeometryProxy) -> some View {
        let squareSize = geometry.size.width / CGFloat(viewModel.matrixSize) + 1
        
        return ForEach(viewModel.squares) { square in
            let checker = viewModel.checker(at: square)
            BoardSquare(color: viewModel.getSquareColor(square))
                .frame(width: squareSize, height: squareSize)
                .overlay {
                    if let checker = checker {
                        BoardChecker(
                            color: viewModel.getCheckerColor(checker),
                            isHighlighted: viewModel.selectedChecker == checker
                        )
                        .offset(checker == viewModel.selectedChecker ? dragOffset : .zero)
                    }
                }
                .zIndex(checker == viewModel.selectedChecker ? 1 : 0)
                .gesture(DragGesture(coordinateSpace: .named(coordinateSpaceName))
                    .onChanged({ gesture in
                        handleOnDragChange(gesture, square: square)
                    })
                        .onEnded({ gesture in
                            handleOnDragEnd(gesture, boardSize: geometry.size.width, checker: checker)
                        })
                )
        }
    }
    
    func squareAtLocation(boardSize: CGFloat, location: CGPoint) -> BoardModel.Square? {
        let squareSize = boardSize / CGFloat(viewModel.matrixSize)
        let column = Int(location.x / squareSize)
        let row = Int(location.y / squareSize)
        return viewModel.squareAt(row: row, column: column)
    }
    
    func handleOnDragChange(
        _ gesture: DragGesture.Value,
        square: BoardModel.Square
    ) {
        if let checker = viewModel.checker(at: square) {
            if viewModel.selectedChecker == nil {
                viewModel.select(checker)
            }
            dragOffset = gesture.translation
        }
    }
    
    func handleOnDragEnd(
        _ gesture: DragGesture.Value,
        boardSize: CGFloat,
        checker: BoardModel.Checker?
    ) {
        dragOffset = .zero
        viewModel.select(nil)
        
        if let endSquare = squareAtLocation(boardSize: boardSize, location: gesture.location) {
            if let checker = checker, viewModel.canMove(checker, to: endSquare) {
                viewModel.move(checker, to: endSquare)
            }
        }
    }
}

#Preview {
    ContentView(viewModel: BoardViewModel())
}
