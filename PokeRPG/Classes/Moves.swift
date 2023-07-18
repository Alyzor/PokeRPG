//
//  Moves.swift
//  PokeRPG
//
//  Created by Alyzor on 15/06/2023.
//

import Foundation


struct DMove:Codable{
    var accuracy:Int? = 0
    var name:String = ""
    var power:Int? = 0
    var pp:Int = 0
    var type:namedResource = namedResource()
    var stat_changes:[spMove] = [spMove]()
    var damage_class:namedResource = namedResource()
    var target:namedResource = namedResource()
    var generation:namedResource = namedResource()
    var meta:AilmentDetails = AilmentDetails()
}

struct AilmentDetails:Codable{
    var ailment:namedResource = namedResource()
    var ailment_chance:Int = 0
    var category: namedResource = namedResource()
    var healing:Int = 0
    var drain:Int = 0
    var max_hits:Int? = 0
    var max_turns:Int? = 0
    var min_hits:Int? = 0
    var min_turns:Int? = 0
}

struct spMove:Codable{
    var change:Int = 0
    var stat:namedResource = namedResource()
}

//LOCAL USAGE, TOP PART IS FOR API FETCHING

struct Moves:Codable, Identifiable{
    let id = UUID()
    var Name:String = ""
    var Power:Int = 0
    var pType:String = ""
    var acc:Int = 0
    var pp:Int = 0
    var maxPP:Int = 0
    var dmgOrBuff:String = ""
    var statusDetails:statChDetail = statChDetail()
    var ailment:String = ""
    var ailmentChance:Int = 0
    var category:String = ""
    var healing:Int = 0
    var drain:Int = 0
    var max_hits:Int = 0
    var min_hits:Int = 0
    var max_turns:Int = 0
    var min_turns:Int = 0
}

struct statChDetail:Codable{
    var statChange:Int = 0
    var statInflicted:String = ""
    var target:String = ""
}
