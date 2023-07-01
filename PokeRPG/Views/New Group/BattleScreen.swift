import SwiftUI

struct BattleScreen: View {
    @StateObject var viewModel = BattleUtils(team1:PokemonTeam(),team2:PokemonTeam())
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    VStack{//Adv info
                        Text(viewModel.BotTeam.Pkmn[viewModel.botPkmNo].Nome)
                        Text("HP: \(viewModel.BotTeam.Pkmn[viewModel.botPkmNo].HP) / \(viewModel.BotTeam.Pkmn[viewModel.botPkmNo].FullHP)")
                    }.padding().background(.white).cornerRadius(15)
                }.padding()
                VStack{
                    //Imagem Adv
                    HStack{
                        Spacer()
                        PkmnImage(imageLink:viewModel.BotTeam.Pkmn[viewModel.botPkmNo].imgURL, front:true)
                    }
                    //Imagem User
                    HStack{
                        PkmnImage(imageLink:viewModel.UserTeam.Pkmn[viewModel.userPkmNo].imgURL, front:false)
                        Spacer()
                    }
                }
                HStack{
                    VStack{
                        Text(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome)
                        Text("HP: \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].HP) / \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].FullHP)")
                    }.padding().background(.white).cornerRadius(15)
                    Spacer()
                }.padding()
                Spacer()
            }.background(.green).padding([.trailing, .leading])
            Divider()
            //Descricao
            HStack{
                Text(viewModel.battleReport).onAppear{
                    viewModel.battleReport = "A wild \(viewModel.BotTeam.Pkmn[viewModel.botPkmNo].Nome) appeared!"
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        viewModel.enableAction = false
                        viewModel.battleReport = "What will \(viewModel.UserTeam.Pkmn[viewModel.userPkmNo].Nome) do?"}
                }
            }.padding(.top)
            if viewModel.screenView == true{
                showUserMoves(viewModel:viewModel)
                
            }else{
                SelectAction(viewModel:viewModel).onAppear{
                    if viewModel.battleEnd{
                        viewModel.endBattle()
                    }
            }
            }
            NavigationLink("", destination:TeamViewer(), isActive: $viewModel.gotoTeam)
            NavigationLink("", destination:HomeScreen(), isActive: $viewModel.goEscape)
        }.navigationBarHidden(true)
    }
    
    struct BattleScreen_Previews: PreviewProvider {
        static var previews: some View {
            BattleScreen()
        }
    }
}
