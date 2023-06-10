//
//  PokeAPI.swift
//  PokeRPG
//
//  Created by Alyzor on 10/06/2023.
//

import Foundation

struct PokemonResults:Codable{
    var results:[PokemonEntry]
}

struct PokemonEntry:Codable, Identifiable{
    let id = UUID()
    var name:String
    var url:String
}

class PokeAPI{
    func fetchData(completion:@escaping([PokemonEntry]) -> ()){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            return
        }
        URLSession.shared.dataTask(with:url) { (data, response,error) in
            guard let data = data else {return}
            
            let pokeList = try! JSONDecoder().decode(PokemonResults.self, from: data)
            
            DispatchQueue.main.async{
                completion(pokeList.results)
            }
        }.resume()
    }
}
