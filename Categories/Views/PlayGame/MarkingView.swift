//
//  MarkingView.swift
//  Categories
//
//  Created by Steve on 26/09/2023.
//

import SwiftUI

struct MarkingView: View {
    
    @EnvironmentObject var vm: GameVM
    @EnvironmentObject var mpvm: MultipeerVM
    
    var indexOfPlayerToBeMarked: Int {
        vm.findIndexOfPlayer(name: vm.players[0].markee)
    }
    
    var totalPoints: Int {
        var points = 0
        for answer in vm.players[indexOfPlayerToBeMarked].answers {
            points += answer.points
        }
        return points
    }
    
    var body: some View {
        ZStack {
            
            if vm.allPlayersAnswersReceived {
                
                appBackground
                
                VStack{
                    headingSection
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack { Spacer() }
                            
                            ForEach(vm.players[indexOfPlayerToBeMarked].answers.indices, id: \.self) { i in
                                
                                let answer = vm.players[indexOfPlayerToBeMarked].answers[i]
                                let answerAccepted = vm.automatedAnswerChecking(questionIndex: i, playerIndex: indexOfPlayerToBeMarked, answerText: answer.text)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(answer.category)
                                            .fontWeight(.semibold)
                                            .padding(.top, 5)
                                            .padding(.bottom, -5)
                                        ZStack {
                                            HStack {
                                                HStack {
                                                    Text(answer.text.isEmpty ? " " : answer.text)
                                                        .padding(.horizontal)
                                                    Spacer()
                                                }
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .foregroundColor(.theme.markingBlue)
                                                        .brightness(-0.15)
                                                )
//                                                .padding(.trailing, 5)
                                                
                                            }
                                            .padding(.vertical, 4)
                                            
                                            if !answerAccepted {
                                                Divider()
                                                    .frame(height: 3)
                                                    .overlay(.black)
                                                    .padding(.horizontal, 5)
                                            }
                                            
                                        }
                                        .padding(.trailing, 5)
                                    }
                                    HStack {
                                        Button {
                                            vm.players[indexOfPlayerToBeMarked].answers[i].points = 10
                                        } label: {
                                            Image(systemName: answer.points > 0 ? "checkmark.square.fill" : "checkmark.square")
                                                .foregroundColor(answerAccepted ? (answer.points > 0 ? Color.green : Color.black) : .gray)
                                        }
                                        .disabled(!answerAccepted)
                                        
                                        Button {
                                            vm.players[indexOfPlayerToBeMarked].answers[i].points = 0
                                        } label: {
                                            Image(systemName: answer.points == 0 ? "x.square.fill" : "x.square")
                                                .foregroundColor(answerAccepted ? (answer.points == 0 ? Color.red : Color.black) : .gray)
                                        }
                                        .disabled(!answerAccepted)
                     

                                    }
                                    .font(.title)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.theme.markingBlue)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top)
                    .padding(.bottom)
                    
                }
            }
        }
        
    }
    
    private var headingSection: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.theme.markingBlue)
                Text(vm.selectedLetter)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(width: 70, height: 70)
            
            Spacer()
            
            ZStack {
//                Capsule()
//                    .foregroundColor(.theme.markingBlue)
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.theme.markingBlue)
                VStack {
                    Text(vm.players[indexOfPlayerToBeMarked].name)
                        .font(.title3)
                    Label("\(totalPoints)", systemImage: "star.circle.fill")
                        .font(.title2)
                }
            }
            .frame(width: 120, height: 70)
            Spacer()
            Button {
                if vm.gameType == .peer {
                    vm.assignRoundScore(playerIndex: indexOfPlayerToBeMarked, roundScore: totalPoints)
                    mpvm.submitMarkeeScore(playerName: vm.players[0].markee, points: totalPoints)
                    vm.screen = .nextRoundView
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.theme.markingBlue)
                    Image(systemName: "checkmark.square")
                        .font(.title)
                }
            }
            
            .frame(width: 70, height: 70)
        }
        .padding(.horizontal, 20)
    }
    
}

#Preview {
    MarkingView()
        .environmentObject(GameVM.previewInstance())
        .environmentObject(MultipeerVM(yourName: "Sample"))
}
