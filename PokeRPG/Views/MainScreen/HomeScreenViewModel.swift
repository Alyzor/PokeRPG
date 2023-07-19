//
//  HomeScreenViewModel.swift
//  PokeRPG
//
//  Created by Alyzor on 10/07/2023.
//

import Foundation
import UIKit
import SwiftUI

final class HomeScreenViewModel:ObservableObject{
    
    init(team:PokemonTeam, PC:PokemonTeam) {
        self.UserTeam = team
        self.userPC = PC
    }
    
    @Published var UserTeam:PokemonTeam = PokemonTeam()
    @Published var gotoBattle:Bool = false
    @Published var teamFainted = false
    @Published var botTeam:PokemonTeam = PokemonTeam()
    @Published var imgType = "png"
    @Published var healed = false
    @Published var healing = false
    @Published var selPkm = 0
    @Published var userBag:Bag = TeamUtils().getBag()
    @Published var userPC:PokemonTeam = PokemonTeam()
    @AppStorage("userWallet") var wallet = 0
    
    func checkFaint(){
        let group = DispatchGroup()
        for pkmn in UserTeam.Pkmn.indices{
            if UserTeam.Pkmn[pkmn].HP > 0{
                getOpponent(){ [self]team in
                    botTeam = team
                    selPkm = pkmn
                    gotoBattle = true
                }
                return
            }else{
                group.enter()
                group.leave()
            }
        }
        group.notify(queue:.main){[self] in
                teamFainted = true
        }
    }
    
    func getOpponent(completion:@escaping (PokemonTeam) -> ()){
        var oppTeam:PokemonTeam = PokemonTeam()
        let teamChance = Int.random(in:1...10)
        var lowestLvl = UserTeam.Pkmn[0].Lvl
        var selPkmn = Int.random(in: 1...151)
        print(teamChance)
        let group = DispatchGroup()
        group.enter()
        for i in UserTeam.Pkmn{
            if i.Lvl < lowestLvl{
                lowestLvl = i.Lvl
            }
        }
            SavePokemon().getPokemon(selectedPokemon: selPkmn, pokemonLevel: lowestLvl+1){team in
                    oppTeam.Pkmn.append(team)
                if teamChance == 3{
                    selPkmn = Int.random(in: 1...151)
                    SavePokemon().getPokemon(selectedPokemon: selPkmn, pokemonLevel: lowestLvl+1){team in
                            oppTeam.Pkmn.append(team)
                        group.leave()
                    }
                }else{
                    group.leave()
                }
            }
        group.notify(queue: .main){
            completion(oppTeam)
        }
    }
    
    func getHealImg() -> URL?{
        if imgType == "png"{
        return Bundle.main.url(forResource: "Heal", withExtension: "png")
        }else{
            return Bundle.main.url(forResource: "Heal", withExtension: "gif")
        }
    }
    
    func RunHeal(){
        wallet -= 5
        imgType = "gif"
        healing = true
        UserTeam = PokemonHeals().fullHealTeam(team: UserTeam)
        DispatchQueue.main.asyncAfter(deadline: .now() + 8){[self] in
            imgType = "png"
            TeamUtils().saveTeam(Team: UserTeam)
            healed = true
            healing = false
        }
    }
    
}
