//
//  GameSetupView.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import SwiftUI

struct GameSetupView: View {
    @AppStorage("yourName") var yourName = ""
    @StateObject var vm: GameVM
    @StateObject var mpvm: MultipeerVM
    
    init(yourName: String) {
        self.yourName = yourName
        self._vm = StateObject(wrappedValue: GameVM(yourName: yourName))
        self._mpvm = StateObject(wrappedValue: MultipeerVM(yourName: yourName))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "brain")
                    .foregroundColor(.theme.accent)
                    .font(.system(size: 50))
                    .padding(.top)
                Text(gameTitle)
//                    .accentTitle()
                
                Picker("Select Game", selection: $vm.gameType) {
                    Text("Single").tag(GameType.single)
                    Text("Local").tag(GameType.peer)
                    Text("Online").tag(GameType.online)
                }
                .pickerStyle(.segmented)
                .padding()

                Text(vm.gameType.description)
//                    .foregroundColor(.theme.secondaryText)
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                VStack {
                    switch vm.gameType {
                    case .single:
                        Spacer()
                        Button("Start Game") {
                            vm.startGame()
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    case .peer:
                        MPPeersView()
                            .environmentObject(vm)
                            .environmentObject(mpvm)
                    case .online:
                        EmptyView()
//                        GKPeersView(startGame: $gameVM.playing)
//                            .environmentObject(gkConnectionManager)
//                            .environmentObject(gameVM)
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .frame(width: 350)


                Spacer()
                Text("Your name is \(yourName)")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.theme.background)
            .fullScreenCover(isPresented: $vm.playing) {
                ShowInputOrEndView()
                    .environmentObject(vm)
                    .environmentObject(mpvm)
//                    .environmentObject(gkvm)
            }
        }
    }
}

#Preview {
    GameSetupView(yourName: "Test")
}
