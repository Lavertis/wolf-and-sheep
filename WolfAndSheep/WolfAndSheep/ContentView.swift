//
//  ContentView.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import SwiftUI



struct ContentView: View {
    @ObservedObject var viewModel: BoardViewModel
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        let columns = Array(repeating: GridItem(), count: viewModel.boardSize)
        
        GeometryReader { geometry in
            let squareSize = geometry.size.width / CGFloat(viewModel.boardSize) + 1
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.squares) { square in
                    let checker = viewModel.checker(at: square)
                    BoardSquare(color: viewModel.getSquareColor(square))
                        .frame(width: squareSize, height: squareSize)
                        .clipped()
                        .overlay {
                            if let checker = viewModel.checker(at: square) {
                                BoardChecker(
                                    color: checker.type == .wolf ? Color.yellow : Color.green,
                                    isHighlighted: viewModel.selectedChecker == checker
                                )
                                .offset(checker == viewModel.selectedChecker ? offset : .zero)
                            }
                        }
                        .zIndex(checker == viewModel.selectedChecker ? 1 : 0)
                        .gesture(DragGesture()
                            .onChanged({ gesture in
                                if let checker = viewModel.checker(at: square) {
                                    if viewModel.selectedChecker == nil {
                                        viewModel.select(checker)
                                    }
                                    offset = gesture.translation
                                }
                            })
                            .onEnded({ gesture in
                                offset = .zero
                                viewModel.select(nil)
                                
                                var dragEndLocation = gesture.location
                                print("Drag ended at: \(dragEndLocation)")
                                dragEndLocation.x -= (UIScreen.main.bounds.width - geometry.size.width) / 2
                                dragEndLocation.y += geometry.size.height
                                print("Drag ended at: \(dragEndLocation)")
                                if let endSquare = viewModel.squareAtLocation(dragEndLocation) {
                                    print("Drag ended on square: \(endSquare)")
                                    if let checker = checker, viewModel.canMove(checker, to: endSquare) {
                                        viewModel.move(checker, to: endSquare)
                                    }
                                }
                            })
                        )
                }
            }
        }.frame(
            width: UIScreen.main.bounds.width * 0.9,
            height: UIScreen.main.bounds.width * 0.9
        )
    }
}

#Preview {
    ContentView(viewModel: BoardViewModel())
}
