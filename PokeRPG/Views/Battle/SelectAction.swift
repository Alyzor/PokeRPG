//
//  SelectAction.swift
//  PokeRPG
//
//  Created by Alyzor on 25/06/2023.
//

import SwiftUI

struct SelectAction: View {
    @StateObject var viewModel = BattleUtils(team1:PokemonTeam(), team2:PokemonTeam())
    var body: some View{
        VStack{
            HStack{
                Button("Fight"){
                    viewModel.screenView = true
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(viewModel.enableBtns)
                Divider()
                Button("Bag"){
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(viewModel.enableBtns)
            }
            Divider()
            HStack{
                Button("Switch"){
                    viewModel.gotoTeam = true
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(viewModel.enableBtns)
                Divider()
                Button("Run"){
                    viewModel.battleReport = "You have fled!"
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        viewModel.goEscape = true
                    }
                }.frame(maxWidth:.infinity, maxHeight:.infinity).disabled(viewModel.enableBtns)
            }
        }.background(.red).foregroundColor(.white).cornerRadius(5).padding()
        NavigationLink("", destination:TeamViewer(), isActive: $viewModel.gotoTeam)
        NavigationLink("", destination:HomeScreen(), isActive: $viewModel.goEscape)
    }
}
