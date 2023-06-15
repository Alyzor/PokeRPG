//
//  BattleScreen.swift
//  PokeRPG
//
//  Created by Alyzor on 10/06/2023.
//
//
//import SwiftUI
//
//struct BattleScreen: View {
//    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
//    @State private var contador = 0
//
//    @State var Machoke = Pokemon(Nome: "Machoke", Lvl: 15, HP: 80, ATK: 100, //DEF: 70, spATK: 50, spDEF: 60, SPD:45, type1: "fighting")
//
//    @State var Golem = Pokemon(Nome: "Golem", Lvl: 16,HP: 80, ATK: 120, DEF: //130, spATK: 55, spDEF: 65, SPD:45, type1: "rock", type2:"ground")

//    @State var battleReport = "What will you do...?"
//    @State var calcOngoing = false
//    @State var firstCalc:Double = 0.0
//    @State var secCalc:Double = 0.0
//    @State var thirdCalc:Double = 0.0
//    @State var fourthCalc:Double = 0.0
//    @State var STAB = 0.0
//    @State var type1DMG:Double = 0.0
//    @State var type2DMG:Double = 0.0
//    @State var finalDMG:Double = 0.0
//
//func resetDMG(){
//    firstCalc = 0.0
//    secCalc = 0.0
//    thirdCalc = 0.0
//    fourthCalc = 0.0
//    type1DMG = 0.0
//    type2DMG = 0.0
//    finalDMG = 0.0
//}
//
//
//
//func CalcularDMG(ATK:Pokemon, DEF:Pokemon, Move:Moves) -> Int {
//        resetDMG()
//        firstCalc = ((2*Double(ATK.Lvl))/5)+2 //8
//
//        secCalc = firstCalc * Double(Move.Power) * (Double(ATK.ATK)/Double(DEF.DEF))//369
//
//        thirdCalc = (secCalc/50)+2 //9
//
//        //verificar STAB (Same attack type bonus)
//        if(ATK.type1 == Move.pType || ATK.type2 == Move.pType){
//            STAB = 1.5
//        }
//        else{
//            STAB = 1.0
//        }
//        //verifica o tipo do pokemon que ataca e o que defende, e o bonus a ser //utilizado
//        type1DMG = getTypeMultiplier(Type1: Move.pType, Type2: DEF.type1)
//
//            fourthCalc = thirdCalc*STAB*type1DMG
//        //verificação de existência de tipos
//        if DEF.type2 != nil{
//            type2DMG = getTypeMultiplier(Type1: Move.pType, Type2: DEF.type2!)
//        }
//
//        if DEF.type2 != nil{
//            switch type1DMG{
//            case 2.0:
//                switch type2DMG{
//                case 2.0, 1.0:
//                    battleReport = "It's Super-Effective!"
//                case 0.5:
//                    battleReport = ""
//                default:
//                    battleReport = "It had no effect..."
//                }
//            case 0.5:
//                switch type2DMG{
//                case 2.0:
//                    battleReport = ""
//                case 1.0, 0.5:
//                    battleReport = "It's not very effective..."
//                default:
//                    battleReport = "It had no effect..."
//                }
//            case 0:
//                battleReport = "It had no effect..."
//            default:
//                switch type2DMG{
//                case 2.0:
//                    battleReport = "It's Super-Effective!"
//                case 1.0:
//                    battleReport = ""
//                case 0.5:
//                    battleReport = "It's not very effective..."
//                default:
//                    battleReport = "It had no effect..."
//                }
//            }
//
//        }else{
//            switch type1DMG{
//            case 2.0:
//                battleReport = "It's Super-Effective!"
//            case 0.5:
//                battleReport = "It's not very effective..."
//            case 0.0:
//                battleReport = "It had no effect..."
//            default:
//            battleReport = ""
//            }
//        }
//
//        finalDMG = (fourthCalc * Double(Int.random(in: 217...255)))/255
//        return Int(finalDMG)
//    }
//
//func startATK(p1:Pokemon, p2:Pokemon, pMove:Moves) {
//        calcOngoing = true
//        let bMove = botMove(bot: p2)
//        if (p1.SPD > p2.SPD){
//            battleReport = "\(p1.Nome) used \(pMove.Name)!"
//            DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                p2.HP -= CalcularDMG(ATK: p1, DEF: p2, Move: pMove)
//
//                DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                    battleReport = "\(p2.Nome) used \(bMove.Name)!"
//                    DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                        p1.HP -= CalcularDMG(ATK:p2, DEF:p1, Move:bMove)}
//                }
//            }
//        }
//        else if (p2.SPD > p1.SPD){
//            battleReport = "\(p2.Nome) used \(bMove.Name)!"
//            DispatchQueue.main.asyncAfter(deadline: .now()+2){
//            p1.HP -= CalcularDMG(ATK:p2, DEF:p1, Move:bMove)
//                DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                    battleReport = "\(p1.Nome) used \(pMove.Name)!"
//                    DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                p2.HP -= CalcularDMG(ATK: p1, DEF: p2, Move: pMove)
//                    }
//                }
//            }
//        }
//        else{
//            let ran = Int.random(in: 1...2)
//            switch (ran)
//            {case 1:
//
//                battleReport = "\(p2.Nome) used \(bMove.Name)!"
//                DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                p1.HP -= CalcularDMG(ATK:p2, DEF:p1, Move:bMove)
//                    DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                        battleReport = "\(p1.Nome) used \(pMove.Name)!"
//                        DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                    p2.HP -= CalcularDMG(ATK: p1, DEF: p2, Move: pMove)
//                        }
//                    }
//                }
//            default:
//                battleReport = "\(p1.Nome) used \(pMove.Name)!"
//                DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                    Golem.HP -= CalcularDMG(ATK: p1, DEF: p2, Move: //pMove)
//
//                    DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                        battleReport = "\(p2.Nome) used \(bMove.Name)!"
//                        DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                            Machoke.HP -= CalcularDMG(ATK:p2, DEF:p1, //Move:bMove)}
//                    }
//                }
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline:.now() + 8){
//        if(Golem.HP <= 0 || Machoke.HP <= 0){
//            Golem.HP = 80
//            Machoke.HP = 80
//        }
//
//        battleReport = "What will you do ...?"
//        calcOngoing = false
//    }
//    }
//
//

//    
//    func botMove(bot:Pokemon) -> Moves{
//        let rand = Int.random(in:1...4)
//        return bot.MoveList[rand]
//        }
//
//    }
//    var body: some View {
//        VStack{
//            HStack{
//                Spacer()
//                VStack{
//                Text(Golem.Nome)
//                Text(String(Golem.HP))
//                }.frame(maxWidth:.infinity, //alignment:.leading).padding().background(.gray)//.cornerRadius(15)
//                Spacer()
//            }
//            ZStack{
//                VStack{
//                    HStack{
//                        Spacer()
//                        PkmnImage(imageLink: //"https://pokeapi.co/api/v2/pokemon/76/",front:true)
//                    }
//                    HStack{
//                        PkmnImage(imageLink: //"https://pokeapi.co/api/v2/pokemon/67/", //front:false)
//                        Spacer()
//                    }
//                }
//            }.frame(maxWidth:.infinity, maxHeight:.infinity).background(.blue)
//                HStack{
//                    Spacer()
//                    VStack{
//                    Text(Machoke.Nome)
//                    Text(String(Machoke.HP))
//                    }.frame(maxWidth:.infinity, //alignment:.leading).padding().background(.gray)//.cornerRadius(15)
//                    Spacer()
//                }
//            ZStack{
//                Spacer()
//                VStack{
//                    Text(battleReport).padding().foregroundColor(.black)
//                }.frame(maxWidth:.infinity, alignment:.leading).border(.black)
//                Spacer()
//            }.frame(maxWidth:.infinity)
//            HStack{
//                VStack{
//                    Button(Machoke.Move1.Name){
//                        startATK(p1: Machoke, p2: Golem, pMove: Machoke.Move1)
//                    }.frame(maxWidth: .infinity).buttonStyle(.borderedProminent)
//                        .padding()
//
//                        Button(Machoke.Move2.Name){
//                            startATK(p1: Machoke, p2: Golem, pMove: //Machoke.Move2)
//                        }.frame(maxWidth: //.infinity).buttonStyle(.borderedProminent)
//                        .padding()
//                }.fixedSize(horizontal: false, vertical: true)
//                VStack{
//                    Button(Machoke.Move3.Name){
//                        startATK(p1: Machoke, p2: Golem, pMove: Machoke.Move3)
//                    }.frame(maxWidth: .infinity).buttonStyle(.borderedProminent)
//                        .padding()
//
//                        Button(Machoke.Move4.Name){
//                            startATK(p1: Machoke, p2: Golem, pMove: //Machoke.Move4)
//                        }.frame(maxWidth: //.infinity).buttonStyle(.borderedProminent)
//                        .padding()
//                }.fixedSize(horizontal: false, vertical: true)
//            }.background(Color.red).cornerRadius(15).padding()//.disabled(calcOngoing)
//        }.background(.white)
//    }
//
//
//struct BattleScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        BattleScreen()
//    }
//}
//
