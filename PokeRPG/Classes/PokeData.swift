//
//  PokeImage.swift
//  PokeRPG
//
//  Created by Alyzor on 10/06/2023.
//

import Foundation

struct PokeData: Codable {
    var sprites: PokemonSprites
}

struct PokemonSprites:Codable{
    var front_default: String
    var back_default: String
}

class PokeDataAPI{
    func fetchData(SelUrl: String, completion:@escaping(PokemonSprites) -> ()){
        guard let url = URL(string: SelUrl) else {
            return
        }
        URLSession.shared.dataTask(with:url) { (data, response,error) in
            guard let data = data else {return}
            
            let pokeSprite = try! JSONDecoder().decode(PokeData.self, from: data)
            
            DispatchQueue.main.async{
                completion(pokeSprite.sprites)
            }
        }.resume()
    }
}
