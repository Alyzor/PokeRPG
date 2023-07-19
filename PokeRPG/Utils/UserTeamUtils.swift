//
//  UDefControl.swift
//  PokeRPG
//
//  Created by Alyzor on 13/06/2023.
//

import Foundation
// IMPORTANT INFO
//          User's team is set in userTeam
class TeamUtils{
    
    //saves team to JSON file
    
    func saveTeam(Team:PokemonTeam){
        let defaults = UserDefaults.standard
        let saveTeam = try? JSONEncoder().encode(Team)
        defaults.set(saveTeam, forKey: "userTeam")
    }
    
    //fetches team from UserDefaults, saved in a JSON file
    func getUserPC() -> PokemonTeam{
        let defaults = UserDefaults.standard
        
        let existingTeam = defaults.object(forKey: "userPC") as? Data ?? Data()
        
        if let Team = try? JSONDecoder().decode(PokemonTeam.self, from: existingTeam){
            return Team
        }else{
            return PokemonTeam()
        }
    }
    
    func saveUserPC(Team:PokemonTeam){
        let defaults = UserDefaults.standard
        let saveTeam = try? JSONEncoder().encode(Team)
        defaults.set(saveTeam, forKey: "userPC")
    }
        
    func getTeam()-> PokemonTeam{
        let defaults = UserDefaults.standard
        
        let existingTeam = defaults.object(forKey: "userTeam") as? Data ?? Data()
        
        if let Team = try? JSONDecoder().decode(PokemonTeam.self, from: existingTeam){
            return Team
        }else{
            return PokemonTeam()
        }
    }
    
    
    func getBag()-> Bag{
        let defaults = UserDefaults.standard
        
        let existingBag = defaults.object(forKey: "userBag") as? Data ?? Data()
        
        if let bag = try? JSONDecoder().decode(Bag.self, from: existingBag){
            return bag
        }else{
            return Bag()
        }
    }
    
    func saveBag(userBag:Bag){
        let defaults = UserDefaults.standard
        let saveBag = try? JSONEncoder().encode(userBag)
        defaults.set(saveBag, forKey: "userBag")
    }
    
    func deleteSave(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userTeam")
        defaults.removeObject(forKey: "userBag")
    }
    
}
