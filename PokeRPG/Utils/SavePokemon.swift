//
//  HomeScreenViewModel.swift
//  PokeRPG
//
//  Created by Alyzor on 03/07/2023.
//

import Foundation
import SwiftUI

final class SavePokemon{
    func getPokemon(selectedPokemon:Int, pokemonLevel:Int, completion:@escaping (Pokemon) -> ()){
        var startTeam = Pokemon()
        PokeAPI().fetchPokemonData(SelUrl:"https://pokeapi.co/api/v2/pokemon/\(String(selectedPokemon))/"){ pokemon in
            startTeam.Nome = pokemon.name.capitalized
            startTeam.Lvl = pokemonLevel
            startTeam.dexNumber = pokemon.id
            startTeam.type1 = pokemon.types![0].type.name
            startTeam.Sprites = pokemon.sprites
            startTeam.imgURL = "https://pokeapi.co/api/v2/pokemon/\(String(selectedPokemon))/"
            startTeam.xpWon = pokemon.base_experience
            startTeam.currentXP = Int(pow(Double(pokemonLevel-1), Double(3)))
            startTeam.allMoves = pokemon.moves
            
            startTeam.IVs.HP = Int.random(in: 0...15)
            startTeam.IVs.ATK = Int.random(in: 0...15)
            startTeam.IVs.DEF = Int.random(in: 0...15)
            startTeam.IVs.spATK = Int.random(in: 0...15)
            startTeam.IVs.spDEF = Int.random(in: 0...15)
            startTeam.IVs.SPD = Int.random(in: 0...15)
            
            
            if pokemon.types!.count == 2{
                startTeam.type2 = pokemon.types![1].type.name
            }
            //get Pokemon stats
            for pStat in pokemon.stats {
                switch pStat.stat.name{
                case "hp":
                    startTeam.SpeciesStats.HP = pStat.base_stat
                case "attack":
                    startTeam.SpeciesStats.ATK = pStat.base_stat
                case "defense":
                    startTeam.SpeciesStats.DEF = pStat.base_stat
                case "special-attack":
                    startTeam.SpeciesStats.spATK = pStat.base_stat
                case "special-defense":
                    startTeam.SpeciesStats.spDEF = pStat.base_stat
                default:
                    startTeam.SpeciesStats.SPD = pStat.base_stat
                }
            }
            //get Moves
            let group = DispatchGroup()
            let bgQueue = DispatchQueue.global()
            for mv in pokemon.moves{
                var selMove = Moves()
                if mv.version_group_details[0].move_learn_method.name != "level-up"{
                    continue }
                if mv.version_group_details[0].level_learned_at > pokemonLevel{
                    continue }
                selMove.Name = mv.move.name
                group.enter()
                bgQueue.async(group: group,  execute: {
                PokeAPI().fetchMoveData(MoveURL:mv.move.url){fetchedMove in
                    if fetchedMove.generation.name == "generation-i"{
                    if fetchedMove.power != nil{
                        selMove.Power = fetchedMove.power!}
                    selMove.pType = fetchedMove.type.name
                        if fetchedMove.accuracy != nil{
                    selMove.acc = fetchedMove.accuracy!
                        }
                    selMove.pp = fetchedMove.pp
                    selMove.maxPP = fetchedMove.pp
                    selMove.dmgOrBuff = fetchedMove.damage_class.name
                    if !fetchedMove.stat_changes.isEmpty{
                        selMove.statusDetails.statChange = fetchedMove.stat_changes[0].change
                        selMove.statusDetails.statInflicted = fetchedMove.stat_changes[0].stat.name
                        selMove.statusDetails.target = fetchedMove.target.name
                    }
                        selMove.ailment = fetchedMove.meta.ailment.name
                        selMove.ailmentChance = fetchedMove.meta.ailment_chance
                        selMove.category = fetchedMove.meta.category.name
                        selMove.healing = fetchedMove.meta.healing
                        selMove.drain = fetchedMove.meta.drain
                        selMove.max_hits = fetchedMove.meta.max_hits ?? 0
                        selMove.min_hits = fetchedMove.meta.min_hits ?? 0
                        selMove.max_turns = fetchedMove.meta.max_turns ?? 0
                        selMove.min_turns = fetchedMove.meta.min_turns ?? 0
                        if startTeam.MoveList.count <= 3{
                    startTeam.MoveList.append(selMove)
                    print("added move \(selMove.Name) \(startTeam.MoveList.count)")
                        }
                        group.leave()
                    }else{
                        group.leave()
                    }
                }
                })
            }
            group.notify(queue: DispatchQueue.main) {
                var sendPokemon = self.calcStats(sentPokemon: startTeam)
                sendPokemon = PokemonHeals().fullHealSingle(pokemon: sendPokemon)
                completion(sendPokemon)
                }
        }
    }
    
    func calcStats(sentPokemon:Pokemon) -> Pokemon{
        var c1:Int = 0
        var c2:Int = 0
        var c3:Int = 0
        var pokemon = sentPokemon
        
        //HP
        c1 = (pokemon.SpeciesStats.HP + pokemon.IVs.HP) * 2
        c2 = (Int(sqrt(Double(pokemon.StatExp.HP)))/4) * pokemon.Lvl
        c3 = ((c1+c2)/100) + pokemon.Lvl + 10
        
        pokemon.permaStats.HP = c3
        c1=0
        c2=0
        c3=0
        
        //DEF
        c1 = (pokemon.SpeciesStats.DEF + pokemon.IVs.DEF) * 2
        c2 = (Int(sqrt(Double(pokemon.StatExp.DEF)))/4) * pokemon.Lvl
        c3 = ((c1+c2)/100) + 5
        
        pokemon.DEF = c3
        pokemon.permaStats.DEF = c3
        c1=0
        c2=0
        c3=0
        
        //ATK
        c1 = (pokemon.SpeciesStats.ATK + pokemon.IVs.ATK) * 2
        c2 = (Int(sqrt(Double(pokemon.StatExp.ATK)))/4) * pokemon.Lvl
        c3 = ((c1+c2)/100) + 5
        
        pokemon.ATK = c3
        pokemon.permaStats.ATK = c3
        c1=0
        c2=0
        c3=0
        
        //SPD
        c1 = (pokemon.SpeciesStats.SPD + pokemon.IVs.SPD) * 2
        c2 = (Int(sqrt(Double(pokemon.StatExp.SPD)))/4) * pokemon.Lvl
        c3 = ((c1+c2)/100) + 5
        
        pokemon.SPD = c3
        pokemon.permaStats.SPD = c3
        c1=0
        c2=0
        c3=0
        
        //spATK
        c1 = (pokemon.SpeciesStats.spATK + pokemon.IVs.spATK) * 2
        c2 = (Int(sqrt(Double(pokemon.StatExp.spATK)))/4) * pokemon.Lvl
        c3 = ((c1+c2)/100) + 5
        
        pokemon.spATK = c3
        pokemon.permaStats.spATK = c3
        c1=0
        c2=0
        c3=0
        
        //spDEF
        c1 = (pokemon.SpeciesStats.spDEF + pokemon.IVs.spDEF) * 2
        c2 = (Int(sqrt(Double(pokemon.StatExp.spDEF)))/4) * pokemon.Lvl
        c3 = ((c1+c2)/100) + 5
        
        pokemon.spDEF = c3
        pokemon.permaStats.spDEF = c3
        c1=0
        c2=0
        c3=0
        
        return pokemon
    }
}
