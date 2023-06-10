//
//  ContentView.swift
//  PokeRPG
//
//  Created by Account1 on 07/06/2023.
//

import SwiftUI

struct ContentView: View {
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var contador = 0
    
    @State var Machoke = Pokemon(Nome: "Machoke", Lvl: 15, HP: 80, ATK: 100, DEF: 70, spATK: 50, spDEF: 60, type1: "fighting", Move1: Moves(Name:"Revenge", Power:60, pType:"fighting"), Move2: Moves(Name:"Knock Off", Power:65, pType:"dark"), Move3: Moves(Name:"Vital Throw", Power:70, pType:"fighting"), Move4: Moves(Name:"Strength", Power:80, pType:"normal"))
    
    @State var Golem = Pokemon(Nome: "Golem", Lvl: 16,HP: 80, ATK: 120, DEF: 130, spATK: 55, spDEF: 65, type1: "rock", type2:"ground", Move1: Moves(Name:"Rock Throw", Power:50, pType:"rock"), Move2: Moves(Name:"Tackle", Power:35, pType:"normal"), Move3: Moves(Name:"Earthquake", Power:100, pType:"ground"), Move4: Moves(Name:"Harden", Power:20, pType:"normal"))
    @State var firstCalc:Double = 0.0
    @State var secCalc:Double = 0.0
    @State var thirdCalc:Double = 0.0
    @State var fourthCalc:Double = 0.0
    @State var STAB = 0.0
    @State var type1DMG:Double = 0.0
    @State var type2DMG:Double = 0.0
    @State var finalDMG:Double = 0.0
    
    func resetDMG(){
        firstCalc = 0.0
        secCalc = 0.0
        thirdCalc = 0.0
        fourthCalc = 0.0
        type1DMG = 0.0
        type2DMG = 0.0
        finalDMG = 0.0
    }
    func CalcularDMG(ATK:Pokemon, DEF:Pokemon, Move:Moves) -> Int {
        resetDMG()
        firstCalc = ((2*Double(ATK.Lvl))/5)+2 //8
                
        secCalc = firstCalc * Double(Move.Power) * (Double(ATK.ATK)/Double(DEF.DEF))//369
        
        thirdCalc = (secCalc/50)+2 //9
        
        //verificar STAB (Same attack type bonus)
        if(ATK.type1 == Move.pType || ATK.type2 == Move.pType){
            STAB = 1.5
        }
        else{
            STAB = 1.0
        }
        //verifica o tipo do pokemon que ataca e o que defende, e o bonus a ser utilizado
        type1DMG = getTypeMultiplier(Type1: ATK.type1, Type2: DEF.type1)
            
            fourthCalc = thirdCalc*STAB*type1DMG
        
        //verificação de existência de tipos
        if(ATK.type2 != nil){
            if(DEF.type2 != nil){
                type2DMG = getTypeMultiplier(Type1: ATK.type2!, Type2: DEF.type2!)
                fourthCalc *= type2DMG
            }
            else{
                type2DMG = getTypeMultiplier(Type1: ATK.type2!, Type2: DEF.type1)
                fourthCalc *= type2DMG
            }
        }
        else if(DEF.type2 != nil){
            type2DMG = getTypeMultiplier(Type1: ATK.type1, Type2: DEF.type2!)
            fourthCalc *= type2DMG
        }
        
        
        finalDMG = (fourthCalc * Double(Int.random(in: 217...255)))/255
        
        return Int(finalDMG)
    }
    var body: some View {
        VStack{

            Text(Golem.Nome + " HP: \(String(Golem.HP))")
            Text(String(firstCalc))
            Text(String(secCalc))
            Text(String(thirdCalc))
            Spacer()
            Text(Machoke.Nome + " HP: \(String(Machoke.HP))")
            Spacer()
            VStack{
                HStack{
                    Button(Machoke.Move1.Name){
                        Golem.HP -= CalcularDMG(ATK:Machoke,DEF:Golem,Move:Machoke.Move1)
                        let rng = Int.random(in:1...4)
                        var gMove = Moves()
                        
                        switch rng{
                            case 1:
                                gMove = Golem.Move1
                            case 2:
                                gMove = Golem.Move2
                            case 3:
                                gMove = Golem.Move3
                            case 4:
                                gMove = Golem.Move4
                            default:
                            return
                        }
                        Machoke.HP -= CalcularDMG(ATK:Golem,DEF:Machoke,Move:gMove)
                    }.padding().buttonStyle(.borderedProminent)
                    
                        Button(Machoke.Move2.Name){
                            Golem.HP -= CalcularDMG(ATK:Machoke,DEF:Golem,Move:Machoke.Move2)
                            let rng = Int.random(in:1...4)
                            var gMove = Moves()
                            
                            switch rng{
                                case 1:
                                    gMove = Golem.Move1
                                case 2:
                                    gMove = Golem.Move2
                                case 3:
                                    gMove = Golem.Move3
                                case 4:
                                    gMove = Golem.Move4
                                default:
                                return
                            }
                            Machoke.HP -= CalcularDMG(ATK:Golem,DEF:Machoke,Move:gMove)
                        }.padding().buttonStyle(.borderedProminent)
                }
                HStack{
                    Button(Machoke.Move3.Name){
                        Golem.HP -= CalcularDMG(ATK:Machoke,DEF:Golem,Move:Machoke.Move1)
                        let rng = Int.random(in:1...4)
                        var gMove = Moves()
                        
                        switch rng{
                            case 1:
                                gMove = Golem.Move1
                            case 2:
                                gMove = Golem.Move2
                            case 3:
                                gMove = Golem.Move3
                            case 4:
                                gMove = Golem.Move4
                            default:
                            return
                        }
                        Machoke.HP -= CalcularDMG(ATK:Golem,DEF:Machoke,Move:gMove)
                    }.padding().buttonStyle(.borderedProminent)
                    
                        Button(Machoke.Move4.Name){
                            Golem.HP -= CalcularDMG(ATK:Machoke,DEF:Golem,Move:Machoke.Move2)
                            let rng = Int.random(in:1...4)
                            var gMove = Moves()
                            
                            switch rng{
                                case 1:
                                    gMove = Golem.Move1
                                case 2:
                                    gMove = Golem.Move2
                                case 3:
                                    gMove = Golem.Move3
                                case 4:
                                    gMove = Golem.Move4
                                default:
                                return
                            }
                            Machoke.HP -= CalcularDMG(ATK:Golem,DEF:Machoke,Move:gMove)
                        }.padding().buttonStyle(.borderedProminent)
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
