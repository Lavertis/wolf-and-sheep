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
    
    func checker(at square: BoardModel.Square) -> BoardModel.Checker? {
        return model.checker(at: square)
    }
    
    func onSquareTap(_ square: BoardModel.Square) {
        guard let selectedChecker = checkers.first(where: { $0.isSelected }) else {
            select(checker(at: square))
            return
        }
        
        if selectedChecker.row == square.row && selectedChecker.column == square.column {
            select(nil)
            return
        }
        
        if let newChecker = model.checkers.first(where: { $0.row == square.row && $0.column == square.column }) {
            select(newChecker)
            return
        }
        
        if model.canMove(selectedChecker, to: square) {
            move(selectedChecker, to: square)
            select(nil)
        }
    }
    
    private func move(_ checker: BoardModel.Checker, to square: BoardModel.Square) {
        model.move(checker, to: square)
    }
    
    private func select(_ checker: BoardModel.Checker?) {
        model.select(checker)
    }
}
