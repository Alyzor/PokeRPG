//
//  Shop.swift
//  PokeRPG
//
//  Created by Alyzor on 14/07/2023.
//

import SwiftUI
import SDWebImageSwiftUI
struct Shop: View {
    @StateObject var vModel = HomeScreenViewModel(team:PokemonTeam(),PC:PokemonTeam())
    @State var showAlert = false
    var body: some View {
        VStack(spacing:0){
            Header()
            NavigationView{
                List{
                    ForEach(vModel.userBag.items.indices, id:\.self){ itm in
                        HStack{
                            WebImage(url: URL(string: vModel.userBag.items[itm].item.imgLink)).resizable().scaledToFit().frame(width:50, height:50)
                            VStack{
                                Text(vModel.userBag.items[itm].item.name).frame(maxWidth:.infinity, maxHeight:.infinity, alignment:.leading)
                                Divider()
                                Text("Amount in bag: \(vModel.userBag.items[itm].amount)").frame(maxWidth:.infinity, maxHeight:.infinity, alignment:.leading).font(.caption)
                            }
                            Text("\(vModel.userBag.items[itm].item.cost)$")
                            Button{
                                if vModel.userBag.items[itm].item.cost > vModel.wallet{
                                    showAlert = true
                                }else{
                                    vModel.userBag.items[itm].amount += 1
                                    vModel.wallet -= vModel.userBag.items[itm].item.cost 
                                    TeamUtils().saveBag(userBag: vModel.userBag)
                                }
                            }label:{
                                Image(systemName: "plus").tint(.blue)
                            }.alert(isPresented: $showAlert){
                                Alert(title:Text("Not enough money!"), message:Text("You don't have enough money to buy a \(vModel.userBag.items[itm].item.name)!"), dismissButton: .default(Text("OK!")))
                            }
                        }
                    }
                }.navigationTitle("PokéMart!")
            }
            Spacer()
        }
    }
    
}

struct Shop_Previews: PreviewProvider {
    static var previews: some View {
        Shop()
    }
}
