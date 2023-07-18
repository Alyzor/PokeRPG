//
//  CreateName.swift
//  PokeRPG
//
//  Created by Alyzor on 03/07/2023.
//

import SwiftUI

struct CreateName: View {
    @State var gotoStarter = false
    @AppStorage("Name") var userName = ""
    @AppStorage("Gender") var userGender = ""
    @AppStorage("userWallet") var userWallet = 0
    var body: some View {
        VStack{
            Text("I see... What is your name?")
            Image("pkmn"+userGender).resizable().scaledToFill().frame(width:160,height:160).border(.gray).background(.red.opacity(0.6))
            Form{
                TextField("Username",text:self.$userName.max(16))
            }
            Button("Save Character"){
                userWallet = 20
                gotoStarter = true
            }.disabled(userName == "")
            NavigationLink("", destination:SelectStarter(), isActive: $gotoStarter)
        }
    }
}

struct CreateName_Previews: PreviewProvider {
    static var previews: some View {
        CreateName()
    }
}
