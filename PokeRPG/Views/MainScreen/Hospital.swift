//
//  Hospital.swift
//  PokeRPG
//
//  Created by Alyzor on 14/07/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct Hospital: View {
    @StateObject var vModel = HomeScreenViewModel(team:PokemonTeam(),PC:PokemonTeam())
        @AppStorage("userWallet") var wallet = 0
    @State var noMoney = false
    @State var gotoPC = false
    var body: some View {
        VStack{
            Header()
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    Text("Heal your team!\n(5$ needed)")
                    Spacer()
                    HStack{
                        Spacer()
                        WebImage(url: vModel.getHealImg()).resizable().scaledToFit().border(.black).padding()
                        Spacer()
                    }
                    Spacer()
                    Button("Heal"){
                        if wallet >= 5{
                            vModel.RunHeal()
                        }else{
                            noMoney = true
                        }
                    }.buttonStyle(.borderedProminent).controlSize(.large).accentColor(.red)
                    .alert(isPresented:$noMoney){
                        Alert(title: Text("You don't have enough money!"), dismissButton: .default(Text("OK")))
                    }.disabled(vModel.healing)
                    Button("Check PC"){
                        gotoPC = true
                    }
                    Spacer()
                }
                Spacer()
            }.background(.gray.opacity(0.1))
            Spacer()
            NavigationLink("", destination:UserPC(vModel:vModel), isActive: $gotoPC)
        }
    }
}

struct Hospital_Previews: PreviewProvider {
    static var previews: some View {
        Hospital()
    }
}
