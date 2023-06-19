//
//  CreateUser.swift
//  PokeRPG
//
//  Created by Alyzor on 13/06/2023.
//

import SwiftUI

struct CreateName: View {
    @State var gotoStarter = false
    @AppStorage("Name") var userName = ""
    @AppStorage("Gender") var userGender = ""
    var body: some View {
        VStack{
            Text("I see... What is your name?")
            Image("pkmn"+userGender).resizable().scaledToFill().frame(width:160,height:160).border(.gray).background(.red.opacity(0.6))
            Form{
                TextField("",text:$userName)
            }
            Button("Save Character"){
                gotoStarter = true
            }.disabled(userName == "")
            NavigationLink("", destination:SelectStarter(), isActive: $gotoStarter)
        }
    }
}
func getStarter(selectedPokemon:Int, completion:@escaping (Bool) -> ()){
    var startTeam = Pokemon()
    @State var returnSafe = false
    PokeAPI().fetchPokemonData(SelUrl:"https://pokeapi.co/api/v2/pokemon/\(String(selectedPokemon))/"){ pokemon in
        startTeam.Nome = pokemon.name.capitalized
        startTeam.Lvl = 5
        startTeam.dexNumber = pokemon.id
        startTeam.type1 = pokemon.types![0].type.name
        startTeam.imgURL = "https://pokeapi.co/api/v2/pokemon/\(String(selectedPokemon))"
        //add ailment list
        
        
        if pokemon.types!.count == 2{
            startTeam.type2 = pokemon.types![1].type.name
        }
        //get Pokemon stats
        for pStat in pokemon.stats {
            switch pStat.stat.name{
            case "hp":
                startTeam.HP = pStat.base_stat
                startTeam.FullHP = pStat.base_stat
            case "attack":
                startTeam.ATK = pStat.base_stat
                startTeam.permaStats.ATK = pStat.base_stat
            case "defense":
                startTeam.DEF = pStat.base_stat
                startTeam.permaStats.DEF = pStat.base_stat
            case "special-attack":
                startTeam.spATK = pStat.base_stat
                startTeam.permaStats.spATK = pStat.base_stat
            case "special-defense":
                startTeam.spDEF = pStat.base_stat
                startTeam.permaStats.spDEF = pStat.base_stat
            default:
                startTeam.SPD = pStat.base_stat
                startTeam.permaStats.SPD = pStat.base_stat
            }
        }
        //get Moves under lv 5
        let group = DispatchGroup()
        let bgQueue = DispatchQueue.global()
        for mv in pokemon.moves{
            var selMove = Moves()
            if mv.version_group_details[0].move_learn_method.name != "level-up"{ continue }
            if mv.version_group_details[0].level_learned_at > 5{ continue }
            group.enter()
            selMove.Name = mv.move.name
            bgQueue.async(group: group,  execute: {
            PokeAPI().fetchMoveData(MoveURL:mv.move.url){fetchedMove in
                if fetchedMove.generation.name == "generation-i"{
                if fetchedMove.power != nil{
                    selMove.Power = fetchedMove.power!}
                selMove.pType = fetchedMove.type.name
                selMove.acc = fetchedMove.accuracy
                selMove.pp = fetchedMove.pp
                selMove.maxPP = fetchedMove.pp
                selMove.dmgOrBuff = fetchedMove.damage_class.name
                if !fetchedMove.stat_changes.isEmpty{
                    selMove.statusDetails.statChange = fetchedMove.stat_changes[0].change
                    selMove.statusDetails.statInflicted = fetchedMove.stat_changes[0].stat.name
                    selMove.statusDetails.target = fetchedMove.target.name
                }
                    selMove.ailment = fetchedMove.meta.ailment.name
                    selMove.ailmentChance = fetchedMove.meta.ailment_chance
                    selMove.category = fetchedMove.meta.category.name
                    selMove.healing = fetchedMove.meta.healing
                    selMove.drain = fetchedMove.meta.drain
                    selMove.max_hits = fetchedMove.meta.max_hits ?? 0
                    selMove.min_hits = fetchedMove.meta.min_hits ?? 0
                    selMove.max_turns = fetchedMove.meta.max_turns ?? 0
                    selMove.min_turns = fetchedMove.meta.min_turns ?? 0
                startTeam.MoveList.append(selMove)
                print(startTeam.MoveList)
                group.leave()
                    print("added move \(selMove.Name).\(selMove.min_hits)")
            }
            }
            })
        }
        group.notify(queue: .main) {
            var userTeam:PokemonTeam = PokemonTeam()
            userTeam.Pkmn.append(startTeam)
            TeamUtils().saveTeam(Team: userTeam)
            completion(true)
            }
    }
}


struct SelectStarter: View{
    @State var selectedPokemon = 0
    @State var buttonActive = true
    @State var goHome = false
    var body: some View{
        VStack{
            Button(action:{selectedPokemon = 1;buttonActive = false},label: {
                Spacer()
                HStack{
                    PkmnImage(imageLink:"https://pokeapi.co/api/v2/pokemon/1", front:true).padding()
                    Text("Bulbasaur").foregroundColor(.white).padding()
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                    .background(.green)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray,lineWidth: self.selectedPokemon == 1 ? 3 : 0))
                Spacer()
            })
            Button(action:{selectedPokemon=4;buttonActive = false},label: {
                Spacer()
                HStack{
                    PkmnImage(imageLink:"https://pokeapi.co/api/v2/pokemon/4", front:true).padding()
                    Text("Charmander").padding().foregroundColor(.white)
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                    .background(.red)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray,lineWidth: self.selectedPokemon == 4 ? 3 : 0))
                Spacer()
            })
            Button(action:{selectedPokemon=7;buttonActive = false},label: {
                Spacer()
                HStack{
                    PkmnImage(imageLink:"https://pokeapi.co/api/v2/pokemon/7", front:true).padding()
                    Text("Squirtle").padding().foregroundColor(.white)
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                    .background(.blue)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray,lineWidth: self.selectedPokemon == 7 ? 3 : 0))
                Spacer()
            })
            Spacer()
            Button("Start your journey!"){
                getStarter(selectedPokemon:selectedPokemon){bool in
                    goHome = bool
                }
            }.disabled(buttonActive)
        }
        Spacer()
        
        NavigationLink("", destination:HomeScreen(), isActive:$goHome)
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
