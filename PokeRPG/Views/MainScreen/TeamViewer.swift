//
//  TeamViewer.swift
//  PokeRPG
//
//  Created by Alyzor on 14/07/2023.
//

import SwiftUI

struct TeamViewer: View {
    @StateObject var vModel = HomeScreenViewModel(team:PokemonTeam(),PC:PokemonTeam())
    var body: some View {
        VStack(spacing:0){
            Header()
            NavigationView{
                List{
                    ForEach(vModel.UserTeam.Pkmn.indices, id:\.self){p in
                        HStack{
                            PkmnImage(imageLink: self.vModel.UserTeam.Pkmn[p].imgURL, front: true, dex: false,pad:true)
                            NavigationLink(self.vModel.UserTeam.Pkmn[p].Nome.capitalized, destination:PokemonTeamDetails(selPkmn: self.vModel.UserTeam.Pkmn[p]))
                            }
                        .swipeActions(allowsFullSwipe:false) {
                        Button{
                            self.vModel.userPC.Pkmn.append(vModel.UserTeam.Pkmn[p])
                            self.vModel.UserTeam.Pkmn.remove(at: p)
                            TeamUtils().saveTeam(Team: self.vModel.UserTeam)
                            TeamUtils().saveUserPC(Team: self.vModel.userPC)
                        } label: {
                            Image(systemName: "arrow.up")
                            Text("Send Pokemon to PC")
                        }.tint(.blue).disabled(vModel.UserTeam.Pkmn.count == 1)
                        }
                    }
                }.navigationTitle("Your Team")
            }
            Spacer()
        }
    }
}

struct TeamViewer_Previews: PreviewProvider {
    static var previews: some View {
        TeamViewer()
    }
}
