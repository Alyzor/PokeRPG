//
//  Utils.swift
//  PokeRPG
//
//  Created by Alyzor on 15/06/2023.
//

import Foundation
import SwiftUI

func getTypeImage(type:String) -> String{
    switch type{
    case "normal":
        return "figure.fencing"
    case "fire":
        return "flame.fill"
    case "water":
        return "drop.fill"
    case "electric":
        return "bolt.fill"
    case "grass":
        return "leaf.fill"
    case "ice":
        return "snow"
    case "fighting":
        return "figure.boxing"
    case "poison":
        return "syringe.fill"
    case "ground":
        return "mountain.2.fill"
    case "flying":
        return "bird.fill"
    case "psychic":
        return "wave.3.right"
    case "bug":
        return "ant.fill"
    case "rock":
        return "chart.dots.scatter"
    case "ghost":
        return "eye.fill"
    default:
        return "bird"
    }
}

func getTypeColor(type:String) -> String{
    switch type{
    case "normal":
        return "A8A77A"
    case "fire":
        return "EE8130"
    case "water":
        return "6390F0"
    case "electric":
        return "F7D02C"
    case "grass":
        return "7AC74C"
    case "ice":
        return "96D9D6"
    case "fighting":
        return "C22E28"
    case "poison":
        return "A33EA1"
    case "ground":
        return "E2BF65"
    case "flying":
        return "A98FF3"
    case "psychic":
        return "F95587"
    case "bug":
        return "A6B91A"
    case "rock":
        return "B6A136"
    case "ghost":
        return "735797"
    default: //dragon
        return "6F35FC"
    }
    
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
