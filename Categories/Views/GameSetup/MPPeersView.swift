//
//  MPPeersView.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import SwiftUI

struct MPPeersView: View {
    @EnvironmentObject var mpvm: MultipeerVM
    @EnvironmentObject var vm: GameVM
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Available Players")
                    .font(.title2)
                if mpvm.availablePeers.isEmpty {
                    ProgressView()
                        .padding()
                }
                ForEach(mpvm.availablePeers, id: \.self) { peer in
                    HStack {
                        Text(peer.displayName)
                        Spacer()
                        if !mpvm.session.connectedPeers.contains(peer) {
                            Button("Connect") {
                                mpvm.invitePeer(peer: peer)
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            Button("Disconnect") {
                                mpvm.disconnectFromPeers()
                            }
                            .buttonStyle(.bordered)
                        }
                        
                    }
                }
            }
            
            Button("Start Game") {
                vm.players[0].isHost = true
                mpvm.initiateStartGame()
            }
            .buttonStyle(.borderedProminent)
            .disabled(mpvm.session.connectedPeers.count == 0)
            
        }
        .alert("Received invite from \(mpvm.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $mpvm.receivedInvite) {
            Button("Accept Invite") {
                mpvm.acceptInvite()
            }
            Button("Reject") {
                mpvm.declineInvite()
            }
        }
        .background(Color.theme.background)
        .onAppear {
            mpvm.setup(game: vm)
            mpvm.startAdvertisingAndBrowsing()
        }
        .onDisappear {
            mpvm.stopAdvertisingAndBrowsing()
            mpvm.disconnectFromPeers()
        }
    }
}

#Preview {
    MPPeersView()
        .environmentObject(GameVM(yourName: "test"))
        .environmentObject(MultipeerVM(yourName: "test"))
}
