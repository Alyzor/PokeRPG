//
//  ListDetail.swift
//  PokeRPG
//
//  Created by Alyzor on 11/06/2023.
//

import SwiftUI


struct ListDetail: View {
    var Surl = ""
    @State var Pkmn:PokeData = PokeData()
    var body: some View {
        VStack{
            HStack{
                PkmnImage(imageLink: Surl, front: true)
                HStack{
                    VStack(alignment: .leading) {
                        ForEach(Pkmn.stats, id:\.self) {stats in
                            Text(stats.stat.name + " : " + String(stats.base_stat))
                        }
                    }
                }
            }
                Spacer()
            }.onAppear{
                PokeAPI().fetchPokemonData(SelUrl: Surl){ pokemon in
                    Pkmn = pokemon
                    
            }
        }
        }}
struct ListDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListDetail()
    }
}
