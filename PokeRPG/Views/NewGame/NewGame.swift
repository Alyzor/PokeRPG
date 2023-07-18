//
//  NewGame.swift
//  PokeRPG
//
//  Created by Alyzor on 12/06/2023.
//

import SwiftUI

struct NewGame: View {
    @State var introText = "Hello there! Welcome to the world of Pokémon!"
    @State var textChanger = 0
    @State var image = "pkmnIntroIMG"
    @State var gotoCreate = false
    
    var body: some View {
        VStack{
            Spacer()
            Image(image).resizable().scaledToFill().frame(width:200,height:300)
            Spacer()
            VStack{
                Text(introText).padding()
            }.background(.teal).cornerRadius(15)
            Spacer()
            Button("Continue"){
                textChanger += 1
                switch textChanger{
                case 1:
                    introText = "My name is Oak! People call me the Pokémon Prof! \nThis world... "
                case 2:
                    introText = "is inhabited by creatures called Pokémon! For some people, Pokémon are pets. Other use them for fights."
                    image = "pkmnIntroIMG2"
                case 3:
                    introText = "People and Pokémon live together by supporting each other."
                case 4:
                    introText = " Some people play with Pokémon, some battle with them. But we don't know everything about Pokémon yet."
                case 5:
                    image = "pkmnIntroIMG"
                introText = "There are still many mysteries to solve. That's why I study Pokémon every day."
                case 6:
                    introText = "Enough about me, let's get to know you! \nSo..."
                default:
                    gotoCreate = true
                }
            }.buttonStyle(.borderedProminent).accentColor(.red)
            Spacer()
        }
        NavigationLink("", destination: CreateUser(), isActive: $gotoCreate)
    }
}

struct NewGame_Previews: PreviewProvider {
    static var previews: some View {
        NewGame()
    }
}
