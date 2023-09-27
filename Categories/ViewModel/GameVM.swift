//
//  InputVM.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import Foundation

class GameVM: ObservableObject {
    @Published var gameType: GameType = .single
    @Published var selectedLetter: String = ""
    
    @Published var player: Player
    @Published var otherPlayers: [Player] = []
    
    @Published var currentRound = 1
    @Published var totalRounds = 3
    
    @Published var playing: Bool = false
    @Published var remainingTime = maxRemainingTime
    @Published private(set) var reachedEnd = false
    
    private(set) var yourName: String
    private(set) var categories: [String] = []
    
    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(yourName: String) {
        self.player = Player(name: yourName)
        self.yourName = yourName
    }
    
    func startGame() {
        self.playing = true
    }
    
    func nextRound() {
        self.currentRound += 1
        if currentRound > totalRounds {
            reachedEnd = true
        } else {
            self.categories = []
            self.selectedLetter = ""
            self.player.answers = []
            self.remainingTime = maxRemainingTime
        }
    }
    
    func endGame() {
        self.playing = false
        self.categories = []
        self.otherPlayers = []
        self.player.answers = []
        self.selectedLetter = ""
        self.remainingTime = maxRemainingTime
        self.player.name = yourName
        self.player.isHost = false
    }
    
    func fetchCategoriesAndLetter() {
        categories = allNormalCategories.randomElements(numberElements: 10)
        
        for category in categories {
            player.answers.append(Answer(category: category))
        }
        
        let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letter = letters.randomElement() ?? "?"
        selectedLetter = String(letter)
    }
    
    func setCategoriesAndLetter(categories: [String], letter: String) {
        self.categories = categories
        for category in categories {
            player.answers.append(Answer(category: category))
        }
        self.selectedLetter = letter
    }

    
    func findIndexOfPlayer(name: String) -> Int {
        for (i, player) in otherPlayers.enumerated() {
            if player.name == name {
                return i
            }
        }
        return -1
    }
    
    
}
