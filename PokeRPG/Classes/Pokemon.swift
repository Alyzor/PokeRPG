//
//  Pokemon.swift
//  PokeRPG
//
//  Created by Account1 on 07/06/2023.
//

import Foundation

struct PokemonTeam: Codable {
    var Pkmn:[Pokemon] = [Pokemon]()
}

struct PokeData: Codable {
    var name:String = ""
    var id = 0
    var sprites: PokemonSprites = PokemonSprites()
    var stats:[PokemonStats] = [PokemonStats]()
    var types:[PokemonTypes]? = [PokemonTypes]()
    var moves:[PokemonMoves] = [PokemonMoves]()
    var base_experience: Int = 0
}

struct PokemonMoves:Codable{
    var move:namedResourceURL = namedResourceURL()
    var version_group_details:[PkmGroupDetail] = [PkmGroupDetail]()
}


struct PkmGroupDetail:Codable{
    var level_learned_at:Int = 0
    var move_learn_method:namedResource = namedResource()
}

struct PokemonTypes:Codable{
    var type:namedResource = namedResource()
}

struct PokemonStats:Codable, Hashable{
    var base_stat:Int = 0
    var stat:namedResource = namedResource()
}

struct PokemonSprites:Codable{
    var front_default: String = ""
    var back_default: String = ""
}

struct PokemonResults:Codable{
    var results:[namedResourceURL]
}

//LOCAL STORAGE, TOP PART IS FOR API FETCHING

struct Pokemon: Codable, Identifiable{
    let id = UUID()
    var Nome:String = "" //
    var Lvl:Int = 0
    var HP:Int = 0 // //
    var permaStats:PermaStats = PermaStats()
    var ATK:Int = 0 //
    var DEF:Int = 0 //
    var spATK:Int = 0 //
    var spDEF:Int = 0 //
    var SPD:Int = 0 //
    var type1:String = "" //
    var type2:String? = "" //?
    var SpeciesStats:PermaStats = PermaStats()
    var IVs:PermaStats = PermaStats()
    var StatExp:PermaStats = PermaStats()
    var activeStages:PermaStats = PermaStats()
    var MoveList:[Moves] = [Moves]() //
    var allMoves:[PokemonMoves] = [PokemonMoves]()
    var AilmentList:Ailments = Ailments()
    var dexNumber:Int = 0 //
    var imgURL:String = ""
    var Sprites:PokemonSprites = PokemonSprites()
    var currentXP:Int = 0
    var xpWon:Int = 0
    var wasUsed:Bool = false
}


struct Ailments:Codable{
    var paralysis:Bool = false
    var sleep:Bool = false
    var freeze:Bool = false
    var burn:Bool = false
    var poison:Bool = false
    var confusion:Bool = false
    var trap:Bool = false
    var disable:Bool = false
    var leech_seed:Bool = false
}
struct PermaStats: Codable {
    var HP:Int = 0
    var ATK:Int = 0 //
    var DEF:Int = 0 //
    var spATK:Int = 0 //
    var spDEF:Int = 0 //
    var SPD:Int = 0 //
}
