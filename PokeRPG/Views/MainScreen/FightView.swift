//
//  FightView.swift
//  PokeRPG
//
//  Created by Alyzor on 14/07/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct FightView: View {
    @StateObject var vModel = HomeScreenViewModel(team:PokemonTeam(), PC:PokemonTeam())
    @AppStorage("Gender") var gender = ""
    var body: some View {
        VStack{
            Header()
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    Text("Grab your team and fight!")
                    WebImage(url:Bundle.main.url(forResource: "encounter\(gender)", withExtension: "gif")).resizable().scaledToFit().border(.black).padding()
                    HStack{
                        Spacer()
                        ForEach((0...5), id: \.self){i in
                            if vModel.UserTeam.Pkmn.indices.contains(i){
                            PkmnImage(imageLink: vModel.UserTeam.Pkmn[i].imgURL, front: true, dex: true).background(Color.init(hex: getTypeColor(type: vModel.UserTeam.Pkmn[i].type1))).clipShape(Circle()).padding(2)
                                Spacer()
                            }else{
                                Image("pokeball").resizable().scaledToFit().background(.white).clipShape(Circle()).padding(2)
                                Spacer()
                            }
                        }
                    }.background(.gray).cornerRadius(5).padding(5)
                    Spacer()
                    Button("Fight!"){
                        vModel.checkFaint()
                    }.buttonStyle(.borderedProminent).controlSize(.large).tint(.red).alert(isPresented: $vModel.teamFainted){
                        Alert(title: Text("No Pokemon left!"), message: Text("You don't have any Pokemon capable to fight!"), dismissButton: .default(Text("OK!"))
                              )
                    }
                    Spacer()
                    NavigationLink("", destination:BattleScreen(viewModel:BattleUtils(team1:vModel.UserTeam, team2:vModel.botTeam, userPkmNo:vModel.selPkm)), isActive: $vModel.gotoBattle)
                }
                Spacer()
            }.background(.gray.opacity(0.1))
            Spacer()
        }
    }
}

struct FightView_Previews: PreviewProvider {
    static var previews: some View {
        FightView()
    }
}
