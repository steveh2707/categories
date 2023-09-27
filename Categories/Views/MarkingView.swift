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
    
    
    var body: some View {
        ZStack {
            appBackground
            
            VStack{
                headingSection
                
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack { Spacer() }
                        let indexOfPlayerToBeMarked = vm.findIndexOfPlayer(name: vm.player.markee)
                        ForEach($vm.otherPlayers[indexOfPlayerToBeMarked].answers) { $answer in
                            HStack {
                                Text(answer.category)
                                   
                                Spacer()
                                
                                Text("\(answer.points)")
                                    .padding(.trailing)
                            }
                            .fontWeight(.semibold)
                            .padding(.top, 5)
                            .padding(.bottom, -5)
                            HStack {
                                Text(answer.text)
                                    .textFieldStyle(TextInput())
                                HStack {
                                    
                                    Image(systemName: answer.points > 0 ? "checkmark.square.fill" : "checkmark.square")
                                        .foregroundColor(answer.points > 0 ? Color.green : Color.black)
                                        .onTapGesture {
                                            answer.points = 10
                                        }
                                    Image(systemName: answer.points == 0 ? "x.square.fill" : "x.square")
                                        .foregroundColor(answer.points == 0 ? Color.red : Color.black)
                                        .onTapGesture {
                                            answer.points = 0
                                        }
                                }
                                .font(.title3)
                                
                            }
                            .padding(.vertical, 2)
                            //                            .padding(.horizontal)
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
                Label("\(vm.remainingTime)", systemImage: "clock")
                    .font(.title2)
            }
            .frame(width: 120, height: 60)
            Spacer()
            Button {
                switch vm.gameType {
                case .single:
                    vm.endGame()
                case .peer:
                    mpvm.initiateEndGame()
                case .online:
                    break
                }
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.theme.red)
                    Image(systemName: "line.3.horizontal")
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
        .environmentObject(GameVM(yourName: "Sample"))
        .environmentObject(MultipeerVM(yourName: "Sample"))
}
