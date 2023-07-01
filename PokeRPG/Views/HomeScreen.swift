//
//  MainScreen.swift
//  PokeRPG
//
//  Created by Alyzor on 13/06/2023.
//

import SwiftUI

struct HomeScreen: View {
    @State var selectedView = 2
    var body: some View {
        TabView(selection:$selectedView){
            TeamViewer()
                .tabItem{
                    Image(systemName:"archivebox.fill")
                    Text("Team")
                }.tag(1)
            LocationLister()
                .tabItem{
                    Image(systemName:"leaf.fill")
                    Text("Explore")
                }.tag(2)
            Hospital()
                .tabItem{
                    Image(systemName:"cross.vial.fill")
                    Text("Pokemon Center")
                }.tag(3)
            Shop()
                .tabItem{
                    Image(systemName: "bag.circle.fill")
                    Text("PokéMart")
                }.tag(4)
        }.navigationBarHidden(true).accentColor(.red)
    }
}
struct TeamViewer: View {
    var userTeam = TeamUtils().getTeam()
    var body: some View {
        VStack(spacing:0){
            Header()
            NavigationView{
                List{
                    ForEach(userTeam.Pkmn){pokemon in
                        HStack{
                            PkmnImage(imageLink: pokemon.imgURL, front: true, dex: true)
                            NavigationLink(pokemon.Nome.capitalized, destination:PokemonTeamDetails(selPkmn: pokemon))
                        }
                    }
                }.navigationTitle("Your Team")
            }
            Spacer()
        }
    }
}

struct LocationLister: View {
    var pokemonTeam = TeamUtils().getTeam()
    @State var gotoBattle = false
    @State var sentPokemon:Int = 0
    var body: some View {
        VStack{
            Header()
            HStack{Spacer()
                VStack{
                    Spacer()
                    Text("Vai pá gerra.")
                    Button("Torrada"){
                        for pkmn in pokemonTeam.Pkmn.indices{
                            if pokemonTeam.Pkmn[pkmn].HP > 0{
                                sentPokemon = pkmn
                                gotoBattle = true
                                break
                            }
                            else{
                                sentPokemon = -1
                            }
                        }
                        if sentPokemon == -1{
                            Alert(title: Text("No Pokemon left!"), message: Text("You don't have any Pokemon capable to fight!"), dismissButton: .default(Text("OK!"))
                            )
                        }
                    }
                    NavigationLink("", destination:BattleScreen(viewModel:BattleUtils(team1:pokemonTeam, team2:pokemonTeam)), isActive: $gotoBattle)
                    Spacer()
                }
                Spacer()
            }.background(.gray.opacity(0.1))
            Spacer()
        }
    }
}
struct Hospital: View {
    var body: some View {
        VStack{
            Header()
            HStack{Spacer()
                VStack{
                    Spacer()
                    Text("Main content goes here")
                    Spacer()
                }
                Spacer()
            }.background(.gray.opacity(0.1))
            Spacer()
        }
    }
}
struct Shop: View {
    var body: some View {
        VStack{
            Header()
            HStack{Spacer()
                VStack{
                    Spacer()
                    Text("Main content goes here")
                    Spacer()
                }
                Spacer()
            }.background(.gray.opacity(0.1))
            Spacer()
        }
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
