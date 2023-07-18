//
//  TeamViewer.swift
//  PokeRPG
//
//  Created by Alyzor on 14/07/2023.
//

import SwiftUI

struct TeamViewer: View {
    @StateObject var vModel = HomeScreenViewModel(team:PokemonTeam())
    var body: some View {
        VStack(spacing:0){
            Header()
            NavigationView{
                List{
                    ForEach(vModel.UserTeam.Pkmn){pokemon in
                        HStack{
                            PkmnImage(imageLink: pokemon.imgURL, front: true, dex: false,pad:true)
                            NavigationLink(pokemon.Nome.capitalized, destination:PokemonTeamDetails(selPkmn: pokemon))
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
