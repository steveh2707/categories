//
//  MPConnectionManager.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import Foundation
import MultipeerConnectivity

extension String {
    static var serviceName = "CategoriesGame"
}

//@MainActor
class MultipeerVM: NSObject, ObservableObject {
    let serviceType = String.serviceName
    let session: MCSession
    let myPeerId: MCPeerID
    let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    let nearbyServiceBrowser: MCNearbyServiceBrowser
    var game: GameVM?
    
    @MainActor
    func setup(game: GameVM) {
        self.game = game
    }
    
    @Published var availablePeers = [MCPeerID]()
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    @Published var paired: Bool = false
    
    init(yourName: String) {
        myPeerId = MCPeerID(displayName: yourName)
        session = MCSession(peer: myPeerId)
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        super.init()
        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }
    
    deinit {
        stopAdvertisingAndBrowsing()
    }
    
    func startAdvertisingAndBrowsing() {
        nearbyServiceAdvertiser.startAdvertisingPeer()
        nearbyServiceBrowser.startBrowsingForPeers()
    }
    
    func stopAdvertisingAndBrowsing() {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
        nearbyServiceBrowser.stopBrowsingForPeers()
    }
    
    
    func invitePeer(peer: MCPeerID) {
        nearbyServiceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: 30)
    }
    
    
    func acceptInvite() {
        if let invitationHandler = invitationHandler {
            invitationHandler(true, session)
        }
    }
    
    func declineInvite() {
        if let invitationHandler = invitationHandler {
            invitationHandler(false, nil)
        }
    }
    
    func disconnectFromPeers() {
        self.paired = false
        self.session.disconnect()
    }
    
    @MainActor
    func initiateStartGame() {
        game?.player.isHost = true
        let gameMove = GameMove(action: .start)
        sendMove(gameMove: gameMove)
        startGame()
    }
    
    @MainActor
    private func startGame() {
        self.stopAdvertisingAndBrowsing()
        for player in session.connectedPeers {
            game?.otherPlayers.append(Player(name: player.displayName))
        }
        assignMarkersAndMarkees()

        game?.startGame()
    }
    
    private func assignMarkersAndMarkees() {
        // logic to let host decide who marks whos answers
        if let isHost = game?.player.isHost, isHost {
            if let otherPlayers = game?.otherPlayers, let me = game?.player {
                var allPlayers = otherPlayers
                allPlayers.append(me)
                
                // assign markers and markees
                var markers = [GameMove.Marker]()
                for i in 0...allPlayers.count-1 {
                    markers.append(GameMove.Marker(marker: allPlayers[i].name, markee: allPlayers[(i+1)%allPlayers.count].name))
                }
                
                assignOwnMarkee(markers: markers)
                
                // send markers array to other players
                let gameMove = GameMove(action: .markers, markers: markers)
                sendMove(gameMove: gameMove)
            }
        }
    }
    
    private func assignOwnMarkee(markers: [GameMove.Marker]) {
        // assign own markee
        for marker in markers {
            if marker.marker == game?.player.name {
                game?.player.markee = marker.markee
            }
        }
    }

    
    @MainActor
    func initiateEndGame() {
        let gameMove = GameMove(action: .end)
        sendMove(gameMove: gameMove)
        endGame()
    }
    
    @MainActor
    private func endGame() {
        game?.player.isHost = false
        game?.endGame()
    }
    
    //    @MainActor
    //    func initiatePlayAgain() {
    //        let gameMove = GameMove(action: .reset)
    //        sendMove(gameMove: gameMove)
    //        game?.resetGame()
    //    }
    //
    //    @MainActor
    //    func initiateEndGame() {
    //        let gameMove = GameMove(action: .end)
    //        sendMove(gameMove: gameMove)
    //        endGame()
    //    }
    //
    //    @MainActor
    //    func initiateGoToNextQuestion() {
    //        let gameMove = GameMove(action: .next)
    //        sendMove(gameMove: gameMove)
    //        game?.goToNextQuestion()
    //    }
    //
    //
    //    @MainActor
    //    private func endGame() {
    //        self.paired = false
    //        self.session.disconnect()
    //        game?.endGame()
    //    }
    
    
    func sendMove(gameMove: GameMove) {
        if !session.connectedPeers.isEmpty {
            do {
                if let data = gameMove.data() {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                }
            } catch {
                print("error sending \(error.localizedDescription)")
            }
        }
    }
    
    func sendCategoriesAndLetter() {
        let gameMove = GameMove(action: .categories, categories: game?.categories, letter: game?.selectedLetter)
        sendMove(gameMove: gameMove)
    }
    
    func sendAnswersToBeMarked(answers: [Answer]) {
        let gameMove = GameMove(action: .sendAnswers, playerName: myPeerId.displayName, answers: answers)
        sendMove(gameMove: gameMove)
    }
    
    
    @MainActor
    func handleReceivedMoves(gameMove: GameMove) {
        switch gameMove.action {
        case .start:
            self.game?.player.isHost = false
            self.startGame()
        case .categories:
            if let categories = gameMove.categories, let letter = gameMove.letter {
                self.game?.setCategoriesAndLetter(categories: categories, letter: letter)
            }
        case .markers:
            if let markers = gameMove.markers {
                assignOwnMarkee(markers: markers)
            }
        case .sendAnswers:
            if let answers = gameMove.answers, let name = gameMove.playerName {
                let i = self.game?.findIndexOfPlayer(name: name)
                if let i, i > -1 {
                    self.game?.otherPlayers[i].answers = answers
                }
            }
        case .next:
            //            self.game?.goToNextQuestion()
            break
        case .reset:
            //            self.game?.resetGame()
            break
        case .end:
            self.endGame()
            break
        }
    }
}

// Add and remove local peers from availablePeers array
extension MultipeerVM: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if !self.availablePeers.contains(peerID) {
                self.availablePeers.append(peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = availablePeers.firstIndex(of: peerID) else { return }
        DispatchQueue.main.async {
            if index < self.availablePeers.count {
                self.availablePeers.remove(at: index)
            }
        }
    }
}

// handle received invites
extension MultipeerVM: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.receivedInvite = true
            self.receivedInviteFrom = peerID
            self.invitationHandler = invitationHandler
        }
    }
}

// handle connection and received moves
extension MultipeerVM: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            DispatchQueue.main.async {
                self.paired = false
                self.game?.playing = false
            }
        case .connected:
            DispatchQueue.main.async {
                self.paired = true
            }
        default:
            DispatchQueue.main.async {
                self.paired = false
                self.game?.playing = false
            }
        }
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        if let gameMove = try? JSONDecoder().decode(GameMove.self, from: data) {
            DispatchQueue.main.async {
                self.handleReceivedMoves(gameMove: gameMove)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    
}
