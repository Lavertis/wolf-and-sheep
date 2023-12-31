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
    @State private var isAlertShown: Bool = false
    
    let boardSize: CGFloat = UIScreen.main.bounds.width * 0.9
    let coordinateSpaceName: String = "Board"
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 0), count: viewModel.matrixSize)
    }
    
    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: columns, spacing: 0) {
                renderSquares(geometry: geometry)
            }
            .coordinateSpace(name: coordinateSpaceName)
            .alert(
                isPresented: $isAlertShown,
                content: { gameResultAlert }
            )
        }
        .frame(width: boardSize, height: boardSize)
        .border(Color.black, width: 1)
    }
    
    private var gameResultAlert: Alert {
        Alert(
            title: Text("Game Over"),
            message: Text(viewModel.getGameStatusMessage()),
            dismissButton: .default(Text("Play Again")) {
                viewModel.resetGame()
            }
        )
    }
    
    func renderSquares(geometry: GeometryProxy) -> some View {
        let squareSize = geometry.size.height / CGFloat(viewModel.matrixSize)
        
        return ForEach(viewModel.squares) { square in
            let checker = viewModel.checker(at: square)
            BoardSquare(color: viewModel.getSquareColor(square))
                .frame(height: squareSize)
                .overlay {
                    if let checker = checker {
                        BoardChecker(
                            color: viewModel.getCheckerColor(checker),
                            isHighlighted: viewModel.selectedChecker == checker
                        )
                        .gesture(DragGesture(coordinateSpace: .named(coordinateSpaceName))
                            .onChanged({ gesture in
                                handleOnDragChange(gesture, square: square)
                            })
                            .onEnded({ gesture in
                                handleOnDragEnd(gesture, boardSize: geometry.size.width, checker: checker)
                            })
                        )
                        .offset(checker == viewModel.selectedChecker ? dragOffset : .zero)
                    }
                }
                .zIndex(checker == viewModel.selectedChecker ? 1 : 0)
        }
    }
    
    func squareAtLocation(boardSize: CGFloat, location: CGPoint) -> BoardModel.Square? {
        let squareSize = boardSize / CGFloat(viewModel.matrixSize)
        let column = Int(location.x / squareSize)
        let row = Int(location.y / squareSize)
        return viewModel.squareAt(row: row, column: column)
    }
    
    func handleOnDragChange(_ gesture: DragGesture.Value, square: BoardModel.Square) {
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
            if let checker = checker, viewModel.canMove(checker, to: endSquare)
            {
                viewModel.move(checker, to: endSquare)
                handleGameStatus()
            }
        }
    }
    
    func handleGameStatus() {
        let gameStatus = viewModel.getGameStatus()
        switch gameStatus {
        case .wolfWon:
            isAlertShown = true
        case .sheepWon:
            isAlertShown = true
        case .inProgress:
            do {}
        }
    }
}

#Preview {
    ContentView(viewModel: BoardViewModel())
}
