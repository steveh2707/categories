//
//  ShowInputOrEndView.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import SwiftUI

struct ShowInputOrEndView: View {
    @EnvironmentObject var vm: GameVM
    @EnvironmentObject var mpvm: MultipeerVM
    @State var markScreen = false
    
    var body: some View {
        NavigationStack {
            
            if vm.reachedEnd {
                gameEndScreen
            } else if vm.remainingTime <= 0 {
                if markScreen {
                    MarkingView()
                } else {
                    nextRoundScreen
                }
            } else {
                InputView()
            }
        }
    }
    
    private var nextRoundScreen: some View {
        VStack {
            HStack {
                Button("Mark Answers") {
                    switch vm.gameType {
                    case .single:
                        break
                    case .peer:
                        markScreen = true
                    case .online:
                        break
                    }
                }
                Button("Next Round") {
                    switch vm.gameType {
                    case .single:
                        vm.nextRound()
                    case .peer:
                        break
                        //                        mpVM.initiatePlayAgain()
                    case .online:
                        break
                        //                        gkVM.initiatePlayAgain()
                    }
                }
                .buttonStyle(.borderedProminent)
                //                .foregroundColor(Color.theme.primaryTextInverse)
            }
        }
        .onAppear {
            mpvm.sendAnswersToBeMarked(answers: vm.player.answers)
        }
    }
    
    private var gameEndScreen: some View {
        VStack(spacing: 20) {
            Text("Times Up!")
                .font(.largeTitle)
//                .foregroundColor(.red)
            
            switch vm.gameType {
            case .single:
                Text("Congratulations, you completed the game! 🥳")
                    .multilineTextAlignment(.center)
            case .peer, .online:
                
                Text("Time to mark each others answers.")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(vm.otherPlayers.sorted{ $0.score > $1.score }) { player in
                        Text("\(player.name): \(player.score)")
                    }
                }
            }
            
            HStack {
                Button("Play Again") {
                    switch vm.gameType {
                    case .single:
                        break
//                        gameVM.resetGame()
                    case .peer:
                        break
//                        mpVM.initiatePlayAgain()
                    case .online:
                        break
//                        gkVM.initiatePlayAgain()
                    }
                }
                .buttonStyle(.borderedProminent)
//                .foregroundColor(Color.theme.primaryTextInverse)
                
                Button("Quit Game") {
//                    switch gameVM.gameType {
//                    case .single:
//                        gameVM.endGame()
//                    case .peer:
//                        mpVM.initiateEndGame()
//                    case .online:
//                        gkVM.initiateEndGame()
//                    }
                    
                }
                .buttonStyle(.bordered)
            }

        }
        .onAppear {
            
        }
//        .foregroundColor(Color.theme.accent)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.theme.background)
    }
}

#Preview {
    ShowInputOrEndView()
        .environmentObject(GameVM(yourName: "test"))
}
