//
//  WolfAndSheepApp.swift
//  WolfAndSheep
//
//  Created by Rafał on 18/12/2023.
//

import SwiftUI

@main
struct WolfAndSheepApp: App {
    @StateObject var game = BoardViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
