//
//  CreateUser.swift
//  PokeRPG
//
//  Created by Alyzor on 13/06/2023.
//

import SwiftUI

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

struct CreateUser: View {
    @State var genders = ["Boy", "Girl"]
    @State var selGender = "Boy"
    @State var gotoName = false
    @AppStorage("Name") var userName = ""
    @AppStorage("Gender") var userGender = ""
    var body: some View {
        VStack{
            Text("Are you a boy or a girl?")
            Image("pkmn"+selGender).resizable().scaledToFill().frame(width:160,height:160).border(.gray).background(.red.opacity(0.6))
            Picker("Gender", selection:$selGender){
                ForEach(genders, id:\.self){
                    Text($0)
                }
            }.pickerStyle(.segmented).padding()
            Button("Continue"){
                gotoName = true
                userGender = selGender
            }
            NavigationLink("", destination:CreateName(), isActive:$gotoName)
        }.navigationBarHidden(true)
    }
}

struct CreateUser_Previews: PreviewProvider {
    static var previews: some View {
        CreateUser()
    }
}
