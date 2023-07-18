//
//  Items.swift
//  PokeRPG
//
//  Created by Alyzor on 14/07/2023.
//

import Foundation

struct Bag:Codable, Hashable{
    var items:[bagItems] = [bagItems]()
}

struct bagItems:Codable, Hashable{
    var item:itemDetails = itemDetails()
    var amount:Int = 0
}

struct itemDetails:Codable,Hashable{
    var name:String = ""
    var healAmt:Int? = 0
    var imgLink:String = ""
    var cost:Int = 0
    var isPokeball:Bool = false
    
}

func GetItems()->[itemDetails]{
    //Pots
    let potion = itemDetails(name: "Potion", healAmt: 20, imgLink: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/potion.png", cost: 20, isPokeball: false)
    let maxPotion = itemDetails(name: "Max Potion", healAmt: 0, imgLink: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/max-potion.png", cost: 100, isPokeball: false)
    let hyperPotion = itemDetails(name: "Hyper Potion", healAmt: 200, imgLink: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/hyper-potion.png", cost: 75, isPokeball: false)
    let superPotion = itemDetails(name: "Super Potion", healAmt: 50, imgLink: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/super-potion.png", cost: 50, isPokeball: false)
    
    //PokeBalls
    let pokeball = itemDetails(name: "PokéBall", imgLink: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png", cost: 15, isPokeball: true)
    return [potion, maxPotion, hyperPotion, superPotion, pokeball]
}
