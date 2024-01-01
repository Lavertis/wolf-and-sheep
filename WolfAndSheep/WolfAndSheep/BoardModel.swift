//
//  BoardModel.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import Foundation


struct BoardModel {
    private(set) var matrixSize: Int = 8
    private(set) var squares: Array<Square> = []
    private(set) var checkers: Array<Checker> = []
    private(set) var turn: CheckerType = .wolf
    private(set) var wolfScore: Int = 0
    private(set) var sheepScore: Int = 0
    
    init() {
        squares = createSquares()
        checkers = createCheckers()
    }
    
    private func createSquares() -> Array<Square> {
        var squares = Array<Square>()
        
        for row in 0 ..< matrixSize {
            for column in 0 ..< matrixSize {
                squares.append(Square(row: row, column: column))
            }
        }
        
        return squares
    }
    
    private func createCheckers() -> Array<Checker> {
        var checkers = createSheepCheckers()
        checkers.append(createWolfChecker())
        return checkers
    }
    
    private func createSheepCheckers() -> Array<Checker> {
        var checkers = Array<Checker>()
        
        for column in stride(from: 1, to: matrixSize, by: 2) {
            checkers.append(Checker(row: 0, column: column, type: .sheep))
        }
        
        return checkers
    }
    
    private func createWolfChecker() -> Checker {
        let randomColumn = 2 * Int.random(in: 0..<(matrixSize / 2))
        return Checker(row: matrixSize - 1, column: randomColumn, type: .wolf)
    }
    
    func checker(at square: BoardModel.Square) -> BoardModel.Checker? {
        return checkers.first { $0.row == square.row && $0.column == square.column }
    }
    
    func squareAt(row: Int, column: Int) -> Square? {
        return squares.first { $0.row == row && $0.column == column }
    }
    
    func getGameStatus() -> GameStatus {
        guard let wolfChecker = (checkers.first { $0.type == .wolf }) else {
            fatalError("Wolf checker not found")
        }
        
        if wolfChecker.row == 0 {
            return .wolfWon
        }
        
        let squaresWolfCanMoveTo = squares.filter { canMove(wolfChecker, to: $0) }
        if squaresWolfCanMoveTo.isEmpty {
            return .sheepWon
        }
        
        return .inProgress
    }
    
    mutating func resetGame() {
        updateScore()
        squares = createSquares()
        checkers = createCheckers()
        turn = .wolf
    }
    
    mutating func updateScore() {
        let gameStatus = getGameStatus()
        if gameStatus == .sheepWon {
            sheepScore += 1
        } else if gameStatus == .wolfWon {
            wolfScore += 1
        }
    }
    
    func canMove(_ checker: Checker, to square: Square) -> Bool {
        if (square.row + square.column).isMultiple(of: 2) {
            return false
        }
        
        if square.row == checker.row && square.column == checker.column {
            return false
        }
        
        if abs(square.row - checker.row) != 1 || abs(square.column - checker.column) != 1 {
            return false
        }
        
        if checkers.contains(where: { $0.row == square.row && $0.column == square.column }) {
            return false
        }
        
        if checker.type == .sheep && square.row < checker.row{
            return false
        }
        return true
    }
    
    mutating func move(_ checker: Checker, to square: Square) {
        guard checker.type == turn else {
            return
        }
        if let index = checkers.firstIndex(of: checker) {
            checkers[index] = Checker(row: square.row, column: square.column, type: checker.type)
            turn = turn == .wolf ? .sheep : .wolf
        }
    }
    
    mutating func select(_ checker: Checker?) {
        if let checker = checker {
            if checker.type != turn {
                return
            }
        }
        
        selectedChecker = checker
    }
    
    var selectedChecker: Checker? = nil
    
    struct Square: Equatable, Identifiable {
        let row: Int
        let column: Int
        
        var id: String {
            "\(row),\(column)"
        }
    }
    
    struct Checker: Equatable, Identifiable {
        let row: Int
        let column: Int
        let type: CheckerType
        
        var id: String {
            "\(row),\(column)"
        }
    }
}
