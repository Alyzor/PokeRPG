//
//  UserBag.swift
//  PokeRPG
//
//  Created by Alyzor on 14/07/2023.
//

import SwiftUI
import SDWebImageSwiftUI
struct UserBag: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vModel =  BattleUtils(team1:PokemonTeam(),team2:PokemonTeam(), userPkmNo: 0)
    @State var showAlert = false
    var body: some View {
        NavigationView{
            List{
                ForEach(vModel.userBag.items.indices, id:\.self){i in
                    if vModel.userBag.items[i].amount >= 1 {
                        Button{
                            if vModel.UserTeam.Pkmn[vModel.userPkmNo].HP != vModel.UserTeam.Pkmn[vModel.userPkmNo].permaStats.HP || vModel.userBag.items[i].item.isPokeball{
                                self.presentationMode.wrappedValue.dismiss()
                                vModel.useItem(item: i)
                            }else{
                                showAlert = true
                            }
                        } label:{
                            HStack{
                                WebImage(url: URL(string: vModel.userBag.items[i].item.imgLink)).resizable().scaledToFit().frame(width:50, height:50)
                                VStack{
                                    Text(vModel.userBag.items[i].item.name).frame(maxWidth:.infinity, maxHeight:.infinity, alignment:.leading)
                                    Divider()
                                    Text("Amount in bag: \(vModel.userBag.items[i].amount)").frame(maxWidth:.infinity, maxHeight:.infinity, alignment:.leading).font(.caption)
                                }
                            }
                        }.alert(isPresented:$showAlert){
                            Alert(title:Text("Full HP!"), message:Text("Your Pokémon has full HP!"), dismissButton: .default(Text("OK!")))
                        }
                    }
                }
            }
        }.navigationTitle("Your Bag")
    }
}

struct UserBag_Previews: PreviewProvider {
    static var previews: some View {
        UserBag()
    }
}
