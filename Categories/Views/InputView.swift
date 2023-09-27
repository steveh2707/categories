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
        
        ZStack {
            appBackground
            
            VStack{
                headingSection
                
                Text(vm.player.markee)

                ScrollView {
                    VStack(alignment: .leading) {
                        HStack { Spacer() }
                        ForEach($vm.player.answers) { $answer in
                            Text(answer.category)
                                .fontWeight(.semibold)
                                .padding(.top, 5)
                                .padding(.bottom, -5)
                            TextField("", text: $answer.text)
                                    .textFieldStyle(TextInput())
                            .padding(.vertical, 2)
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
            
            switch vm.gameType {
            case .single:
                vm.fetchCategoriesAndLetter()
            case .peer:
                if vm.player.isHost {
                    vm.fetchCategoriesAndLetter()
                    mpvm.sendCategoriesAndLetter()
                }
            case .online:
                if vm.player.isHost {
                    vm.fetchCategoriesAndLetter()
//                    gkvm.sendCategoriesAndLetter()
                }
            }
        }
        .onReceive(vm.countdownTimer) { _ in
            vm.remainingTime -= 1
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
                    ForEach(vm.otherPlayers) { player in
                        ZStack {
                            Circle()
                                .foregroundColor(.theme.red)
                            Text(player.name.prefix(2))
                        }
                        .frame(width: 30, height: 30)
                    }
                }
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
