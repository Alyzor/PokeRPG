//
//  Pokemon.swift
//  PokeRPG
//
//  Created by Account1 on 07/06/2023.
//

import Foundation

struct Pokemon {
    var Nome = ""
    var Lvl = 0
    var HP = 0
    var ATK = 0
    var DEF = 0
    var spATK = 0
    var spDEF = 0
    var type1 = ""
    var type2:String? = ""
    var Move1 = Moves()
    var Move2 = Moves()
    var Move3 = Moves()
    var Move4 = Moves()
}

func getTypeMultiplier(Type1:String, Type2:String) -> Double{
    switch (Type1){
    case "normal":
        switch (Type2){
            case "rock":
                return 0.5
            case"ghost":
                return 0.0
        default:
            return 1.0
        }
    case"fire":
        switch (Type2){
        case "grass","ice", "bug":
                return 2.0
            case"fire","water","rock","dragon":
                return 0.5
        default:
            return 1.0
        }
    case "water":
            switch (Type2){
            case "fire","ground", "rock":
                    return 2.0
            case"water","grass","dragon":
                    return 0.5
            default:
                return 1.0
            }
    case"electric":
                switch (Type2){
                case "water","flying":
                        return 2.0
                case"electric","grass","dragon":
                        return 0.5
                case "ground":
                        return 0.0
                default:
                    return 1.0
                }
    case "grass":
                 switch (Type2){
                 case "water","ground", "rock":
                         return 2.0
                     case "fire" , "grass" , "poison" , "flying" , "bug" , "dragon":
                         return 0.5
                 default:
                     return 1.0
                 }
    case"ice":
               switch (Type2){
               case "grass","ground", "flying","dragon":
                       return 2.0
                   case "water","ice":
                       return 0.5
               default:
                   return 1.0
               }
    case "fighting":
                    switch (Type2){
                    case "normal","ice", "rock":
                            return 2.0
                    case"poison","flying","psychic","bug":
                            return 0.5
                    case "ghost":
                        return 0.0
                    default:
                        return 1.0
                    }
    case"poison":
                  switch (Type2){
                  case "grass","bug":
                          return 2.0
                      case"poison","ground","rock","ghost":
                          return 0.5
                  default:
                      return 1.0
                  }
    case "ground":
                   switch (Type2){
                   case "fire","electric", "poison", "rock":
                           return 2.0
                       case"grass","bug":
                           return 0.5
                   case "flying":
                       return 0.0
                   default:
                       return 1.0
                   }
    case"flying":
                    switch (Type2){
                    case "grass","fighting", "bug":
                            return 2.0
                        case "electric","rock":
                            return 0.5
                    default:
                        return 1.0
                    }
    case "psychic":
                   switch (Type2){
                   case "fighting", "poison":
                           return 2.0
                       case"psychic":
                           return 0.5
                   default:
                       return 1.0
                   }
    case"bug":
                switch (Type2){
                case "grass","poison", "psychic":
                        return 2.0
                    case"fire","fighting","flying","ghost":
                        return 0.5
                default:
                    return 1.0
                }
    case "rock":
                switch (Type2){
                case "fire","flying","ice", "bug":
                        return 2.0
                case "fighting","ground":
                        return 0.5
                default:
                    return 1.0
                }
    case"ghost":
                switch (Type2){
                case "ghost":
                        return 2.0
                    case"normal","psychic":
                        return 0.0
                default:
                    return 1.0
                }
    case "dragon":
        
        switch (Type2){
        case "dragon":
                return 2.0
        default:
            return 1.0
        }
        
    default:
        return 1.0
    }
}

struct Moves{
    var Name = ""
    var Power = 0
    var pType = ""
}
