//
//  PokeList.swift
//  PokeRPG
//
//  Created by Alyzor on 10/06/2023.
//

import SwiftUI
struct PokeList: View {
    @State var pokeList = [namedResourceURL]()
   @State var filterText = ""
    var body: some View {
        NavigationView{
            List{
                ForEach(pokeList, id:\.self){ entry in
                    HStack{
                        PkmnImage(imageLink: entry.url, front: true, dex:true).frame(maxWidth:75,maxHeight: 75)
                        NavigationLink("\(entry.name.capitalized)", destination:ListDetail(Surl:entry.url).navigationTitle("\(entry.name.capitalized)'s Stats: "))
                    }
                    
                }
            }.onAppear{
                PokeAPI().fetchDexData(){ pokemon in
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
