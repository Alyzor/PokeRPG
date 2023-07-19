//
//  MainScreen.swift
//  PokeRPG
//
//  Created by Alyzor on 13/06/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeScreen: View {
    @StateObject var vModel = HomeScreenViewModel(team:TeamUtils().getTeam(), PC:TeamUtils().getUserPC())
    @State var selectedView = 2
    var body: some View {
        TabView(selection:$selectedView){
            TeamViewer(vModel: vModel)
                .tabItem{
                    Image(systemName:"archivebox.fill")
                    Text("Team")
                }.tag(1)
            FightView(vModel: vModel)
                .tabItem{
                    Image(systemName:"leaf.fill")
                    Text("Explore")
                }.tag(2)
            Hospital(vModel: vModel)
                .tabItem{
                    Image(systemName:"cross.vial.fill")
                    Text("Pokemon Center")
                }.tag(3)
            BagViewer(vModel: vModel)
                .tabItem{
                    Image(systemName: "backpack.fill")
                    Text("Bag")
                }.tag(4)
            Shop(vModel: vModel)
                .tabItem{
                    Image(systemName: "bag.circle.fill")
                    Text("PokéMart")
                }.tag(5)
        }.navigationBarHidden(true).accentColor(.red)
    }
}

struct Header: View{
    @AppStorage("Name") var userName = "PlaceHolder"
    @AppStorage("Gender") var Gender = "Boy"
    @AppStorage("userWallet") var userWallet = 0
    @State var gotoSettings=false
    var body: some View{
        VStack(spacing:0){
            HStack(spacing:0){
                Spacer()
                Text("PokeRPG").font(.largeTitle.bold()).padding()
                Spacer()
                HStack{
                    Button(action:{
                        gotoSettings = true
                    })
                    {
                        Image("pkmn\(Gender)").resizable().frame(width: 75, height: 75)
                        
                    }
                    VStack{
                    Text(userName).font(.system(size:12).bold())
                    Text("\(String(userWallet)) $").font(.system(size:12).bold())
                    }
                    NavigationLink("", destination:SettingsView(), isActive: $gotoSettings)
                }
                Spacer()
            }
            Divider()
        }
        
    }
}

struct SettingsView:View{
    @State var showDialog = false
    @State var gotoStart = false
    @AppStorage("Name") var userName = "PlaceHolder"
    @AppStorage("Gender") var Gender = "Boy"
    var body: some View{
        List{
            Button("Delete Save", role: .destructive) {
                showDialog = true
            }
            .confirmationDialog("Are you sure?",
                                isPresented: $showDialog) {
                Button("Delete Save Data", role: .destructive) {
                    TeamUtils().deleteSave()
                    gotoStart = true
                    userName = ""
                    Gender = ""
                }
            }
        }.navigationTitle("Settings")
        NavigationLink("", destination:StartScreen(), isActive:$gotoStart)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
