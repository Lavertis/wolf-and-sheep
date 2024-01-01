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
    @State private var rotateBoardAfterTurn = false
    @State private var boardRotationAngle: Int = 0
    
    let boardSize: CGFloat = UIScreen.main.bounds.width * 0.9
    let coordinateSpaceName: String = "Board"
    
    var body: some View {
        VStack {
            score
            rotateAfterTurnCheckbox
            Spacer()
            boardContainer
            Spacer()
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
    
    private var boardContainer: some View {
        var columns: [GridItem] {
            Array(repeating: GridItem(.flexible(), spacing: 0), count: viewModel.matrixSize)
        }
        return GeometryReader { geometry in
            LazyVGrid(columns: columns, spacing: 0) {
                renderBoardSquares(geometry: geometry)
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
    
    func renderBoardSquares(geometry: GeometryProxy) -> some View {
        let squareSize = geometry.size.height / CGFloat(viewModel.matrixSize)
        
        return ForEach(viewModel.squares) { square in
            let checker = viewModel.checker(at: square)
            BoardSquare(color: viewModel.getSquareColor(square))
                .frame(height: squareSize)
                .overlay {
                    if let checker = checker {
                        BoardChecker(
                            color: viewModel.getCheckerColor(checker),
                            isHighlighted: viewModel.turn == checker.type
                        )
                        .gesture(
                            DragGesture(coordinateSpace: .named(coordinateSpaceName))
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
    
    private var rotateAfterTurnCheckbox: some View {
        Toggle(
            "Rotate board after turn",
            isOn: $rotateBoardAfterTurn
        )
        .toggleStyle(SwitchToggleStyle(tint: .red))
        .onChange(of: rotateBoardAfterTurn) {
            rotateBoard()
        }
        .padding(.horizontal)
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
    
    func rotateBoard() {
        guard rotateBoardAfterTurn else {
            return
        }
        
        let isBoardRotatedCorrectly = viewModel.turn == .wolf && boardRotationAngle == 0 ||
        viewModel.turn == .sheep && boardRotationAngle == 180
        guard !isBoardRotatedCorrectly else {
            return
        }
        
        withAnimation(.spring(duration: 1, bounce: 0.25).delay(0.25)) {
            boardRotationAngle = (boardRotationAngle + 180) % 360
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
            if let checker = checker,
               viewModel.canMove(checker, to: endSquare),
               checker.type == viewModel.turn
            {
                viewModel.move(checker, to: endSquare)
                handleGameStatus()
                rotateBoard()
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
