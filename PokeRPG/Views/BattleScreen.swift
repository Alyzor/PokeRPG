import SwiftUI

struct showUserMoves:View{
    @Binding var screenView:Bool
    @Binding var user:Pokemon
    @Binding var bot:Pokemon
    @Binding var battleReport:String
    
    @State var calcOngoing = false
    @State var move1 = "Locked"
    @State var isDisabledOne = true
    @State var move2 = "Locked"
    @State var isDisabledTwo = true
    @State var move3 = "Locked"
    @State var isDisabledThree = true
    @State var isDisabledMain = false
    
    @State var turnCounter = 0
    @State var counterOn = false
    
    @State var firstCalc:Double = 0.0
    @State var secCalc:Double = 0.0
    @State var thirdCalc:Double = 0.0
    @State var fourthCalc:Double = 0.0
    @State var STAB = 0.0
    @State var type1DMG:Double = 0.0
    @State var type2DMG:Double = 0.0
    @State var finalDMG:Double = 0.0
    
    func changeBtnState(state:Bool){
        isDisabledMain = state
        if user.MoveList.indices.contains(1){
            isDisabledOne = state
        }
        if user.MoveList.indices.contains(2){
            isDisabledTwo = state
        }
        if user.MoveList.indices.contains(3){
            isDisabledThree = state
        }
    }
    
    var body: some View{
        VStack{
            HStack{
                Button{
                    if user.MoveList[0].pp == 0{
                        battleReport = "This move has no PP left!"
                        changeBtnState(state: true)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            changeBtnState(state: false)
                            battleReport = "What wil \(user.Nome) do?"
                        }
                    }else{
                        user.MoveList[0].pp -= 1
                        startATK(selMove: user.MoveList[0])
                    }
                } label: {
                    VStack{
                        Text(user.MoveList[0].Name.capitalized)
                        Text("PP: \(user.MoveList[0].pp) / \(user.MoveList[0].maxPP)")
                    }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(isDisabledMain)
                Button{
                    if user.MoveList[1].pp == 0{
                        battleReport = "This move has no PP left!"
                        changeBtnState(state: true)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            changeBtnState(state: false)
                            battleReport = "What wil \(user.Nome) do?"
                        }
                    }else{
                        user.MoveList[1].pp -= 1
                        startATK(selMove: user.MoveList[1])
                    }
                } label: {
                    VStack{
                        Text(move1.capitalized)
                        if move1 != "Locked"{
                        Text("PP: \(user.MoveList[1].pp) / \(user.MoveList[1].maxPP)")
                        }
                    }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(isDisabledOne)
            }
            HStack{
                Button{
                    if user.MoveList[2].pp == 0{
                        battleReport = "This move has no PP left!"
                        changeBtnState(state: true)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            changeBtnState(state: false)
                            battleReport = "What wil \(user.Nome) do?"
                        }
                    }else{
                        user.MoveList[2].pp -= 1
                        startATK(selMove: user.MoveList[2])
                    }
                } label: {
                    VStack{
                        Text(move2.capitalized)
                        if move2 != "Locked"{
                        Text("PP: \(user.MoveList[2].pp) / \(user.MoveList[2].maxPP)")
                        }
                    }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(isDisabledTwo)
                Button{
                    if user.MoveList[3].pp == 0{
                        battleReport = "This move has no PP left!"
                        changeBtnState(state: true)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            changeBtnState(state: false)
                            battleReport = "What wil \(user.Nome) do?"
                        }
                    }else{
                        user.MoveList[3].pp -= 1
                        startATK(selMove: user.MoveList[3])
                    }
                } label: {
                    VStack{
                        Text(move3.capitalized)
                        if move3 != "Locked"{
                        Text("PP: \(user.MoveList[3].pp) / \(user.MoveList[3].maxPP)")
                        }
                    }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(isDisabledThree)
            }
        }.background(.red).foregroundColor(.white).cornerRadius(5).padding().onAppear{
            if user.MoveList.indices.contains(1){
                move1 = user.MoveList[1].Name
                print(move1)
                isDisabledOne = false
            }
            if user.MoveList.indices.contains(2){
                move2 = user.MoveList[2].Name
                isDisabledTwo = false
            }
            if user.MoveList.indices.contains(3){
                move3 = user.MoveList[3].Name
                isDisabledThree = false
            }
    }
        Button("Go Back"){screenView = false}
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
                bot.activeStages.ATK += statInflicted.statChange
                bot.ATK = Int(Double(bot.permaStats.ATK) * getStageMultiplier(stage:bot.activeStages.ATK))
            }else{
                user.activeStages.ATK += statInflicted.statChange
                user.ATK = Int(Double(user.permaStats.ATK) * getStageMultiplier(stage:user.activeStages.ATK))
            }
            case "defense":
            if target==true{
                bot.activeStages.DEF += statInflicted.statChange
                bot.DEF = Int(Double(bot.permaStats.DEF) * getStageMultiplier(stage:bot.activeStages.DEF))
            }else{
                user.activeStages.DEF += statInflicted.statChange
                user.DEF = Int(Double(user.permaStats.DEF) * getStageMultiplier(stage:user.activeStages.DEF))
            }
            case "special-attack":
            if target==true{
                bot.activeStages.spATK += statInflicted.statChange
                bot.spATK = Int(Double(bot.permaStats.spATK) * getStageMultiplier(stage:bot.activeStages.spATK))
            }else{
                user.activeStages.spATK += statInflicted.statChange
                user.spATK = Int(Double(user.permaStats.spATK) * getStageMultiplier(stage:user.activeStages.spATK))
            }
            case "special-defense":
            if target==true{
                bot.activeStages.spDEF += statInflicted.statChange
                bot.spDEF = Int(Double(bot.permaStats.spDEF) * getStageMultiplier(stage:bot.activeStages.spDEF))
            }else{
                user.activeStages.spDEF += statInflicted.statChange
                user.spDEF = Int(Double(user.permaStats.spDEF) * getStageMultiplier(stage:user.activeStages.spDEF))
            }
            default:
            if target==true{
                bot.activeStages.SPD += statInflicted.statChange
                bot.SPD = Int(Double(bot.permaStats.SPD) * getStageMultiplier(stage:bot.activeStages.SPD))
            }else{
                user.activeStages.SPD += statInflicted.statChange
                user.SPD = Int(Double(user.permaStats.SPD) * getStageMultiplier(stage:user.activeStages.SPD))
            }
        }
        if target{
            if statInflicted.statChange <= 0{
                battleReport = "1\(bot.Nome)'s \(statInflicted.statInflicted) fell!"
            }else{
                    battleReport = "1\(bot.Nome)'s \(statInflicted.statInflicted.capitalized) rose!"
            }
        }else{
                if statInflicted.statChange <= 0{
                    battleReport = "2\(user.Nome)'s \(statInflicted.statInflicted.capitalized) fell!"
                }else{
                        battleReport = "2\(user.Nome)'s \(statInflicted.statInflicted.capitalized) rose!"
                }
        }
    }
    func checkFirstAttack() -> Bool{
        if user.SPD > bot.SPD{
            return true
        }
        else if bot.SPD > user.SPD{
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
                bot.AilmentList.paralysis = true
            }else
            {
                user.AilmentList.paralysis = true
            }
        case "sleep":
            if userSent{
                bot.AilmentList.sleep = true
            }else
            {
                user.AilmentList.sleep = true
            }
        case "freeze":
            if userSent{
                bot.AilmentList.freeze = true
            }else
            {
                user.AilmentList.freeze = true
            }
        case "burn":
            if userSent{
                bot.AilmentList.burn = true
            }else
            {
                user.AilmentList.burn = true
            }
        case "poison":
            if userSent{
                bot.AilmentList.poison = true
            }else
            {
                user.AilmentList.poison = true
            }
        case "confusion":
            if userSent{
                bot.AilmentList.confusion = true
            }else
            {
                user.AilmentList.confusion = true
            }
        case "trap":
            if userSent{
                bot.AilmentList.trap = true
            }else
            {
                user.AilmentList.trap = true
            }
        case "disable":
            if userSent{
                bot.AilmentList.disable = true
            }else
            {
                user.AilmentList.disable = true
            }
        default:
            if userSent{
                bot.AilmentList.leech_seed = true
            }else
            {
                user.AilmentList.leech_seed = true
            }
        }
    }
    
    func verifyCategory(usedMove:Moves, userSent:Bool){
        switch usedMove.category{
        case "ailment":
            checkStatInflicted(statInflicted: usedMove.statusDetails, target: userSent)
        case "heal":
            if userSent == true{
                user.HP += usedMove.healing
            }else{
                bot.HP += usedMove.healing
            }
        case "damage+ailment":
                let chance = Int.random(in:1...100)
            if userSent == true{
                bot.HP -= CalcularDMG(ATK: user, DEF: bot, Move:usedMove)
                if chance <= usedMove.ailmentChance{
                    activateAilment(move:usedMove, userSent: userSent)
                }
            }else{
                user.HP -= CalcularDMG(ATK: bot, DEF: user, Move: usedMove)
                if chance <= usedMove.ailmentChance{
                    activateAilment(move:usedMove, userSent: userSent)
                }
            }
        case "damage+lower":
            if userSent{
                bot.HP -= CalcularDMG(ATK: user, DEF: bot, Move: usedMove)
                    checkStatInflicted(statInflicted: usedMove.statusDetails, target: userSent)
            }else{
                user.HP -= CalcularDMG(ATK: bot, DEF: user, Move: usedMove)
            }
        case "damage+heal":
            if userSent{
                bot.HP -= CalcularDMG(ATK: user, DEF: bot, Move: usedMove)
                user.HP += usedMove.healing
            }
        case "ohko":
            let chance = Int.random(in:1...100)
            if chance <= usedMove.acc{
                if userSent{
                    bot.HP = 0
                }else{
                    user.HP = 0
                }
            }
        default:
            print("awawaaw")
        //Whole-field-effect - applies effect to whole field
        //Field-effect - applies effect to opponent field
        //Force-switch - forces opponent to switch
        //Unique
    }
}
    
    func startATK(selMove:Moves) {
        changeBtnState(state: true)
        calcOngoing = true
        let group = DispatchGroup()
        print(user)
        group.enter()
        let bMove = bot.MoveList.randomElement()!
        let userFirst:Bool = checkFirstAttack()
        if userFirst || bMove.statusDetails.target == "specific-move"{
            battleReport = "\(user.Nome) used \(selMove.Name)!"
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                if GetATKType(Move: selMove){
                    if selMove.min_hits == 0{
                    bot.HP -= CalcularDMG(ATK: user, DEF: bot, Move:selMove)
                    }
                    else{
                        let rand = Int.random(in: selMove.min_hits...selMove.max_hits)
                        for _ in 1...rand {
                            bot.HP -= CalcularDMG(ATK: user, DEF: bot, Move:selMove)
                        }
                    }
                }else{
                    checkStatInflicted(statInflicted: selMove.statusDetails, target:true)
                }
                if verifyFaint(){
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    battleReport = "\(bot.Nome) used \(bMove.Name)!"
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        if GetATKType(Move: bMove){
                            if bMove.min_hits == 0{
                                user.HP -= CalcularDMG(ATK:bot, DEF:user, Move:bMove)
                            }
                            else{
                                let rand = Int.random(in: bMove.min_hits...bMove.max_hits)
                                for _ in 1...rand {
                                        user.HP -= CalcularDMG(ATK:bot, DEF:user, Move:bMove)
                                }
                                
                            }
                    }else{
                        checkStatInflicted(statInflicted: bMove.statusDetails, target:false)
                    }
                    }
                    group.leave()
                }
            }
        }
        else{
            battleReport = "\(bot.Nome) used \(bMove.Name)!"
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                if GetATKType(Move: bMove){
                    if bMove.min_hits == 0{
                user.HP -= CalcularDMG(ATK:bot, DEF:user, Move:bMove)
                    }else{
                        let rand = Int.random(in: bMove.min_hits...bMove.max_hits)
                        for _ in 1...rand {
                                user.HP -= CalcularDMG(ATK:bot, DEF:user, Move:bMove)
                        }
                    }
            }else{
                checkStatInflicted(statInflicted: bMove.statusDetails, target:false)
            }
                if verifyFaint(){
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    battleReport = "\(user.Nome) used \(selMove.Name)!"
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        if GetATKType(Move: selMove){
                            if selMove.min_hits == 0{
                            bot.HP -= CalcularDMG(ATK: user, DEF: bot, Move:selMove)
                            }
                            else{
                                let rand = Int.random(in: selMove.min_hits...selMove.max_hits)
                                for _ in 1...rand {
                                    bot.HP -= CalcularDMG(ATK: user, DEF: bot, Move:selMove)
                                }
                            }
                        }else{
                            checkStatInflicted(statInflicted: selMove.statusDetails, target:true)
                        }
                    }
                    
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline:.now() + 2){
                    battleReport = "What wil \(user.Nome) do?"
                    changeBtnState(state: false)
                    screenView = false
            }
        }
    }
          
    func verifyFaint()-> Bool{
        if user.HP <= 0{
            print("merreu user")
            return true
        }
        else if bot.HP <= 0{
            print("o outro merreu")
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
}

struct SelectAction: View{
    @Binding var screenView:Bool
    @Binding var battleReport:String
    @Binding var enableBtns:Bool
    @State var goEscape = false
    @State var gotoTeam = false
    @State var gotoBag = false
    var body: some View{
        VStack{
            HStack{
                Button("Fight"){
                    screenView = true
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(enableBtns)
                Divider()
                Button("Bag"){
                    print(screenView)
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(enableBtns)
            }
            Divider()
            HStack{
                Button("Switch"){
                    gotoTeam = true
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(enableBtns)
                Divider()
                Button("Run"){
                    battleReport = "You have fled!"
                            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                                goEscape = true
                            }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(enableBtns)
            }
        }.background(.red).foregroundColor(.white).cornerRadius(5).padding()
        NavigationLink("", destination:TeamViewer(), isActive: $gotoTeam)
        NavigationLink("", destination:HomeScreen(), isActive: $goEscape)
    }
}

struct BattleScreen: View {
    
    @State var PokemonUser = Pokemon()
    @State var PokemonBot = Pokemon()
    @State var enableAction = true
    @State var gotoBag = false
    @State var gotoTeam = false
    @State var battleReport = ""
    
    @State var screenView = false
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    VStack{//Adv info
                        Text(PokemonBot.Nome)
                        Text("HP: \(PokemonBot.HP) / \(PokemonBot.FullHP)")
                    }.padding().background(.white).cornerRadius(15)
                }.padding()
                VStack{
                    //Imagem Adv
                    HStack{
                        Spacer()
                        PkmnImage(imageLink:PokemonBot.imgURL, front:true)
                    }
                    //Imagem User
                    HStack{
                        PkmnImage(imageLink:PokemonUser.imgURL, front:false)
                        Spacer()
                    }
                }
                HStack{
                    VStack{
                        Text(PokemonUser.Nome)
                        Text("HP: \(PokemonUser.HP) / \(PokemonUser.FullHP)")
                    }.padding().background(.white).cornerRadius(15)
                    Spacer()
                }.padding()
                Spacer()
            }.background(.green).padding([.trailing, .leading])
            Divider()
            //Descricao
            HStack{
                Text(battleReport).onAppear{
                    battleReport = "A wild \(PokemonBot.Nome) appeared!"
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            enableAction = false
                            battleReport = "What will \(PokemonUser.Nome) do?"}
                }
            }.padding(.top)
            if screenView == true{
                showUserMoves(screenView:$screenView, user: $PokemonUser, bot: $PokemonBot, battleReport:$battleReport)
            }else{
                SelectAction(screenView: $screenView, battleReport: $battleReport, enableBtns: $enableAction)
            }
            NavigationLink("", destination:TeamViewer(), isActive: $gotoTeam)
        }.navigationBarHidden(true)
    }
    
struct BattleScreen_Previews: PreviewProvider {
    static var previews: some View {
        BattleScreen()
    }
}
}
