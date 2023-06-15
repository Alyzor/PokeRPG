//
//  Moves.swift
//  PokeRPG
//
//  Created by Alyzor on 15/06/2023.
//

import Foundation


struct DMove:Codable{
    var accuracy:Int = 0
    var name:String = ""
    var power:Int? = 0
    var pp:Int = 0
    var type:namedResource = namedResource()
    var stat_changes:[spMove] = [spMove]()
    var damage_class:namedResource = namedResource()
    var target:namedResource = namedResource()
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
}

struct statChDetail:Codable{
    var statChange:Int = 0
    var statInflicted:String = ""
    var target:String = ""
}
