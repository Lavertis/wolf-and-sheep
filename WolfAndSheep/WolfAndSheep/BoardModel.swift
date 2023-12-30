//
//  BoardModel.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import Foundation

struct BoardModel {
    private(set) var squares: Array<Square> = []
    private(set) var checkers: Array<Checker> = []
    
    init() {
        squares = initSquares()
        checkers = initCheckers()
    }
    
    func initSquares() -> Array<Square> {
        var squares = Array<Square>()
        
        for row in 0 ..< 8 {
            for column in 0 ..< 8 {
                squares.append(Square(row: row, column: column))
            }
        }
        
        return squares
    }
    
    func getSheepCheckers() -> Array<Checker> {
        var checkers = Array<Checker>()
        
        for column in stride(from: 1, to: 8, by: 2) {
            checkers.append(Checker(row: 0, column: column, type: .sheep))
        }
        
        return checkers
    }
    
    func getWolfChecker() -> Checker {
        return Checker(row: 7, column: 0, type: .wolf)
    }
    
    func initCheckers() -> Array<Checker> {
        var checkers = getSheepCheckers()
        checkers.append(getWolfChecker())
        return checkers
    }
    
    func canMove(_ checker: Checker, to square: Square) -> Bool {
        guard let index = checkers.firstIndex(of: checker) else {
            return false
        }
        
        let checker = checkers[index]
        if square.row == checker.row || square.column == checker.column {
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
        guard let index = checkers.firstIndex(of: checker) else {
            return
        }
        if !canMove(checker, to: square) {
            return
        }
        
        checkers[index] = Checker(row: square.row, column: square.column, type: checker.type)
    }
    
    mutating func select(_ checker: Checker?) {
        checkers.indices.forEach { checkers[$0].isSelected = false }
        guard let checker = checker else {
            return
        }
        
        guard let index = checkers.firstIndex(of: checker) else {
            return
        }
        
        checkers[index].isSelected = true
        print("Selected checker at row: \(checker.row), column: \(checker.column)")
    }
    
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
        var isSelected: Bool = false
        let type: CheckerType
        
        var id: String {
            "\(row),\(column)"
        }
    }
}
