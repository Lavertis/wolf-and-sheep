//
//  BoardViewModel.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import Foundation
import SwiftUI

class BoardViewModel : ObservableObject {
    typealias Square = BoardModel.Square
    typealias Checker = BoardModel.Checker
    
    @Published private var model : BoardModel = createBoard()
    
    var squares: Array<Square> { model.squares }
    var checkers: Array<Checker> { model.checkers }
    var selectedChecker: Checker? { model.selectedChecker }
    var turn: CheckerType { model.turn }
    var wolfScore: Int { model.wolfScore }
    var sheepScore: Int { model.sheepScore }
    var matrixSize: Int { model.matrixSize }
    var isGameOver: Bool { model.isGameOver }
    
    private static func createBoard() -> BoardModel {
        return BoardModel()
    }
    
    func getSquareColor(_ square: Square) -> Color {
        if let selectedChecker = selectedChecker, model.canMove(selectedChecker, to: square) {
            return Color.teal
        } else {
            return (square.row + square.column).isMultiple(of: 2) ? Color.orange : Color.black
        }
    }
    
    func getCheckerColor(_ checker: Checker) -> Color {
        return checker.type == .wolf ? Color.yellow : Color.green
    }
    
    func checker(at square: Square) -> Checker? {
        return model.checker(at: square)
    }
    
    func squareAt(row: Int, column: Int) -> Square? {
        return model.squareAt(row: row, column: column)
    }
    
    func move(_ checker: Checker, to square: Square) {
        model.move(checker, to: square)
    }
    
    func canMove(_ checker: Checker, to square: Square) -> Bool {
        return model.canMove(checker, to: square)
    }
    
    func select(_ checker: Checker?) {
        model.select(checker)
    }
    
    func getGameStatusMessage() -> String {
        let gameStatus = model.getGameStatus()
        return switch gameStatus {
        case .wolfWon:
            "Wolf has won"
        case .sheepWon:
            "Sheep have won"
        case .inProgress:
            "Game is in progress"
        }
    }
    
    func resetGame() {
        return model.resetGame()
    }
}
