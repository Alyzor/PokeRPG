//
//  BagViewer.swift
//  PokeRPG
//
//  Created by Alyzor on 14/07/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct BagViewer: View {
    @StateObject var vModel = HomeScreenViewModel(team:PokemonTeam())
    var body: some View {
        VStack(spacing:0){
            Header()
            NavigationView{
                List{
                    ForEach(vModel.userBag.items, id:\.self){ itm in
                        if itm.amount >= 1 {
                        HStack{
                            WebImage(url: URL(string: itm.item.imgLink)).resizable().scaledToFit().frame(width:50, height:50)
                            VStack{
                                Text(itm.item.name).frame(maxWidth:.infinity, maxHeight:.infinity, alignment:.leading)
                                Divider()
                                Text("Amount in bag: \(itm.amount)").frame(maxWidth:.infinity, maxHeight:.infinity, alignment:.leading).font(.caption)
                            }
                        }
                    }
                    }
                }.navigationTitle("Your Bag")
            }
            Spacer()
        }
    }
}

struct BagViewer_Previews: PreviewProvider {
    static var previews: some View {
        BagViewer()
    }
}
