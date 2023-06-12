//
//  PokeImage.swift
//  PokeRPG
//
//  Created by Alyzor on 10/06/2023.
//

import Foundation

struct PokeData: Codable {
    var name:String = ""
    var sprites: PokemonSprites = PokemonSprites()
    var stats:[PokemonStats] = [PokemonStats]()
}

struct PokemonStats:Codable, Identifiable{
    let id = UUID()
    var base_stat:Int = 0
    var stat:PokemonStatsD = PokemonStatsD()
}
struct PokemonStatsD:Codable{
    var name:String = ""
}
struct PokemonSprites:Codable{
    var front_default: String = ""
    var back_default: String = ""
}

class PokeDataAPI{
    func fetchData(SelUrl: String, completion:@escaping(PokeData) -> ()){
        guard let url = URL(string: SelUrl) else {
            return
        }
        URLSession.shared.dataTask(with:url) { (data, response,error) in
            guard let data = data else {return}
            
            let pokeSprite = try! JSONDecoder().decode(PokeData.self, from: data)
            
            DispatchQueue.main.async{
                completion(pokeSprite)
            }
        }.resume()
    }
}
