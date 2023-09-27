//
//  ShowInputOrEndView.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import SwiftUI

struct GameController: View {
    @EnvironmentObject var vm: GameVM
    @EnvironmentObject var mpvm: MultipeerVM
    
    var body: some View {
        NavigationStack {
            
            switch vm.screen {
            case .inputView:
                InputView()
            case .markingView:
                MarkingView()
            case .nextRoundView:
                nextRoundScreen
            }
            
        }
    }
    
    private var nextRoundScreen: some View {
        ZStack {
            appBackground
            VStack {
                
                VStack {
                    Text("Leaderboard")
                        .font(.largeTitle)
                    Text("Round \(vm.currentRound)")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.theme.red)
                )
                
                VStack {
                    ForEach(vm.players.sorted{ $0.score > $1.score }) { player in
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
                        .foregroundColor(.theme.red)
                )
                .padding()
                
                Spacer()
                
                HStack {
                    Button("Next Round") {
                        switch vm.gameType {
                        case .single:
                            vm.nextRound()
                        case .peer:
                            mpvm.initiateNextRound()
                        case .online:
                            break
                        }
                        
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("End Game") {
                        switch vm.gameType {
                        case .single:
                            vm.closeGame()
                        case .peer:
                            mpvm.initiateCloseGame()
                        case .online:
                            break
                        }
                        
                    }
                    .buttonStyle(.bordered)
                    .opacity(1)
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
    }
    
//    private var gameEndScreen: some View {
//        VStack(spacing: 20) {
//            Text("Game Over!")
//                .font(.largeTitle)
//            
//            switch vm.gameType {
//            case .single:
//                Text("Congratulations, you completed the game! 🥳")
//                    .multilineTextAlignment(.center)
//            case .peer, .online:
//                Text("Congratulations, you completed the game! 🥳")
//                    .font(.title2)
//                VStack(alignment: .leading, spacing: 10) {
//                    ForEach(vm.players.sorted{ $0.score > $1.score }) { player in
//                        Text("\(player.name): \(player.score)")
//                    }
//                }
//            }
//            
//            HStack {
//                Button("Play Again") {
//                    switch vm.gameType {
//                    case .single:
//                        vm.playAgain()
//                    case .peer:
//                        mpvm.initiatePlayAgain()
//                    case .online:
//                        break
//                    }
//                }
//                .buttonStyle(.borderedProminent)
//                
//                Button("Quit Game") {
//                    switch vm.gameType {
//                    case .single:
//                        vm.closeGame()
//                    case .peer:
//                        mpvm.initiateCloseGame()
//                    case .online:
//                        break
//                    }
//                    
//                }
//                .buttonStyle(.bordered)
//            }
//
//        }
//        .onAppear {
//            
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
    
}

//#Preview {
//    ShowInputOrEndView()
//        .environmentObject(GameVM(yourName: "test"))
//}
