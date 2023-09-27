//
//  InputView.swift
//  Categories
//
//  Created by Steve on 21/09/2023.
//

import SwiftUI

struct InputView: View {
    @EnvironmentObject var vm: GameVM
    @EnvironmentObject var mpvm: MultipeerVM
    
    var body: some View {
        
        ScrollView {
            
            headingSection
            
            VStack(alignment: .leading) {
                HStack { Spacer() }
                ForEach($vm.players[0].answers) { $answer in
                    Text(answer.category)
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                        .padding(.bottom, -5)
                    TextField("", text: $answer.text)
                        .textFieldStyle(TextInput())
                        .autocorrectionDisabled()
                    
                        .padding(.vertical, 2)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.theme.red)
            )
        }
        .scrollIndicators(.hidden)
        
        .padding(.horizontal, 20)
        .background(
            appBackground
                .ignoresSafeArea(.keyboard, edges: .all)
        )
        .onAppear {
            
            switch vm.gameType {
            case .single:
                vm.fetchCategoriesAndLetter()
            case .peer:
                if vm.players[0].isHost {
                    vm.fetchCategoriesAndLetter()
                    mpvm.sendCategoriesAndLetter()
                }
            case .online:
                if vm.players[0].isHost {
                    vm.fetchCategoriesAndLetter()
                    //                    gkvm.sendCategoriesAndLetter()
                }
            }
        }
        .onReceive(vm.countdownTimer) { _ in
            vm.remainingTime -= 1
            if vm.remainingTime <= 0 {
                switch vm.gameType {
                case .single:
                    vm.screen = .nextRoundView
                case .peer:
                    mpvm.sendAnswersToBeMarked(answers: vm.players[0].answers)
                    vm.screen = .markingView
                case .online:
                    break
                }
            }
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
            
            VStack {
                HStack {
                    ForEach(vm.players) { player in
                        ZStack {
                            Circle()
                                .foregroundColor(.theme.red)
                            Text(player.name.prefix(2))
                        }
                        .frame(width: 30, height: 30)
                    }
                }
                .padding(.bottom, -5)
                ZStack {
                    Capsule()
                        .foregroundColor(.theme.red)
                    Label("\(vm.remainingTime)", systemImage: "clock")
                        .font(.title2)
                }
                .frame(width: 100, height: 40)
            }
            
            Spacer()
            Button {
                switch vm.gameType {
                case .single:
                    vm.closeGame()
                case .peer:
//                    mpvm.initiateCloseGame()
                    break
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

    }
    
    
    
}

#Preview {
    InputView()
        .environmentObject(GameVM(yourName: "Sample"))
}


struct TextInput: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        //            .padding(.vertical, 2)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 10)
                //                    .stroke(Color.white, lineWidth:2)
                    .foregroundColor(.theme.red)
                    .brightness(-0.15)
            )
    }
}
