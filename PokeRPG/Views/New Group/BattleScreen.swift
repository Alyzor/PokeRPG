import SwiftUI
import UIKit
import SDWebImageSwiftUI
struct BattleScreen: View {
    @StateObject var viewModel = BattleUtils(team1:PokemonTeam(),team2:PokemonTeam(), userPkmNo:Int())
    
    var body: some View {
        VStack{
            Spacer()
            ZStack{
                Image("battleBackground").resizable().scaledToFill().frame(width:400, height:550, alignment:.bottomTrailing).clipped().cornerRadius(15)
            VStack{
                Spacer()
                
                HStack{
                    VStack{
                    HStack{
                        Spacer()
                        HStack{
                        ForEach((0...5), id: \.self){i in
                            if viewModel.BotTeam.Pkmn.indices.contains(i){
                                if viewModel.BotTeam.Pkmn[i].HP > 0{
                                    Image("pokeball").resizable().scaledToFit().frame(width:15,height:15)
                                }else{
                                    Image("pokeball").resizable().scaledToFit().frame(width:15,height:15).grayscale(0.5)
                                }
                            }else{
                                Image("pokeball").resizable().scaledToFit().background(.black).frame(width:15,height:15).grayscale(1).clipShape(Circle())
                            }
                        }
                        }.padding(2).background(.white).cornerRadius(15)
                        Text(viewModel.BotTeam.Pkmn[viewModel.botPkmNo].Nome)
                        Text("Lv: \(viewModel.BotTeam.Pkmn[viewModel.botPkmNo].Lvl)")
                        Spacer()
                    }
                    HStack{
                        Text("HP: ")
                        ProgressView(value:Float(viewModel.BotTeam.Pkmn[viewModel.botPkmNo].HP),total:Float(viewModel.BotTeam.Pkmn[viewModel.botPkmNo].permaStats.HP))
                    }
                    }.foregroundColor(.white).padding().background(Color.init(hex:getTypeColor(type: viewModel.BotTeam.Pkmn[viewModel.botPkmNo].type1))).cornerRadius(15)
                    Spacer()
                }.padding()
                VStack{
                    //Imagem Adv
                    HStack{
                        Spacer()
                        WebImage(url:URL(string:viewModel.BotTeam.Pkmn[viewModel.botPkmNo].Sprites.front_default)).resizable()
                            .aspectRatio(contentMode:.fit)
                            .frame(width:150,height:150,alignment: .trailing)
                    }
                    //Imagem User
                    HStack{
                        WebImage(url:URL(string:viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Sprites.back_default)).resizable()
                            .aspectRatio(contentMode:.fit)
                            .frame(width:150,height:150,alignment: .trailing)
                        Spacer()
                    }
                }
                HStack{
                    VStack{
                    HStack{
                        Text(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome)
                        Text("Lv: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Lvl)")
                        Spacer()
                        HStack{
                        ForEach((0...5), id: \.self){i in
                            if viewModel.UserTeam.Pkmn.indices.contains(i){
                                if viewModel.UserTeam.Pkmn[i].HP > 0{
                                    Image("pokeball").resizable().scaledToFit().frame(width:15,height:15)
                                }else{
                                    Image("pokeball").resizable().scaledToFit().frame(width:15,height:15).grayscale(0.5)
                                }
                            }else{
                                Image("pokeball").resizable().scaledToFit().background(.black).frame(width:15,height:15).grayscale(1).clipShape(Circle())
                            }
                        }
                        }.padding(2).background(.white).cornerRadius(15)
                        Spacer()
                    }
                    HStack{
                        Text("HP: ")
                        ProgressView(value:Float(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].HP),total:Float(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].permaStats.HP))
                    }
                    }.foregroundColor(.white).padding().background(Color.init(hex:getTypeColor(type: viewModel.UserTeam.Pkmn[viewModel.userPkmNo].type1))).cornerRadius(15)
                    Spacer()
                }.padding()
                Spacer()
            }.padding([.trailing, .leading])
            }
            Spacer()
            Divider()
            //Descricao
            HStack{
                Text(viewModel.battleReport).onAppear{
                    if viewModel.battleStart{
                    print(viewModel.BotTeam)
                    viewModel.battleReport = "A wild \(viewModel.BotTeam.Pkmn[viewModel.botPkmNo].Nome) appeared!"
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        viewModel.enableAction = false
                        viewModel.battleReport = "What will \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) do?"
                        viewModel.battleStart = false
                    }
                    }
                }
            }.padding(.top)
            if viewModel.screenView == true{
                showUserMoves(viewModel:viewModel)
                
            }else{
                SelectAction(viewModel:viewModel).onAppear{
                    if viewModel.finished{
                        viewModel.endBattle()
                    }
            }
            }
            NavigationLink("", destination:SwitchPokemon(vModel: viewModel), isActive: $viewModel.gotoTeam)
            NavigationLink("", destination:UserBag(vModel: viewModel), isActive: $viewModel.gotoBag)
            NavigationLink("", destination:HomeScreen(), isActive: $viewModel.goEscape)
            NavigationLink("", destination:DiscardMove(viewModel: viewModel), isActive: $viewModel.moveCap)
        }.navigationBarHidden(true)
    }
    
    struct BattleScreen_Previews: PreviewProvider {
        static var previews: some View {
            BattleScreen()
        }
    }
}
