//
//  showUserMoves.swift
//  PokeRPG
//
//  Created by Alyzor on 25/06/2023.
//

import SwiftUI

struct showUserMoves: View {
    
    @StateObject var viewModel = BattleUtils(team1:PokemonTeam(), team2:PokemonTeam(), userPkmNo:0)
    @State var move1 = "Locked"
    @State var move2 = "Locked"
    @State var move3 = "Locked"
    
    var body: some View{
        VStack{
            HStack{
                Button{
                    if viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].pp == 0{
                        viewModel.battleReport = "This move has no PP left!"
                        viewModel.changeBtnState(state: true)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            viewModel.changeBtnState(state: false)
                            viewModel.battleReport = "What wil \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) do?"
                        }
                    }else{
                        viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].pp -= 1
                        viewModel.startATK(selMove: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0])
                    }
                } label: {
                    VStack{
                        Text(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].Name.capitalized)
                        Text("PP: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].pp) / \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].maxPP)")
                    }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(viewModel.isDisabledMain)
                Divider()
                Button{
                    if viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].pp == 0{
                        viewModel.battleReport = "This move has no PP left!"
                        viewModel.changeBtnState(state: true)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            viewModel.changeBtnState(state: false)
                            viewModel.battleReport = "What wil \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) do?"
                        }
                    }else{
                        viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].pp -= 1
                        viewModel.startATK(selMove: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1])
                    }
                } label: {
                    VStack{
                        Text(move1.capitalized)
                        if move1 != "Locked"{
                            Text("PP: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].pp) / \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].maxPP)")
                        }
                    }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(viewModel.isDisabledOne)
            }
            Divider()
            HStack{
                Button{
                    if viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].pp == 0{
                        viewModel.battleReport = "This move has no PP left!"
                        viewModel.changeBtnState(state: true)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            viewModel.changeBtnState(state: false)
                            viewModel.battleReport = "What wil \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) do?"
                        }
                    }else{
                        viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].pp -= 1
                        viewModel.startATK(selMove: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2])
                    }
                } label: {
                    VStack{
                        Text(move2.capitalized)
                        if move2 != "Locked"{
                            Text("PP: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].pp) / \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].maxPP)")
                        }
                    }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(viewModel.isDisabledTwo)
                Divider()
                Button{
                    if viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].pp == 0{
                        viewModel.battleReport = "This move has no PP left!"
                        viewModel.changeBtnState(state: true)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            viewModel.changeBtnState(state: false)
                            viewModel.battleReport = "What wil \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) do?"
                        }
                    }else{
                        viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].pp -= 1
                        viewModel.startATK(selMove: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3])
                    }
                } label: {
                    VStack{
                        Text(move3.capitalized)
                        if move3 != "Locked"{
                            Text("PP: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].pp) / \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].maxPP)")
                        }
                    }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(viewModel.isDisabledThree)
            }
        }.background(.red).foregroundColor(.white).cornerRadius(5).padding().onAppear{
            if viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList.indices.contains(1){
                move1 = viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].Name
                viewModel.isDisabledOne = false
            }
            if viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList.indices.contains(2){
                move2 = viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].Name
                viewModel.isDisabledTwo = false
            }
            if viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList.indices.contains(3){
                move3 = viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].Name
                viewModel.isDisabledThree = false
            }
        }
        Button("Go Back"){viewModel.screenView = false}.buttonStyle(.borderedProminent).tint(.red).disabled(viewModel.isDisabledMain)
    }
}


