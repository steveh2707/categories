//
//  Temp.swift
//  Categories
//
//  Created by Steve on 27/09/2023.
//

import SwiftUI

struct Temp: View {
    
    let players = [Player(name: "Steve"), Player(name: "Emma Iriwn", roundScoreReceived: false), Player(name: "Dave")]
    
    var body: some View {
//        NavigationStack {
            ZStack {
                appBackground
                VStack {
                    
                    VStack {
                        Text("Leaderboard")
                            .font(.largeTitle)
                        
                        Text("Round 1")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.theme.inputRed)
                    )
                    
                    VStack {
                        ForEach(players) { player in
                            HStack {
                                Text(player.name)
                                    .font(.title3)
                                
                                Spacer()
                                if !player.roundScoreReceived {
                                    ProgressView()
                                } else {
                                    Text("\(player.roundScore)")
                                }
                                Text("\(player.score)")
                                    .padding(.leading, 40)
                            }
                            .frame(height: 40)
                        }
                        .padding(.horizontal)
                        
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.theme.inputRed)
                    )
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        Button("Next Round") {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        Button("Next Round") {
                            
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .brightness(-0.1)
                    )
                    
                    Spacer()
                }
            }
//            .navigationTitle("Leaderboard")
//        }
    }
}

#Preview {
    Temp()
}
