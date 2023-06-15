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
    var body: some View{
        VStack(spacing:0){
            HStack(spacing:0){
                Spacer()
                Text("PokeRPG").font(.largeTitle.bold()).padding()
                Spacer()
                HStack{
                    Image("pkmn\(Gender)").resizable().frame(width: 75, height: 75)
                    Text(userName).font(.system(size:12).bold())
                }
                Spacer()
            }
            Divider()
        }
        
    }
}
struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
