//
//  PokeAPI.swift
//  PokeRPG
//
//  Created by Alyzor on 10/06/2023.
//

import Foundation

class PokeAPI{
    func fetchDexData(completion:@escaping([namedResourceURL]) -> ()){
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
    
    func fetchPokemonData(SelUrl: String, completion:@escaping(PokeData) -> ()){
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
    
    func fetchMoveData(MoveURL: String, completion:@escaping(DMove) -> ()){
        guard let url = URL(string: MoveURL) else { return }
        URLSession.shared.dataTask(with:url) { (data, response, error)in
            guard let data = data else {return}
            
            let moveData = try! JSONDecoder().decode(DMove.self, from:data)
            
            DispatchQueue.main.async{
                completion(moveData)
            }
        }.resume()
    }
}
