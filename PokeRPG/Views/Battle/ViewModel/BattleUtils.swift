//
//  BattleUtils.swift
//  PokeRPG
//
//  Created by Alyzor on 01/07/2023.
//

import Foundation
import SwiftUI

final class BattleUtils:ObservableObject{
    
    init(team1:PokemonTeam, team2:PokemonTeam, userPkmNo:Int){
        self.UserTeam = team1
        self.BotTeam = team2
        self.userPkmNo = userPkmNo
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
    @Published var userBag = TeamUtils().getBag()
    @Published var moveCap = false
    @Published var moveChanged = true
    @Published var battleStart = true
    
    @Published var tempMove = Moves()
    
    func checkNewMoves(completion:@escaping (Bool) -> ()){
        var hasMove = false
        let group = DispatchGroup()
        let bgQueue = DispatchQueue.global()
        var selMove = Moves()
        for mv in UserTeam.Pkmn[userPkmNo].allMoves{
            if mv.version_group_details[0].move_learn_method.name != "level-up"{continue}
            print(UserTeam.Pkmn[userPkmNo].Lvl)
            if mv.version_group_details[0].level_learned_at != UserTeam.Pkmn[userPkmNo].Lvl{continue}
            selMove.Name = mv.move.name
            group.enter()
            bgQueue.async(group: group,  execute: {
                PokeAPI().fetchMoveData(MoveURL:mv.move.url){fetchedMove in
                    if fetchedMove.damage_class.name != "damage" || fetchedMove.damage_class.name != "ailment" {
                        group.leave()
                    }else{
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
                        hasMove = true
                        group.leave()
                    }else{
                        group.leave()
                    }
                }
                }
                })
        }
        group.notify(queue:DispatchQueue.main){ [self] in
            if hasMove{
                if UserTeam.Pkmn[userPkmNo].MoveList.count == 4{
                    tempMove = selMove
                    moveCap = true
                    completion(hasMove)
                }else{
                    UserTeam.Pkmn[userPkmNo].MoveList.append(selMove)
                    completion(hasMove)
                }
            }else{
                completion(hasMove)
            }
        }
    }
    func replaceMove(move:Int){
        battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) has forgotten \(UserTeam.Pkmn[userPkmNo].MoveList[move].Name)..."
        DispatchQueue.main.asyncAfter(deadline: .now()+1){ [self] in
            UserTeam.Pkmn[userPkmNo].MoveList[move] = tempMove
            battleReport = "and has learnt \(tempMove.Name.capitalized)!"
            DispatchQueue.main.asyncAfter(deadline: .now()+1){ [self] in
                UserTeam.Pkmn[userPkmNo] = SavePokemon().calcStats(sentPokemon: UserTeam.Pkmn[userPkmNo])
                finished = true
                screenView = false
                
            }
        }
        
    }
    
    func replaceBot(){
        BotTeam.Pkmn.indices.forEach{i in
            if BotTeam.Pkmn[i].HP > 0{
                screenView = false
                battleReport = "A wild \(BotTeam.Pkmn[i].Nome) appeared!"
                botPkmNo = i
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){[self] in
                    battleReport = "What will you do?"
                    return
                }
            }
        }
    }
    
    func useItem(item:Int){
        userBag.items[item].amount -= 1
        battleReport = "You used a \(userBag.items[item].item.name)!"
        DispatchQueue.main.asyncAfter(deadline:.now()+1){[self]in
            if userBag.items[item].item.isPokeball{
                if BotTeam.Pkmn[botPkmNo].HP > Int(Double(BotTeam.Pkmn[botPkmNo].permaStats.HP) * 0.3){
                    battleReport = "\(BotTeam.Pkmn[botPkmNo].Nome) escaped from the PokéBall!"
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        screenView = false
                        botAction()
                    }
                }else{
                    if UserTeam.Pkmn.count < 6{
                        UserTeam.Pkmn.append(BotTeam.Pkmn[botPkmNo])
                        battleReport = "It's in! You caught a \(BotTeam.Pkmn[botPkmNo].Nome)!"
                        BotTeam.Pkmn[botPkmNo].HP = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            if hasActivePokemon(userFaint: false){
                                replaceBot()
                            }else{
                                userWin()
                            }
                        }
                    }
                }
            }else{
                if userBag.items[item].item.healAmt! == 0 || UserTeam.Pkmn[userPkmNo].HP + userBag.items[item].item.healAmt! >= UserTeam.Pkmn[userPkmNo].permaStats.HP{
                    UserTeam.Pkmn[userPkmNo].HP = UserTeam.Pkmn[userPkmNo].permaStats.HP
                }else{
                    UserTeam.Pkmn[userPkmNo].HP += userBag.items[item].item.healAmt!
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    screenView = false
                    botAction()
                }
            }
        }
    }
    
    func botAction(){
        let group = DispatchGroup()
        let bMove = BotTeam.Pkmn[botPkmNo].MoveList.randomElement()!
        group.enter()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){ [self] in
            battleReport = "\(BotTeam.Pkmn[botPkmNo].Nome) used \(bMove.Name)!"
            DispatchQueue.main.asyncAfter(deadline: .now()+1){ [self] in
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
        
        group.notify(queue: .main) { [self] in
            if verifyFaint(){
                checkWin()
            }else{
                DispatchQueue.main.asyncAfter(deadline:.now() + 2){ [self] in
                    battleReport = "What wil \(UserTeam.Pkmn[userPkmNo].Nome) do?"
                    changeBtnState(state: false)
                    screenView = false
                }
            }
        }
        
        
        
    }
    
    func exitDiscard(){
        battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) kept their old moves."
        DispatchQueue.main.asyncAfter(deadline: .now()+1){[self] in
            UserTeam.Pkmn[userPkmNo] = SavePokemon().calcStats(sentPokemon: UserTeam.Pkmn[userPkmNo])
            finished = true
            screenView = false
        }
    }
    
    func switchPokemon(pkmNo:Int){
        battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) ,good! Come back!"
        DispatchQueue.main.asyncAfter(deadline: .now()+1){ [self] in
            battleReport = "Go, \(UserTeam.Pkmn[pkmNo].Nome)!"
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
                userPkmNo = pkmNo
            }
        }
    }
    
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
    
    func resetStats(){
        for var pkm in UserTeam.Pkmn{
            pkm.ATK = pkm.permaStats.ATK
            pkm.DEF = pkm.permaStats.DEF
            pkm.spATK = pkm.permaStats.spATK
            pkm.spDEF = pkm.permaStats.spDEF
            pkm.SPD = pkm.permaStats.SPD
        }
        endBattle()
    }
    
    func endBattle(){
        TeamUtils().saveBag(userBag: userBag)
        TeamUtils().saveTeam(Team: UserTeam)
        goEscape = true
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
                self.changeBtnState(state: false)
            }else{
                DispatchQueue.main.asyncAfter(deadline:.now() + 2){ [self] in
                    battleReport = "What wil \(UserTeam.Pkmn[userPkmNo].Nome) do?"
                    changeBtnState(state: false)
                    screenView = false
                }
            }
            self.changeBtnState(state: false)
        }
    }
    
    func userWin(){
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
                    if UserTeam.Pkmn[userPkmNo].currentXP >= Int(pow(Double(UserTeam.Pkmn[userPkmNo].Lvl), Double(3))){
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            while UserTeam.Pkmn[userPkmNo].currentXP >= Int(pow(Double(UserTeam.Pkmn[userPkmNo].Lvl), Double(3))) {
                                UserTeam.Pkmn[userPkmNo].Lvl += 1
                            }
                            battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) has Leveled up!"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                checkNewMoves{a in
                                    if moveCap{
                                    }else{
                                        UserTeam.Pkmn[userPkmNo] = SavePokemon().calcStats(sentPokemon: UserTeam.Pkmn[userPkmNo])
                                        resetStats()
                                        finished = true
                                        screenView = false
                                        
                                    }
                                }
                            }
                        }
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            UserTeam.Pkmn[userPkmNo] = SavePokemon().calcStats(sentPokemon: UserTeam.Pkmn[userPkmNo])
                            resetStats()
                            screenView = true
                            finished = true
                            screenView = false
                        }
                    }
                    
                }
            }
        }
    }
    func checkWin(){
        if UserTeam.Pkmn[userPkmNo].HP <= 0{
            UserTeam.Pkmn[userPkmNo].HP = 0
            screenView = false
            battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome) has fainted!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [self] in
                if hasActivePokemon(userFaint: true){
                    gotoTeam = true
                }
                else{
                    resetStats()
                    battleReport = "You have lost!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        finished = true
                        screenView = false
                    }
                }
            }
        }
        else if BotTeam.Pkmn[botPkmNo].HP <= 0{
            BotTeam.Pkmn[botPkmNo].HP = 0
            battleReport = "\(BotTeam.Pkmn[botPkmNo].Nome) has fainted!"
            DispatchQueue.main.asyncAfter(deadline: .now()+1){[self] in
            if hasActivePokemon(userFaint: false){
                replaceBot()
            }
            else{
                userWin()
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
        firstCalc = ((2*Double(ATK.Lvl))/5)+2 //4
        if Move.dmgOrBuff == "physical"{
            secCalc = firstCalc * Double(Move.Power) * (Double(ATK.ATK)/Double(DEF.DEF))//369
        }else{
            secCalc = firstCalc * Double(Move.Power) * (Double(ATK.spATK)/Double(DEF.spDEF))//369
        }
        
        thirdCalc = (secCalc/50)+2 //9  26
        
        //verificar STAB (Same attack type bonus)
        if(ATK.type1 == Move.pType || ATK.type2 == Move.pType){
            STAB = 1.5//
        }
        else{
            STAB = 1.0
        }
        //verifica o tipo do pokemon que ataca e o que defende, e o bonus a ser //utilizado
        type1DMG = getTypeMultiplier(Type1: Move.pType, Type2: DEF.type1)//2
        
        fourthCalc = thirdCalc*STAB*type1DMG //78
        //verificação de existência de tipos
        if DEF.type2 != nil{
            type2DMG = getTypeMultiplier(Type1: Move.pType, Type2: DEF.type2!)
            fourthCalc = fourthCalc * type2DMG
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
        
        finalDMG = (fourthCalc * Double(Int.random(in: 217...255)))/255 //78
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
                battleReport = "\(BotTeam.Pkmn[botPkmNo].Nome)'s \(statInflicted.statInflicted) fell!"
            }else{
                battleReport = "\(BotTeam.Pkmn[botPkmNo].Nome)'s \(statInflicted.statInflicted.capitalized) rose!"
            }
        }else{
            if statInflicted.statChange <= 0{
                battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome)'s \(statInflicted.statInflicted.capitalized) fell!"
            }else{
                battleReport = "\(UserTeam.Pkmn[userPkmNo].Nome)'s \(statInflicted.statInflicted.capitalized) rose!"
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
