//
//  UserPC.swift
//  PokeRPG
//
//  Created by Alyzor on 19/07/2023.
//

import SwiftUI

struct UserPC: View {
    @StateObject var vModel = HomeScreenViewModel(team:PokemonTeam(),PC:PokemonTeam())
    @State var switchPokemon = false
    var body: some View {
        VStack(spacing:0){
            NavigationView{
                List{
                    ForEach(vModel.userPC.Pkmn.indices, id:\.self){p in
                        HStack{
                            PkmnImage(imageLink: self.vModel.userPC.Pkmn[p].imgURL, front: true, dex: false,pad:true)
                            NavigationLink(self.vModel.userPC.Pkmn[p].Nome.capitalized, destination:PokemonTeamDetails(selPkmn: self.vModel.userPC.Pkmn[p]))
                            }
                        .swipeActions(allowsFullSwipe:false) {
                        Button{
                            if self.vModel.UserTeam.Pkmn.count == 6{
                                switchPokemon = true
                            }
                            else
                            {
                                self.vModel.UserTeam.Pkmn.append(vModel.userPC.Pkmn[p])
                                self.vModel.userPC.Pkmn.remove(at: p)
                                TeamUtils().saveUserPC(Team: self.vModel.userPC)
                                TeamUtils().saveTeam(Team: self.vModel.UserTeam)
                            }
                        } label: {
                            Image(systemName: "arrow.up")
                            Text("Send Pokemon to Team")
                        }.tint(.blue)
                        }
                    }
                }
            }
            Spacer()
            NavigationLink("", destination: EmptyView(), isActive: $switchPokemon)
        }.navigationTitle("Your Team")
    }
}

struct SwitchPC:View{
    @StateObject var vModel = HomeScreenViewModel(team:PokemonTeam(),PC:PokemonTeam())
    @State var pokemon = Pokemon()
    var body: some View{
        VStack(spacing:0){
            NavigationView{
                List{
                    ForEach(vModel.UserTeam.Pkmn.indices, id:\.self){p in
                        HStack{
                            PkmnImage(imageLink: self.vModel.UserTeam.Pkmn[p].imgURL, front: true, dex: false,pad:true)
                            NavigationLink(self.vModel.UserTeam.Pkmn[p].Nome.capitalized, destination:PokemonTeamDetails(selPkmn: self.vModel.UserTeam.Pkmn[p]))
                            }
                        .swipeActions(allowsFullSwipe:false) {
                        Button{
                            self.vModel.UserTeam.Pkmn.remove(at: p)
                            self.vModel.UserTeam.Pkmn.append(pokemon)
                            self.vModel.userPC.Pkmn.remove(at: p)
                            TeamUtils().saveTeam(Team: self.vModel.UserTeam)
                            TeamUtils().saveUserPC(Team: self.vModel.userPC)
                        } label: {
                            Image(systemName: "arrow.up")
                            Text("Send Pokemon to Team")
                        }.tint(.blue)
                        }
                    }
                }
            }
            Spacer()
        }.navigationTitle("Your Team")
    }
}

struct UserPC_Previews: PreviewProvider {
    static var previews: some View {
        UserPC()
    }
}
