//
//  BattleUtils.swift
//  PokeRPG
//
//  Created by Alyzor on 01/07/2023.
//

import Foundation
import SwiftUI

final class BattleUtils:ObservableObject{
    
    init(team1:PokemonTeam, team2:PokemonTeam){
        self.UserTeam = team1
        self.BotTeam = team2
    }
    
    @Published var UserTeam = PokemonTeam()
    @Published var BotTeam = PokemonTeam()
    @Published var enableAction = true
    @Published var gotoBag = false
    @Published var gotoTeam = false
    @Published var battleReport = ""
    @Published var goEscape = false
    @Published var userPkmNo = 0
    @Published var botPkmNo = 0
    @Published var battleEnd = false
    @Published var enableBtns = false
    @Published var screenView = false
    
    @Published var calcOngoing = false
    @Published var firstCalc:Double = 0
    @Published var secCalc:Double = 0
    @Published var thirdCalc:Double = 0
    @Published var fourthCalc:Double = 0
    @Published var type1DMG:Double = 0
    @Published var type2DMG: Double = 0
    @Published var finalDMG:Double = 0
    @Published var STAB:Double = 0
    
    @Published var finished = false
    @AppStorage("userWallet") var userWallet = 0
    
    
    @Published var isDisabledOne = true
    @Published var isDisabledTwo = true
    @Published var isDisabledThree = true
    @Published var isDisabledMain = false
    
    
    func changeBtnState(state:Bool){
        isDisabledMain = state
        if UserTeam.Pkmn[userPkmNo].MoveList.indices.contains(1){
            isDisabledOne = state
        }
        if UserTeam.Pkmn[userPkmNo].MoveList.indices.contains(2){
            isDisabledTwo = state
        }
        if UserTeam.Pkmn[userPkmNo].MoveList.indices.contains(3){
            isDisabledThree = state
        }
    }
    

    
      func showXPWon(xp:Int){
          print(UserTeam.Pkmn)
          UserTeam.Pkmn[userPkmNo].currentXP += xp
          battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) has gained \(xp) XP!"
          //endBattle()
      }
      func resetStats(){
       for var pkm in UserTeam.Pkmn{
           pkm.ATK = pkm.permaStats.ATK
           pkm.DEF = pkm.permaStats.DEF
           pkm.spATK = pkm.permaStats.spATK
           pkm.spDEF = pkm.permaStats.spDEF
           pkm.SPD = pkm.permaStats.SPD
       }
      }
      
      func endBattle(){
          resetStats()
          TeamUtils().saveTeam(Team: UserTeam)
          goEscape = true
          print(goEscape)
      }
      func hasActivePokemon(userFaint:Bool) -> Bool{
          if userFaint{
              for pkm in UserTeam.Pkmn{
                  if pkm.HP > 0{
                      return true
                  }
              }
              return false
          }else
          {
              for pkm in BotTeam.Pkmn{
                  if pkm.HP > 0{
                      return true
                  }
              }
              return false
          }
      }
    
    
    //battle Funcs
    
    func startATK(selMove:Moves) {
            UserTeam.Pkmn[userPkmNo].wasUsed = true
            changeBtnState(state: true)
            calcOngoing = true
            let group = DispatchGroup()
            group.enter()
            let bMove = BotTeam.Pkmn[botPkmNo].MoveList.randomElement()!
            let userFirst:Bool = checkFirstAttack()
            if userFirst || bMove.statusDetails.target == "specific-move"{
                battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) used \(selMove.Name)!"
                DispatchQueue.main.asyncAfter(deadline: .now()+1){ [self] in
                    if self.GetATKType(Move: selMove){
                        if selMove.min_hits == 0{
                            self.BotTeam.Pkmn[self.botPkmNo].HP -= self.CalcularDMG(ATK: self.UserTeam.Pkmn[self.userPkmNo], DEF: BotTeam.Pkmn[botPkmNo], Move:selMove)
                        }
                        else{
                            let rand = Int.random(in: selMove.min_hits...selMove.max_hits)
                            for _ in 1...rand {
                                BotTeam.Pkmn[botPkmNo].HP -= CalcularDMG(ATK: UserTeam.Pkmn[userPkmNo], DEF: BotTeam.Pkmn[botPkmNo], Move:selMove)
                            }
                        }
                    }else{
                        checkStatInflicted(statInflicted: selMove.statusDetails, target:true)
                    }
                        if verifyFaint(){
                            group.leave()
                        }
                        else{
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        battleReport = "\(BotTeam.Pkmn[botPkmNo].Nome) used \(bMove.Name)!"
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            if GetATKType(Move: bMove){
                                if bMove.min_hits == 0{
                                    UserTeam.Pkmn[userPkmNo].HP -= CalcularDMG(ATK:BotTeam.Pkmn[botPkmNo], DEF:UserTeam.Pkmn[userPkmNo], Move:bMove)
                                }
                                else{
                                    let rand = Int.random(in: bMove.min_hits...bMove.max_hits)
                                    for _ in 1...rand {
                                        UserTeam.Pkmn[userPkmNo].HP -= CalcularDMG(ATK:BotTeam.Pkmn[botPkmNo], DEF:UserTeam.Pkmn[userPkmNo], Move:bMove)
                                    }
                                    
                                }
                            }else{
                                checkStatInflicted(statInflicted: bMove.statusDetails, target:false)
                            }
                            group.leave()
                        }
                    }
                    }
                }
            }
            else{
                battleReport = "\(BotTeam.Pkmn[botPkmNo].Nome) used \(bMove.Name)!"
                DispatchQueue.main.asyncAfter(deadline: .now()+1){ [self] in
                    if GetATKType(Move: bMove){
                        if bMove.min_hits == 0{
                            UserTeam.Pkmn[userPkmNo].HP -= CalcularDMG(ATK:BotTeam.Pkmn[botPkmNo], DEF:UserTeam.Pkmn[userPkmNo], Move:bMove)
                        }else{
                            let rand = Int.random(in: bMove.min_hits...bMove.max_hits)
                            for _ in 1...rand {
                                UserTeam.Pkmn[userPkmNo].HP -= CalcularDMG(ATK:BotTeam.Pkmn[botPkmNo], DEF:UserTeam.Pkmn[userPkmNo], Move:bMove)
                            }
                        }
                    }else{
                        self.checkStatInflicted(statInflicted: bMove.statusDetails, target:false)
                    }
                    if self.verifyFaint(){
                            group.leave()
                        }
                        else{
                            DispatchQueue.main.asyncAfter(deadline: .now()+1){ [self] in
                        battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) used \(selMove.Name)!"
                            DispatchQueue.main.asyncAfter(deadline: .now()+1){ [self] in
                            if self.GetATKType(Move: selMove){
                                if selMove.min_hits == 0{
                                    BotTeam.Pkmn[botPkmNo].HP -= CalcularDMG(ATK: UserTeam.Pkmn[userPkmNo], DEF: BotTeam.Pkmn[botPkmNo], Move:selMove)
                                }
                                else{
                                    let rand = Int.random(in: selMove.min_hits...selMove.max_hits)
                                    for _ in 1...rand {
                                        BotTeam.Pkmn[botPkmNo].HP -= CalcularDMG(ATK: UserTeam.Pkmn[userPkmNo], DEF: BotTeam.Pkmn[botPkmNo], Move:selMove)
                                    }
                                }
                            }else{
                                self.checkStatInflicted(statInflicted: selMove.statusDetails, target:true)
                            }
                            group.leave()
                        }
                    }
                }
                }
            }
            group.notify(queue: .main) {
                if self.verifyFaint(){
                    self.checkWin()
                    }else{
                        DispatchQueue.main.asyncAfter(deadline:.now() + 2){ [self] in
                    battleReport = "What wil \(UserTeam.Pkmn[userPkmNo].Nome) do?"
                    changeBtnState(state: false)
                    screenView = false
                    }
                }
            }
        }
    
    func checkWin(){
        if UserTeam.Pkmn[userPkmNo].HP <= 0{
                    UserTeam.Pkmn[userPkmNo].HP = 0
                    battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) has fainted!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [self] in
                        if hasActivePokemon(userFaint: true){
                    }
                    else{
                        battleReport = "You have lost!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        screenView = false
                        finished = true
                        }
                    }
                    }
                }
                else if BotTeam.Pkmn[botPkmNo].HP <= 0{
                    BotTeam.Pkmn[botPkmNo].HP = 0
                    battleReport = "\(BotTeam.Pkmn[botPkmNo].Nome) has fainted!"
                    if hasActivePokemon(userFaint: false){
                        
                    }
                    else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [self] in
                        battleReport = "You have won!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            let moneyEarned = Int.random(in: 1...25)
                            battleReport = "You earned \(moneyEarned)$!"
                            userWallet += moneyEarned
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                let xpWon = calcXP()
                                UserTeam.Pkmn[userPkmNo].currentXP += xpWon
                                battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) won \(xpWon) XP!"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                screenView = false
                                finished = true
                                }
                                
                            }
                        }
                    }
                    }
                }
    }
    
    
    func calcXP() -> Int{
        var calc1=0
        calc1 = (BotTeam.Pkmn[botPkmNo].xpWon * BotTeam.Pkmn[botPkmNo].Lvl)/7
        return calc1
    }
    
    func verifyFaint() -> Bool{
        if UserTeam.Pkmn[userPkmNo].HP <= 0 || BotTeam.Pkmn[botPkmNo].HP <= 0{
            return true
        }
        else{
            return false
        }
    }
    
    func resetDMG(){
        firstCalc = 0.0
        secCalc = 0.0
        thirdCalc = 0.0
        fourthCalc = 0.0
        type1DMG = 0.0
        type2DMG = 0.0
        finalDMG = 0.0
    }
    
    func GetATKType(Move:Moves) -> Bool{
        if Move.dmgOrBuff != "status"{
            return true
        }else{
            return false
        }
    }
    
    func CalcularDMG(ATK:Pokemon, DEF:Pokemon, Move:Moves) -> Int {
        resetDMG()
        firstCalc = ((2*Double(ATK.Lvl))/5)+2 //8
        if Move.dmgOrBuff == "physical"{
            secCalc = firstCalc * Double(Move.Power) * (Double(ATK.ATK)/Double(DEF.DEF))//369
        }else{
            secCalc = firstCalc * Double(Move.Power) * (Double(ATK.spATK)/Double(DEF.spDEF))//369
        }
        
        thirdCalc = (secCalc/50)+2 //9
        
        //verificar STAB (Same attack type bonus)
        if(ATK.type1 == Move.pType || ATK.type2 == Move.pType){
            STAB = 1.5
        }
        else{
            STAB = 1.0
        }
        //verifica o tipo do pokemon que ataca e o que defende, e o bonus a ser //utilizado
        type1DMG = getTypeMultiplier(Type1: Move.pType, Type2: DEF.type1)
        
        fourthCalc = thirdCalc*STAB*type1DMG
        //verificação de existência de tipos
        if DEF.type2 != nil{
            type2DMG = getTypeMultiplier(Type1: Move.pType, Type2: DEF.type2!)
        }
        
        if DEF.type2 != nil{
            switch type1DMG{
            case 2.0:
                switch type2DMG{
                case 2.0, 1.0:
                    battleReport = "It's Super-Effective!"
                case 0.5:
                    battleReport = "..."
                default:
                    battleReport = "It had no effect..."
                }
            case 0.5:
                switch type2DMG{
                case 2.0:
                    battleReport = "..."
                case 1.0, 0.5:
                    battleReport = "It's not very effective..."
                default:
                    battleReport = "It had no effect..."
                }
            case 0:
                battleReport = "It had no effect..."
            default:
                switch type2DMG{
                case 2.0:
                    battleReport = "It's Super-Effective!"
                case 1.0:
                    battleReport = "..."
                case 0.5:
                    battleReport = "It's not very effective..."
                default:
                    battleReport = "It had no effect..."
                }
            }
            
        }else{
            switch type1DMG{
            case 2.0:
                battleReport = "It's Super-Effective!"
            case 0.5:
                battleReport = "It's not very effective..."
            case 0.0:
                battleReport = "It had no effect..."
            default:
                battleReport = "..."
            }
        }
        
        finalDMG = (fourthCalc * Double(Int.random(in: 217...255)))/255
        return Int(finalDMG)
    }
    func getStageMultiplier(stage:Int) -> Double{
        switch stage{
        case -6:
            return 0.25
        case -5:
            return 0.28
        case -4:
            return 0.33
        case -3:
            return 0.40
        case -2:
            return 0.50
        case -1:
            return 0.66
        case 0:
            return 1
        case 1:
            return 1.5
        case 2:
            return 2
        case 3:
            return 2.5
        case 4:
            return 3
        case 5:
            return 3.5
        case 6:
            return 4
        default:
            if stage < -6{
                return 0.25
            }else{
                return 4
            }
        }
    }
    func checkStatInflicted(statInflicted:statChDetail, target:Bool){
        switch statInflicted.statInflicted{
        case "attack":
            if target==true{
                BotTeam.Pkmn[botPkmNo].activeStages.ATK += statInflicted.statChange
                BotTeam.Pkmn[botPkmNo].ATK = Int(Double(BotTeam.Pkmn[botPkmNo].permaStats.ATK) * getStageMultiplier(stage:BotTeam.Pkmn[botPkmNo].activeStages.ATK))
            }else{
                UserTeam.Pkmn[userPkmNo].activeStages.ATK += statInflicted.statChange
                UserTeam.Pkmn[userPkmNo].ATK = Int(Double(UserTeam.Pkmn[userPkmNo].permaStats.ATK) * getStageMultiplier(stage:UserTeam.Pkmn[userPkmNo].activeStages.ATK))
            }
        case "defense":
            if target==true{
                BotTeam.Pkmn[botPkmNo].activeStages.DEF += statInflicted.statChange
                BotTeam.Pkmn[botPkmNo].DEF = Int(Double(BotTeam.Pkmn[botPkmNo].permaStats.DEF) * getStageMultiplier(stage:BotTeam.Pkmn[botPkmNo].activeStages.DEF))
            }else{
                UserTeam.Pkmn[userPkmNo].activeStages.DEF += statInflicted.statChange
                UserTeam.Pkmn[userPkmNo].DEF = Int(Double(UserTeam.Pkmn[userPkmNo].permaStats.DEF) * getStageMultiplier(stage:UserTeam.Pkmn[userPkmNo].activeStages.DEF))
            }
        case "special-attack":
            if target==true{
                BotTeam.Pkmn[botPkmNo].activeStages.spATK += statInflicted.statChange
                BotTeam.Pkmn[botPkmNo].spATK = Int(Double(BotTeam.Pkmn[botPkmNo].permaStats.spATK) * getStageMultiplier(stage:BotTeam.Pkmn[botPkmNo].activeStages.spATK))
            }else{
                UserTeam.Pkmn[userPkmNo].activeStages.spATK += statInflicted.statChange
                UserTeam.Pkmn[userPkmNo].spATK = Int(Double(UserTeam.Pkmn[userPkmNo].permaStats.spATK) * getStageMultiplier(stage:UserTeam.Pkmn[userPkmNo].activeStages.spATK))
            }
        case "special-defense":
            if target==true{
                BotTeam.Pkmn[botPkmNo].activeStages.spDEF += statInflicted.statChange
                BotTeam.Pkmn[botPkmNo].spDEF = Int(Double(BotTeam.Pkmn[botPkmNo].permaStats.spDEF) * getStageMultiplier(stage:BotTeam.Pkmn[botPkmNo].activeStages.spDEF))
            }else{
                UserTeam.Pkmn[userPkmNo].activeStages.spDEF += statInflicted.statChange
                UserTeam.Pkmn[userPkmNo].spDEF = Int(Double(UserTeam.Pkmn[userPkmNo].permaStats.spDEF) * getStageMultiplier(stage:UserTeam.Pkmn[userPkmNo].activeStages.spDEF))
            }
        default:
            if target==true{
                BotTeam.Pkmn[botPkmNo].activeStages.SPD += statInflicted.statChange
                BotTeam.Pkmn[botPkmNo].SPD = Int(Double(BotTeam.Pkmn[botPkmNo].permaStats.SPD) * getStageMultiplier(stage:BotTeam.Pkmn[botPkmNo].activeStages.SPD))
            }else{
                UserTeam.Pkmn[userPkmNo].activeStages.SPD += statInflicted.statChange
                UserTeam.Pkmn[userPkmNo].SPD = Int(Double(UserTeam.Pkmn[userPkmNo].permaStats.SPD) * getStageMultiplier(stage:UserTeam.Pkmn[userPkmNo].activeStages.SPD))
            }
        }
        if target{
            if statInflicted.statChange <= 0{
                battleReport = "1\(BotTeam.Pkmn[botPkmNo].Nome)'s \(statInflicted.statInflicted) fell!"
            }else{
                battleReport = "1\(BotTeam.Pkmn[botPkmNo].Nome)'s \(statInflicted.statInflicted.capitalized) rose!"
            }
        }else{
            if statInflicted.statChange <= 0{
                battleReport = "2\(UserTeam.Pkmn[userPkmNo].Nome)'s \(statInflicted.statInflicted.capitalized) fell!"
            }else{
                battleReport = "2\(UserTeam.Pkmn[userPkmNo].Nome)'s \(statInflicted.statInflicted.capitalized) rose!"
            }
        }
    }
    func checkFirstAttack() -> Bool{
        if UserTeam.Pkmn[userPkmNo].SPD > BotTeam.Pkmn[botPkmNo].SPD{
            return true
        }
        else if BotTeam.Pkmn[botPkmNo].SPD > UserTeam.Pkmn[userPkmNo].SPD{
            return false
        }else{
            let ran = Int.random(in: 1...2)
            if ran == 1 {return true} else {return false}
        }
    }
    func activateAilment(move:Moves, userSent:Bool){
        switch move.ailment{
        case "paralysis":
            if userSent{
                BotTeam.Pkmn[botPkmNo].AilmentList.paralysis = true
            }else
            {
                UserTeam.Pkmn[userPkmNo].AilmentList.paralysis = true
            }
        case "sleep":
            if userSent{
                BotTeam.Pkmn[botPkmNo].AilmentList.sleep = true
            }else
            {
                UserTeam.Pkmn[userPkmNo].AilmentList.sleep = true
            }
        case "freeze":
            if userSent{
                BotTeam.Pkmn[botPkmNo].AilmentList.freeze = true
            }else
            {
                UserTeam.Pkmn[userPkmNo].AilmentList.freeze = true
            }
        case "burn":
            if userSent{
                BotTeam.Pkmn[botPkmNo].AilmentList.burn = true
            }else
            {
                UserTeam.Pkmn[userPkmNo].AilmentList.burn = true
            }
        case "poison":
            if userSent{
                BotTeam.Pkmn[botPkmNo].AilmentList.poison = true
            }else
            {
                UserTeam.Pkmn[userPkmNo].AilmentList.poison = true
            }
        case "confusion":
            if userSent{
                BotTeam.Pkmn[botPkmNo].AilmentList.confusion = true
            }else
            {
                UserTeam.Pkmn[userPkmNo].AilmentList.confusion = true
            }
        case "trap":
            if userSent{
                BotTeam.Pkmn[botPkmNo].AilmentList.trap = true
            }else
            {
                UserTeam.Pkmn[userPkmNo].AilmentList.trap = true
            }
        case "disable":
            if userSent{
                BotTeam.Pkmn[botPkmNo].AilmentList.disable = true
            }else
            {
                UserTeam.Pkmn[userPkmNo].AilmentList.disable = true
            }
        default:
            if userSent{
                BotTeam.Pkmn[botPkmNo].AilmentList.leech_seed = true
            }else
            {
                UserTeam.Pkmn[userPkmNo].AilmentList.leech_seed = true
            }
        }
    }
    
    
}
