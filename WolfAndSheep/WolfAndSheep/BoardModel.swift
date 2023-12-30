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
    
    func initCheckers() -> Array<Checker> {
        var checkers = Array<Checker>()
        
        for row in 0 ..< 8 {
            for column in 0 ..< 8 {
                if (row + column).isMultiple(of: 2) {
                    if row < 3 {
                        checkers.append(Checker(row: row, column: column, type: .wolf))
                    } else if row > 4 {
                        checkers.append(Checker(row: row, column: column, type: .sheep))
                    }
                }
            }
        }
        
        return checkers
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
        let type: CheckerType
        
        var id: String {
            "\(row),\(column)"
        }
    }
}
