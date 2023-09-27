//
//  InputVM.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import Foundation

class GameVM: ObservableObject {
    @Published var gameType: GameType = .single
    @Published var player: Player
    @Published var otherPlayers: [Player] = []
    
    private(set) var yourName: String
    private(set) var categories: [String] = []
    
    init(yourName: String) {
        self.player = Player(name: yourName)
        self.yourName = yourName
    }
    
    func fetchCategories() {
        categories = allNormalCategories.randomElements(numberElements: 10)
        
        for category in categories {
            player.answers.append(Answer(category: category))
        }
    }
}
