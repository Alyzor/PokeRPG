//
//  PokemonTeamDetails.swift
//  PokeRPG
//
//  Created by Alyzor on 15/06/2023.
//

import SwiftUI

struct PokemonTeamDetails: View {
    @State var selPkmn:Pokemon = Pokemon()
    @State var currentXP:Float = 0
    @State var maxXP:Float = 0
    var body: some View {
        VStack{
            HStack(spacing:0){
                VStack{
                    PkmnImage(imageLink:selPkmn.imgURL, front:true, dex:false, pad:true)
                    Text("Level: \(selPkmn.Lvl)")
                Text("#\(String(format: "%03d", selPkmn.dexNumber))/#151")
                }
                VStack{
                    Text("Main stats").font(.title3).bold().padding()
                    HStack{
                        VStack(alignment: .leading, spacing:0){
                            Text("HP: \(selPkmn.HP) / \(selPkmn.permaStats.HP)")
                        Text("ATK: \(selPkmn.ATK)")
                        Text("DEF: \(selPkmn.DEF)")
                        }.padding()
                        Divider()
                        VStack(alignment: .leading, spacing:0){
                        Text("SpATK: \(selPkmn.spATK)")
                        Text("SpDEF: \(selPkmn.spDEF)")
                        Text("SPD: \(selPkmn.SPD)")
                        }.padding()
                    }.background(.gray.opacity(0.2)).frame(maxHeight:100).padding()
                }
            }
            HStack{
                Spacer()
                Text("XP:")
                ProgressView(value:currentXP, total:maxXP)
                Spacer()
            }
            Divider()
            MoveView(selMoves:selPkmn.MoveList)
        }.onAppear{
            currentXP = Float(selPkmn.currentXP - Int(pow(Double(selPkmn.Lvl - 1), 3)))
            maxXP = Float(pow(Double(selPkmn.Lvl), 3) - pow(Double(selPkmn.Lvl - 1), 3))
        }
        .background(.gray.opacity(0.1))
        .navigationBarTitle("\(selPkmn.Nome.capitalized)'s details")
    }
}

struct MoveView:View{
    var selMoves:[Moves] = [Moves]()
    var body: some View{
        ScrollView{
        HStack{
            Text("Moves").font(.title).bold().padding()
            Spacer()
        }
        VStack{
        ForEach(selMoves){move in
            HStack{
                Spacer()
                Image(systemName:getTypeImage(type: move.pType)).foregroundColor(Color(hex: getTypeColor(type: move.pType))).padding()
                Text(move.Name.capitalized).padding().frame(maxWidth:.infinity).padding()
                VStack{
                    Text("PP: \(move.pp) / \(move.maxPP)")
                    Divider()
                    Text("Accuracy: \(move.acc)")
                }
                Spacer()
            }
            Divider()
        }
        }.background(.white).cornerRadius(15)
    }
    }
}

struct PokemonTeamDetails_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTeamDetails()
.previewInterfaceOrientation(.portrait)
    }
}
