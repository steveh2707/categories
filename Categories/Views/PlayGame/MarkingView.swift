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
    
//    let indexOfPlayerToBeMarked = vm.findIndexOfPlayer(name: vm.players[0].markee)
    
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
                                let answerAccepted = !vm.checkIfAnswerDuplicated(index: i, answerText: answer.text) && !answer.text.isEmpty && vm.checkIfAnswerStartsWithCorrectLetter(answerText: answer.text)
                                
                                HStack {
                                    Text(answer.category)
                                    
                                    Spacer()
                                    
                                    Text("\(answer.points)")
                                        .padding(.trailing)
                                }
                                .fontWeight(.semibold)
                                .padding(.top, 5)
                                .padding(.bottom, -5)
                                ZStack {
                                    HStack {
                                        HStack {
                                            Text(answer.text)
                                                .padding(.horizontal)
                                            Spacer()
                                        }
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.theme.red)
                                                .brightness(-0.15)
                                        )
                                        .padding(.trailing, 5)
                                        HStack {
                                            Image(systemName: answer.points > 0 ? "checkmark.square.fill" : "checkmark.square")
                                                .foregroundColor(answer.points > 0 ? Color.green : Color.black)
                                                .onTapGesture {
                                                    if answerAccepted {
                                                        vm.players[indexOfPlayerToBeMarked].answers[i].points = 10
                                                    }
                                                }
                                            Image(systemName: answer.points == 0 ? "x.square.fill" : "x.square")
                                                .foregroundColor(answer.points == 0 ? Color.red : Color.black)
                                                .onTapGesture {
                                                    if answerAccepted {
                                                        vm.players[indexOfPlayerToBeMarked].answers[i].points = 0
                                                    }
                                                }
                                        }
                                        .font(.title3)
                                        
                                    }
                                    .padding(.vertical, 2)
                                    
                                    if !answerAccepted {
                                        Divider()
                                            .frame(height: 2)
                                            .overlay(.black)
                                    }
                                    
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.theme.red)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top)
                    .padding(.bottom)
                    
                }
            }
        }
        .onAppear {
            
        }
        
    }
    
    private var headingSection: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.theme.red)
                Text(vm.selectedLetter)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(width: 70, height: 70)
            
            Spacer()
            
            ZStack {
                Capsule()
                    .foregroundColor(.theme.red)
                Label("\(totalPoints)", systemImage: "star.circle.fill")
                    .font(.title2)
            }
            .frame(width: 120, height: 60)
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
                        .foregroundColor(.theme.red)
                    Image(systemName: "checkmark.square")
                        .font(.title)
                }
            }
            
            .frame(width: 70, height: 70)
        }
        .padding(.horizontal, 20)
    }
    
}

//#Preview {
//    MarkingView()
//        .environmentObject(GameVM(yourName: "Sample"))
//        .environmentObject(MultipeerVM(yourName: "Sample"))
//}
