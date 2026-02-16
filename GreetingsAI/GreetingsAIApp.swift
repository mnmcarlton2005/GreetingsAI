
import SwiftUI

@main
struct GreetingsAIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        MainTabView()
            .onAppear {
                // This is a good place to set up global configurations,
                // like the appearance of UI components.
                UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "HelveticaNeue-Bold", size: 34)!]
                UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "HelveticaNeue-Medium", size: 18)!]
            }
    }
}
