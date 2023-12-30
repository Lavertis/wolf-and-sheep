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
}
