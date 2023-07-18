//
//  SelectStarter.swift
//  PokeRPG
//
//  Created by Alyzor on 03/07/2023.
//

import SwiftUI

struct SelectStarter: View{
    @State var selectedPokemon = 0
    @State var buttonActive = true
    @State var goHome = false
    @State var imgLinks = ["https://pokeapi.co/api/v2/pokemon/1","https://pokeapi.co/api/v2/pokemon/4","https://pokeapi.co/api/v2/pokemon/7"]
    var body: some View{
        VStack{
            Button(action:{selectedPokemon = 1;buttonActive = false},label: {
                Spacer()
                HStack{
                    PkmnImage(imageLink:imgLinks[0], front:true).padding()
                    Text("Bulbasaur").foregroundColor(.white).padding()
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                    .background(.green)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray,lineWidth: self.selectedPokemon == 1 ? 3 : 0))
                Spacer()
            })
            Button(action:{selectedPokemon=4;buttonActive = false},label: {
                Spacer()
                HStack{
                    PkmnImage(imageLink:imgLinks[1], front:true).padding()
                    Text("Charmander").padding().foregroundColor(.white)
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                    .background(.red)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray,lineWidth: self.selectedPokemon == 4 ? 3 : 0))
                Spacer()
            })
            Button(action:{selectedPokemon=7;buttonActive = false},label: {
                Spacer()
                HStack{
                    PkmnImage(imageLink:imgLinks[2], front:true).padding()
                    Text("Squirtle").padding().foregroundColor(.white)
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                    .background(.blue)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray,lineWidth: self.selectedPokemon == 7 ? 3 : 0))
                Spacer()
            })
            Spacer()
            Button("Start your journey!"){
                var userBag = TeamUtils().getBag()
                let allItems = GetItems()
                allItems.forEach{item in
                    if (item.name == "PokéBall" || item.name == "Potion") {
                        let sendItem = bagItems(item:item, amount:5)
                        userBag.items.append(sendItem)
                    }else{
                        let sendItem = bagItems(item:item, amount:0)
                        userBag.items.append(sendItem)
                    }
                }
                TeamUtils().saveBag(userBag:userBag)
                SavePokemon().getPokemon(selectedPokemon:selectedPokemon, pokemonLevel: 5){pokemon in
                    var userTeam:PokemonTeam = TeamUtils().getTeam()
                    userTeam.Pkmn.append(pokemon)
                    TeamUtils().saveTeam(Team: userTeam)
                    goHome = true
                }
            }.disabled(buttonActive).buttonStyle(.borderedProminent)
                .accentColor(.red)
        }
        Spacer()
        NavigationLink("", destination:HomeScreen(), isActive:$goHome)
    }
}


struct SelectStarter_Previews: PreviewProvider {
    static var previews: some View {
        SelectStarter()
    }
}
