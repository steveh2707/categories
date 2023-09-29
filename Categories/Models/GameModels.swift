//
//  Player.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import Foundation
import SwiftUI

let gameTitle = "Ten In Time"

let maxRemainingTime = 120

var appBackground: some View {
    GeometryReader { geo in
        Image("background")
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, alignment: .center)
            .ignoresSafeArea()
            .brightness(-0.1)
    }
}

let allNormalCategories = [
    "Fictional Characters",
    "Famous Landmarks",
    "Things You Can Eat",
    "Musical Instruments",
    "Cartoon Characters",
    "Sports Equipment",
    "Countries",
    "Historical Figures",
    "Things That Are Cold",
    "Types of Birds",
    "Things You Find at the Beach",
    "Desserts",
    "Movie Titles",
    "Types of Trees",
    "Board Games",
    "Things in a Toolbox",
    "Superheroes",
    "Kitchen Appliances",
    "Famous Authors",
    "Items in a School Bag",
    "Colors",
    "Types of Fish",
    "Things That Are Round",
    "Types of Shoes",
    "Animals",
    "Vegetables",
    "Body Parts",
    "TV Shows",
    "Hobbies",
    "Things You Can Buy Online",
    "Things You Can Smell",
    "90s Pop Songs",
    "Pizza Toppings",
    "Modes of Transportation",
    "Items in a Junk Drawer",
    "Dog Breeds",
    "Movie Genres",
    "Types of Weather",
    "Things You Can Sip",
    "Cartoon Villains",
    "Mythical Creatures",
    "Types of Hats",
    "Things That Are Sticky",
    "Video Game Titles",
    "Types of Candy",
    "Historical Events",
    "Words with Double Letters",
    "Items in a Supermarket",
    "Singers or Bands",
    "Things That Are Soft",
    "Famous Artists",
    "Things That Are Square",
    "Types of Fruit",
    "Things That Are Sharp",
    "Types of Flowers",
    "Things You Can Drink",
    "Sports Teams"
]



enum GameType {
    case single, peer, online
    
    var description: String {
        switch self {
        case .single:
            return "Answer quiz questions on your own!"
        case .peer:
            return "Invite someone near you who has this app running to play!"
        case .online:
            return "Play online against anyone in the world!"
        }
    }
}

struct Player: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var roundScore: Int = 0
    var score: Int = 0
    var isHost: Bool = false
    var answers: [Answer] = []
    var markee: String = ""
    var roundScoreReceived = false
//    var answersReceived = false
    
//    init(id: String = UUID().uuidString, name: String, score: Int = 0, isHost: Bool = false, answers: [Answer] = [], wating: Bool = true) {
//        self.id = id
//        self.name = name
//        self.score = score
//        self.isHost = isHost
//        self.answers = answers
//        self.waiting = true
//    }
}

struct Answer: Codable, Identifiable {
    var id: String = UUID().uuidString
    var category: String
    var text: String = ""
    var points: Int = 0
}


struct GameMove: Codable {
    enum Action: Int, Codable {
        case start, categories, markers, sendAnswers, roundScores, nextRound, end
    }
    
    let action: Action
    var UUIDString: String? = nil
    var playerName: String? = nil
    var categories: [String]? = nil
    var letter: String? = nil
    var markers: [Marker]? = nil
    var answers: [Answer]? = nil
    var roundScore: Int? = nil
    
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
    struct Marker: Codable {
        let marker: String
        let markee: String
    }
}
