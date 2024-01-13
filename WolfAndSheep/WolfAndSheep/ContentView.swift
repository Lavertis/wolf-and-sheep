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
    @State private var boardRotationAngle: Int = 0
    
    let boardSize: CGFloat = UIScreen.main.bounds.width * 0.9
    let coordinateSpaceName: String = "Board"
        
    var body: some View {
        VStack {
            score
            resetGameButton
            Spacer()
            boardContainer
            Spacer(minLength: 130)
            rotateBoardButtons
        }
    }
    
    private var score: some View {
        HStack {
            Text("Wolf: \(viewModel.wolfScore)")
            Spacer()
            Text("Sheep: \(viewModel.sheepScore)")
        }
        .font(.title)
        .padding(.horizontal)
    }
    
    private var rotateBoardButtons: some View {
        HStack {
            Button(action: {
                changeBoardRotationAngle(by: -90)
            }) {
                Image(systemName: "arrow.counterclockwise")
                    .transformIntoButton()
            }

            Button(action: {
                changeBoardRotationAngle(by: 90)
            }) {
                Image(systemName: "arrow.clockwise")
                    .transformIntoButton()
            }
        }
    }
    
    private var resetGameButton: some View {
        Button(action: {
            changeBoardRotationAngle(to: 0)
            withAnimation() {
                viewModel.resetGame()
            }
        }) {
            Text("Reset round")
                .transformIntoButton()
        }
        .padding()
    }
    
    private var boardContainer: some View {
        var columns: [GridItem] {
            Array(repeating: GridItem(.flexible(), spacing: 0), count: viewModel.matrixSize)
        }
        return GeometryReader { geometry in
            ZStack {
                LazyVGrid(columns: columns, spacing: 0) {
                    renderBoardSquares(geometry: geometry)
                }
                LazyVGrid(columns: columns, spacing: 0) {
                    renderBoardCheckers(geometry: geometry)
                }
            }
            .coordinateSpace(name: coordinateSpaceName)
            .alert(
                isPresented: $isAlertShown,
                content: { gameResultAlert }
            )
        }
        .frame(width: boardSize, height: boardSize)
        .border(Color.black, width: 1)
        .rotationEffect(.degrees(Double(boardRotationAngle)))
    }
    
    private func renderBoardSquares(geometry: GeometryProxy) -> some View {
        let squareSize = geometry.size.height / CGFloat(viewModel.matrixSize)
        
        return ForEach(viewModel.squares) { square in
            BoardSquareView(color: viewModel.getSquareColor(square))
                .frame(height: squareSize)
        }
    }
    
    private func renderBoardCheckers(geometry: GeometryProxy) -> some View {
        let squareSize = geometry.size.height / CGFloat(viewModel.matrixSize)
        
        return ForEach(viewModel.squares) { square in
            let checker = viewModel.checker(at: square)
            if let checker = checker {
                CheckerView(
                    color: viewModel.getCheckerColor(checker),
                    isHighlighted: viewModel.turn == checker.type
                )
                .gesture(
                    DragGesture(coordinateSpace: .named(coordinateSpaceName))
                        .onChanged({ gesture in
                            handleOnDragChange(gesture, checker: checker)
                        })
                        .onEnded({ gesture in
                            handleOnDragEnd(gesture, boardSize: geometry.size.width, checker: checker)
                        })
                )
                .offset(checker == viewModel.selectedChecker ? dragOffset : .zero)
                .zIndex(checker == viewModel.selectedChecker ? 2 : 1)
                .frame(height: squareSize)
            } else {
                Color.clear.frame(width: squareSize, height: squareSize)
            }
        }
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
    
    private func squareAtLocation(boardSize: CGFloat, location: CGPoint) -> BoardModel.Square? {
        let squareSize = boardSize / CGFloat(viewModel.matrixSize)
        let column = Int(location.x / squareSize)
        let row = Int(location.y / squareSize)
        return viewModel.squareAt(row: row, column: column)
    }
    
    private func handleOnDragChange(_ gesture: DragGesture.Value, checker: BoardModel.Checker?) {
        if let checker = checker {
            if viewModel.selectedChecker == nil {
                viewModel.select(checker)
            }
            dragOffset = gesture.translation
        }
    }
    
    private func handleOnDragEnd(
        _ gesture: DragGesture.Value,
        boardSize: CGFloat,
        checker: BoardModel.Checker?
    ) {
        withAnimation {
            dragOffset = .zero
            viewModel.select(nil)
        }
        
        if let endSquare = squareAtLocation(boardSize: boardSize, location: gesture.location) {
            if let checker = checker,
               viewModel.canMove(checker, to: endSquare),
               checker.type == viewModel.turn
            {
                viewModel.move(checker, to: endSquare)
                if viewModel.isGameOver {
                    isAlertShown = true
                }
            }
        }
    }
    
    private func changeBoardRotationAngle(to toDegrees: Int? = nil, by byDegrees: Int? = nil) {
        withAnimation(.spring(duration: 1, bounce: 0.25)) {
            if toDegrees != nil && byDegrees != nil {
                fatalError("Cannot set both toDegrees and byDegrees")
            }
            if let toDegrees = toDegrees {
                boardRotationAngle = toDegrees
            } else if let byDegrees = byDegrees {
                boardRotationAngle += byDegrees
            }
        }
    }
}

#Preview {
    ContentView(viewModel: BoardViewModel())
}
