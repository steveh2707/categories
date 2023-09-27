//
//  Player.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import Foundation

let maxRemainingTime = 10

let categories = [
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

let randomCategories = categories.randomElements(numberElements: 3)

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
    var id: UUID { UUID() }
    var name: String
    var score: Int
    var isHost: Bool
    var answers: [Answer]
}

struct Answer: Codable {
    var category: String
    var answer: String
}
