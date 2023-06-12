//
//  PokeList.swift
//  PokeRPG
//
//  Created by Alyzor on 10/06/2023.
//

import SwiftUI
struct PokeList: View {
    @State var pokeList = [PokemonEntry]()
   @State var filterText = ""
    var body: some View {
        NavigationView{
            List{
                ForEach(filterText == "" ? pokeList: pokeList.filter( {
                    $0.name.contains(filterText.lowercased())} ))
                { entry in
                    HStack{
                        PkmnImage(imageLink: entry.url, front: true, dex:true).frame(maxWidth:75,maxHeight: 75)
                        NavigationLink("\(entry.name.capitalized)", destination:ListDetail(Surl:entry.url))
                    }
                    
                }
            }.onAppear{
                PokeAPI().fetchData(){ pokemon in
                    self.pokeList = pokemon
                }
            }
        }
    }
}

struct PokeList_Previews: PreviewProvider {
    static var previews: some View {
        PokeList()
    }
}
