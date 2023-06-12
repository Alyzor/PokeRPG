import SwiftUI

struct HomeScreen: View {
    @State private var wasClicked = false
    @State var SelectedView:AnyView?
    var body: some View {
        NavigationView{
        ZStack{
            HStack{
                Spacer()
            VStack{
                Spacer()
                Text("PokeRPG").font(.largeTitle).foregroundColor(.black)
                    .onAppear{
                        
                        let hasStoredData = UserDefaults.standard.bool(forKey: "hasData")
                        if hasStoredData != true {
                            SelectedView = AnyView(PokeList())
                        }else{
                            SelectedView = AnyView(EmptyView())
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
            
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
