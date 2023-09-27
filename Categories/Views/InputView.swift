//
//  InputView.swift
//  Categories
//
//  Created by Steve on 21/09/2023.
//

import SwiftUI

struct InputView: View {
    
    let categories = [
        "Countries",
        "Desserts",
        "Movie Titles",
        "Types of Trees",
        "Board Games",
        "Superheroes",
        "Colors",
        "Types of Fish",
        "Types of Shoes",
        "Animals"
    ]
    
    let color = Color("myred")
    
    @State var inputText = ""
    
    var body: some View {
        
        ZStack {
            Image("background")
                .resizable()
//                .scaledToFit()
                .ignoresSafeArea()
                .brightness(-0.1)
            
            VStack{
            
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(color)
                        Text("J")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .frame(width: 70, height: 70)
                    
                    Spacer()
                    
                    ZStack {
                        Capsule()
                            .foregroundColor(color)
                        Label("01:12", systemImage: "clock")
                            .font(.title2)
                    }
                    .frame(width: 120, height: 60)
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(color)
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                    }
                    .frame(width: 70, height: 70)
                }
                .padding(.horizontal, 20)
                
                
                
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                        }
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                                .fontWeight(.semibold)
                                .padding(.top, 5)
                                .padding(.bottom, -5)
                            TextField("", text: $inputText)
                                .textFieldStyle(WhiteBorder())
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(color)
                )
                .padding(.horizontal, 20)
                .padding(.top)
                .padding(.bottom)
                
            }
        }

    }
}

#Preview {
    InputView()
}


struct WhiteBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 2)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.white, lineWidth:2)
                    .foregroundColor(Color("myred"))
                    .brightness(-0.15)
            )
    }
}
