//
//  FrontPage.swift
//  Categories
//
//  Created by Steve on 22/09/2023.
//

import SwiftUI

struct FrontPage: View {
    @AppStorage("yourName") var yourName = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text(gameTitle)
                    .font(.title)
                Spacer()
                Text("This is the name that will be associated with this device")
                    .multilineTextAlignment(.center)
                TextField("Your Name", text: $yourName)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .padding()
                NavigationLink("Play") {
                    GameSetupView(yourName: yourName)
                }
                .buttonStyle(.borderedProminent)
                .disabled(yourName.isEmpty)
                Spacer()
            }
            .padding()
//            .navigationTitle(gameTitle)
            .background(
//                appBackground.ignoresSafeArea()
            )
        }
    }
    
}

#Preview {
    FrontPage()
}
