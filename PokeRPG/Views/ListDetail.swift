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
        HStack{
            Text("\(Pkmn.name.capitalized)'s Stats: ")
            ForEach(Pkmn.stats){stat in
                Text(stat.stat.name.capitalized + " : " + String(stat.base_stat))
            }
                
            }.onAppear{
                PokeDataAPI().fetchData(SelUrl: Surl){ pokemon in
                    Pkmn = pokemon
            }
        }
        }}
struct ListDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListDetail()
    }
}
