import SwiftUI

struct StartScreen: View {
    @State private var wasClicked = false
    @State var SelectedView:AnyView?
    let team:PokemonTeam = TeamUtils().getTeam()
    
    var body: some View {
        NavigationView{
        ZStack{
            HStack{
                Spacer()
            VStack{
                Spacer()
                Text("PokeRPG").font(.largeTitle).foregroundColor(.black)
                    .onAppear{
                        if !team.Pkmn.isEmpty{
                            SelectedView = AnyView(HomeScreen())
                        }else{
                            SelectedView = AnyView(NewGame())
                        }
                    }
                Spacer()
                NavigationLink(destination: SelectedView, isActive:$wasClicked){EmptyView()}
                Button("Get Started!",action:{wasClicked = true
                }).buttonStyle(.borderedProminent).tint(Color.red)
                Spacer()
            }
                Spacer()
            }
        }.background(Color.white.edgesIgnoringSafeArea(.all))
            
        }.navigationBarHidden(true)
    }
}

struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen()
    }
}
