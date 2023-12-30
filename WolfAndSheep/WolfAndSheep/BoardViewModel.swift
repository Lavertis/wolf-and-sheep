//
//  BoardViewModel.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import Foundation
import SwiftUI

class BoardViewModel : ObservableObject {
    
    private static func createBoard() -> BoardModel {
        return BoardModel()
    }
    
    @Published private var model : BoardModel = createBoard()
    
    var squares: Array<BoardModel.Square> { model.squares }
    var checkers: Array<BoardModel.Checker> { model.checkers }
    var selectedChecker: BoardModel.Checker? { model.selectedChecker }
    
    var matrixSize: Int { return 8 }
    
    func getSquareColor(_ square: BoardModel.Square) -> Color {
        if let selectedChecker = selectedChecker, model.canMove(selectedChecker, to: square) {
            return Color.teal
        } else {
            return (square.row + square.column).isMultiple(of: 2) ? Color.orange : Color.black
        }
    }
    
    func getCheckerColor(_ checker: BoardModel.Checker) -> Color {
        return checker.type == .wolf ? Color.yellow : Color.green
    }
    
    func checker(at square: BoardModel.Square) -> BoardModel.Checker? {
        return model.checker(at: square)
    }
    
    func squareAt(row: Int, column: Int) -> BoardModel.Square? {
        return model.squareAt(row: row, column: column)
    }
    
    func move(_ checker: BoardModel.Checker, to square: BoardModel.Square) {
        model.move(checker, to: square)
    }
    
    func canMove(_ checker: BoardModel.Checker, to square: BoardModel.Square) -> Bool {
        return model.canMove(checker, to: square)
    }
    
    func select(_ checker: BoardModel.Checker?) {
        model.select(checker)
    }
}
