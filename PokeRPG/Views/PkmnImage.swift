//
//  PkmnImage.swift
//  PokeRPG
//
//  Created by Alyzor on 10/06/2023.
//

import SwiftUI

struct PkmnImage: View {
    var imageLink = ""
    var front = true
    var dex = false
    var pad = false
    @State private var pokemonSprite = ""
    
    var body: some View {
        AsyncImage(url:URL(string: pokemonSprite), content: { image in
            if front {
                if dex {
                    image.resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(width:75,height:75,alignment: .leading)
                }else
                {
                    if pad{
                        image.resizable()
                            .aspectRatio(contentMode:.fill)
                            .frame(maxWidth:100,maxHeight:100)
                        
                    } else{
                image.resizable()
                    .aspectRatio(contentMode:.fit)
                    .frame(width:150,height:150,alignment: .leading)
                    }
                }
                
            }else
            {
                image.resizable()
                    .aspectRatio(contentMode:.fit)
                    .frame(width:150,height:150,alignment: .trailing)
            }
        }, placeholder:{
            EmptyView()
        })
            .onAppear{
                let alrLoaded = UserDefaults.standard.string(forKey: imageLink)
                
                if alrLoaded == nil {
                    getSprite(url: imageLink)
                    UserDefaults.standard.set(imageLink, forKey: imageLink)
                } else {
                    getSprite(url:alrLoaded!)
                }
            }
    }
    func getSprite(url: String){
        var tempSprite: String?
        
        PokeAPI().fetchPokemonData(SelUrl: url){
            sprite in
            if front == true{
                tempSprite = sprite.sprites.front_default
            }else{
                tempSprite = sprite.sprites.back_default
            }
            self.pokemonSprite = tempSprite ?? "placeholder"
        }
    }
}

struct PkmnImage_Previews: PreviewProvider {
    static var previews: some View {
        PkmnImage()
    }
}
