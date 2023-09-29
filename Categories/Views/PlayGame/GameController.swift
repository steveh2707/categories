//
//  ShowInputOrEndView.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import SwiftUI

struct GameController: View {
    @EnvironmentObject var vm: GameVM
    @EnvironmentObject var mpvm: MultipeerVM
    
    var body: some View {
        NavigationStack {
            
            switch vm.screen {
            case .inputView:
                InputView()
            case .markingView:
                MarkingView()
            case .nextRoundView:
                NextRoundView()
            }
            
        }
    }
}
    


//#Preview {
//    ShowInputOrEndView()
//        .environmentObject(GameVM(yourName: "test"))
//}
