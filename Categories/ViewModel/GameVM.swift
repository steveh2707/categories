//
//  InputVM.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import Foundation

enum Screen {
    case inputView, markingView, nextRoundView
}

@MainActor
class GameVM: ObservableObject {
    @Published var gameType: GameType = .single
    @Published var selectedLetter: String = ""
    @Published var players: [Player]
    
    @Published var currentRound = 1
//    @Published var totalRounds = 3
    
    @Published var playing: Bool = false
    @Published var remainingTime = maxRemainingTime
    
    @Published var screen: Screen = .inputView
    
    private(set) var yourName: String
    private(set) var categories: [String] = []
    
    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(yourName: String) {
        self.players = [Player(name: yourName)]
        self.yourName = yourName
    }
    
    func startGame() {
        self.playing = true
    }
    
    func nextRound() {
        self.currentRound += 1
        //        if currentRound > totalRounds {
        //            self.screen = .gameEnd
        //        } else {
        self.categories = []
        self.selectedLetter = ""
        for i in 0..<players.count {
            self.players[i].answers = []
            self.players[i].roundScore = 0
            self.players[i].roundScoreReceived = false
        }
        self.screen = .inputView
        self.remainingTime = maxRemainingTime
        //        }
    }
    
//    func playAgain() {
//        self.currentRound = 1
//        self.categories = []
//        self.selectedLetter = ""
//        for i in 0..<players.count {
//            self.players[i].answers = []
//            self.players[i].roundScore = 0
//            self.players[i].roundScoreReceived = false
//        }
//        self.screen = .inputView
//        self.remainingTime = maxRemainingTime
//    }
    
    func closeGame() {
        self.playing = false
        self.categories = []
        self.players[0].answers = []
        self.players[0].score = 0
        self.players[0].isHost = false
        self.players.removeSubrange(1..<players.count)
        self.selectedLetter = ""
        self.remainingTime = maxRemainingTime
    }
    
    func fetchCategoriesAndLetter() {
        categories = allNormalCategories.randomElements(numberElements: 10)
        
        for category in categories {
            players[0].answers.append(Answer(category: category))
        }
        
        let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letter = letters.randomElement() ?? "?"
        selectedLetter = String(letter)
    }
    
    func setCategoriesAndLetter(categories: [String], letter: String) {
        self.categories = categories
        for category in categories {
            players[0].answers.append(Answer(category: category))
        }
        self.selectedLetter = letter
    }

    
    func findIndexOfPlayer(name: String) -> Int {
        for (i, player) in players.enumerated() {
            if player.name == name {
                return i
            }
        }
        return -1
    }
    
    func checkIfAnswerDuplicated(index: Int, answerText: String) -> Bool {
        var count = 0
        for player in players {
            if player.answers[index].text.lowercased() == answerText.lowercased() {
                count += 1
            }
        }
        return count > 1
    }
    
    func checkIfAnswerStartsWithCorrectLetter(answerText: String) -> Bool {
        String(answerText.first!).lowercased() == selectedLetter.lowercased()
    }
    
    func assignRoundScore(playerIndex: Int, roundScore: Int) {
        self.players[playerIndex].roundScoreReceived = true
        self.players[playerIndex].roundScore = roundScore
        self.players[playerIndex].score += roundScore
    }
    
    var allPlayersAnswersReceived: Bool {
        var allAnswered = true
        for player in players {
            if player.answers.isEmpty {
                allAnswered = false
            }
        }
        return allAnswered
    }
}
