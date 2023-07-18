//
//  DiscardMove.swift
//  PokeRPG
//
//  Created by Alyzor on 14/07/2023.
//

import SwiftUI

struct DiscardMove: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = BattleUtils(team1:PokemonTeam(),team2:PokemonTeam(), userPkmNo: 0)
    @State var delete0 = false
    @State var delete1 = false
    @State var delete2 = false
    @State var delete3 = false
    var body: some View {
        HStack(spacing:0){
            Button{
                self.presentationMode.wrappedValue.dismiss()
                viewModel.exitDiscard()
            }label:{
                Text("< Back").padding().font(.title3).frame(maxWidth:.infinity, maxHeight:20, alignment:.leading)
            }
        }
        Divider()
        Spacer()
        Group{
        VStack{
            Text("New Move:").font(.title3).padding().frame(maxWidth:.infinity, maxHeight:20, alignment:.leading)
            Divider()
                HStack{
                    Image(systemName:getTypeImage(type: viewModel.tempMove.pType)).foregroundColor(Color(hex: getTypeColor(type: viewModel.tempMove.pType))).padding()
                    Text(viewModel.tempMove.Name.capitalized).padding().frame(maxWidth:.infinity).padding()
                    VStack{
                        Text("PP: \(viewModel.tempMove.pp) / \(viewModel.tempMove.maxPP)")
                        Divider()
                        Text("Accuracy: \(viewModel.tempMove.acc)")
                    }
                    Spacer()
                }
        }
            Divider()
            Spacer()
            Text("Current Moves:").font(.title3).frame(maxWidth:.infinity, maxHeight:20, alignment:.leading)
            Group{
            Divider()
                    Button{
                        delete0 = true
                    } label:{
                    HStack{
                    Spacer()
                    Image(systemName:getTypeImage(type: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].pType))
                        .foregroundColor(Color(hex: getTypeColor(type: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].pType)))
                        .padding()
                    Text(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].Name.capitalized)
                        .padding().frame(maxWidth:.infinity).padding()
                    VStack{
                        Text("PP: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].pp) / \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].maxPP)")
                        Divider()
                        Text("Accuracy: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].acc)")
                    }
                    }
                    }.alert(isPresented: $delete0){
                        Alert(title: Text("Do you want \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) to forget \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[0].Name.capitalized)?"), primaryButton: .destructive(Text("Yes")){
                            viewModel.replaceMove(move:0)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        , secondaryButton: .default(Text("No")))
                    }
                Divider()
            
                
                
                Button{
                    delete1 = true
                } label:{
                HStack{
                    Spacer()
                    Image(systemName:getTypeImage(type: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].pType))
                        .foregroundColor(Color(hex: getTypeColor(type: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].pType)))
                        .padding()
                    Text(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].Name.capitalized)
                        .padding().frame(maxWidth:.infinity).padding()
                    VStack{
                        Text("PP: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].pp) / \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].maxPP)")
                        Divider()
                        Text("Accuracy: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].acc)")
                    }
                }
                    }.alert(isPresented: $delete1){
                        Alert(title: Text("Do you want \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) to forget \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[1].Name.capitalized)?"), primaryButton: .destructive(Text("Yes")){
                            viewModel.replaceMove(move:1)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        , secondaryButton: .default(Text("No")))
                    }
                Divider()
            
                
                
                Button{
                    delete2 = true
                } label:{
                HStack{
                    Spacer()
                    Image(systemName:getTypeImage(type: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].pType))
                        .foregroundColor(Color(hex: getTypeColor(type: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].pType)))
                        .padding()
                    Text(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].Name.capitalized)
                        .padding().frame(maxWidth:.infinity).padding()
                    VStack{
                        Text("PP: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].pp) / \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].maxPP)")
                        Divider()
                        Text("Accuracy: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].acc)")
                    }
                    
                }
                    }.alert(isPresented: $delete2){
                        Alert(title: Text("Do you want \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) to forget \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[2].Name.capitalized)?"), primaryButton: .destructive(Text("Yes")){
                            viewModel.replaceMove(move:2)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        , secondaryButton: .default(Text("No")))
                    }
                }
                Divider()
            
            
            Button{
                delete3 = true
            } label:{
                HStack{
                    Spacer()
                    Image(systemName:getTypeImage(type: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].pType))
                        .foregroundColor(Color(hex: getTypeColor(type: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].pType)))
                        .padding()
                    Text(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].Name.capitalized)
                        .padding().frame(maxWidth:.infinity).padding()
                    VStack{
                        Text("PP: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].pp) / \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].maxPP)")
                        Divider()
                        Text("Accuracy: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].acc)")
                    }
                    }
                    }.alert(isPresented: $delete3){
                        Alert(title: Text("Do you want \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) to forget \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].MoveList[3].Name.capitalized)?"), primaryButton: .destructive(Text("Yes")){
                            viewModel.replaceMove(move:3)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        , secondaryButton: .default(Text("No")))
                    }
                Divider()
                Spacer()
        }.navigationBarHidden(true)
    }
}

struct DiscardMove_Previews: PreviewProvider {
    static var previews: some View {
        DiscardMove()
    }
}
