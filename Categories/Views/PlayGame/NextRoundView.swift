//
//  NextRoundView.swift
//  Categories
//
//  Created by Steve on 29/09/2023.
//

import SwiftUI

struct NextRoundView: View {
    @EnvironmentObject var vm: GameVM
    @EnvironmentObject var mpvm: MultipeerVM
    
    var body: some View {
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
                        .foregroundColor(.theme.inputRed)
                )
                
                VStack {
                    ForEach(vm.players.sorted{ $0.score > $1.score }) { player in
                        HStack {
                            Text(player.name)
                                .font(.title3)
                            
                            Spacer()
                            VStack(alignment: .center) {
                                if !player.roundScoreReceived {
                                    ProgressView()
                                } else {
                                    Text("\(player.roundScore)")
                                }
                            }
                            .frame(width: 70)
                            Text("\(player.score)")
//                                .padding(.leading, 40)
                                .frame(width: 50)
                        }
                        .frame(height: 40)
                    }
                    .padding(.horizontal)
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.theme.inputRed)
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
    
}

#Preview {
    NextRoundView()
        .environmentObject(GameVM.previewInstance())
        .environmentObject(MultipeerVM(yourName: "Sample"))
}
