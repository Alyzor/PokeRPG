import SwiftUI

struct HomeScreen: View {
    @State private var wasClicked = false
    var body: some View {
        NavigationView{
        ZStack{
            HStack{
                Spacer()
            VStack{
                
                Spacer()
                Text("PokeRPG").font(.largeTitle).foregroundColor(.black)
                    .onAppear{ PokeAPI().fetchData(){ pokemon in
                        for pokemon in pokemon{
                            print(pokemon.name)
                        }
                    }}
                Spacer()
                NavigationLink(destination: ContentView(), isActive:$wasClicked){EmptyView()}
                Button("Get Started!",action:{wasClicked = true
                }).buttonStyle(.borderedProminent).tint(Color.red)
                Spacer()
            }
                Spacer()
            }
        }.background(Color.white.edgesIgnoringSafeArea(.all))
            
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
