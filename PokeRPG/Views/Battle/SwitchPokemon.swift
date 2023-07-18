//
//  SwitchPokemon.swift
//  PokeRPG
//
//  Created by Alyzor on 10/07/2023.
//

import SwiftUI

struct SwitchPokemon: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vModel =  BattleUtils(team1:PokemonTeam(),team2:PokemonTeam(), userPkmNo: 0)
    @State var pkmIndex = 0
    @State var checkDetails = false
    var body: some View {
        VStack{
            List{
                ForEach(vModel.UserTeam.Pkmn.indices) { pkm in
                HStack{
                    PkmnImage(imageLink: vModel.UserTeam.Pkmn[pkm].imgURL, front: true, dex: false, pad: true)
                    Spacer()
                    Text(vModel.UserTeam.Pkmn[pkm].Nome)
                    Spacer()
                    Text("HP: \(vModel.UserTeam.Pkmn[pkm].HP)/\(vModel.UserTeam.Pkmn[pkm].permaStats.HP)")
                    Spacer()
                    Image(systemName: "chevron.left").tint(Color(UIColor.lightGray))
                    Spacer()
                }.listRowBackground(Color.init(hex: getTypeColor(type: vModel.UserTeam.Pkmn[pkm].type1)))
                        .swipeActions(allowsFullSwipe:false) {
                        Button{
                            pkmIndex = pkm
                            checkDetails = true
                        } label: {
                            Image(systemName: "info.circle.fill")
                            Text("Check Pokemon Stats")
                        }.tint(.blue)
                        Button{
                            vModel.switchPokemon(pkmNo: pkm)
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.up")
                            Text("Send to battle")
                        }.tint(.yellow).disabled(vModel.userPkmNo == pkm)
                    }
                    
            }
            }
        }.navigationBarTitle("Switch Pokemon")
        NavigationLink("",destination:PokemonTeamDetails(selPkmn: vModel.UserTeam.Pkmn[pkmIndex]), isActive: $checkDetails)
    }
}


struct SwitchPokemon_Previews: PreviewProvider {
    static var previews: some View {
        SwitchPokemon()
    }
}
