//
//  Player.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import Foundation
import SwiftUI

let gameTitle = "Categories"
let maxRemainingTime = 100
var appBackground: some View {
    Image("background")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()
        .brightness(-0.1)
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
    "Things You Can Buy Online"
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
    var id: String
    var name: String
    var score: Int = 0
    var isHost: Bool = false
    var answers: [Answer] = []
    var markee: String = ""
    
    init(id: String = UUID().uuidString, name: String, score: Int = 0, isHost: Bool = false, answers: [Answer] = []) {
        self.id = id
        self.name = name
        self.score = score
        self.isHost = isHost
        self.answers = answers
    }
}

struct Answer: Codable, Identifiable {
    var id: String = UUID().uuidString
    var category: String
    var text: String = ""
    var points: Int = 0
}


struct GameMove: Codable {
    enum Action: Int, Codable {
        case start, categories, markers, sendAnswers, next, reset, end
    }
    
    let action: Action
    var UUIDString: String? = nil
    var playerName: String? = nil
    var categories: [String]? = nil
    var letter: String? = nil
    var markers: [Marker]? = nil
    var answers: [Answer]? = nil
    
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
    struct Marker: Codable {
        let marker: String
        let markee: String
    }
}
