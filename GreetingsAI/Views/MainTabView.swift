
import SwiftUI

// The main tab-based navigation for the app.
struct MainTabView: View {
    
    @State private var authViewModel = AuthViewModel()
    
    var body: some View {
        // Check if the user is authenticated.
        if authViewModel.user != nil {
            TabView {
                // Home Tab
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                // Create Tab
                NavigationStack {
                    WizardView()
                }
                .tabItem {
                    Label("Create", systemImage: "plus.square.fill")
                }
                
                // Library Tab
                NavigationStack {
                    LibraryView()
                }
                .tabItem {
                    Label("Library", systemImage: "rectangle.stack.fill")
                }
                
                // Settings Tab
                NavigationStack {
                    SettingsView(authViewModel: authViewModel)
                }
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
            }
            .environment(authViewModel)
        } else {
            // If not authenticated, show a loading or sign-in view.
            VStack(spacing: 20) {
                Text("GreetingsAI")
                    .font(.largeTitle.bold())
                
                if authViewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Please sign in to continue.")
                    SignInView(authViewModel: authViewModel)
                }
                
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
    }
}

// A dedicated view for handling "Sign in with Apple".
struct SignInView: View {
    @Bindable var authViewModel: AuthViewModel
    
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: authViewModel.handleSignInResult
        )
        .signInWithAppleButtonStyle(.black)
        .frame(width: 280, height: 45)
        .cornerRadius(8)
    }
}


// A simple Settings View for signing out.
struct SettingsView: View {
    @Bindable var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
            Spacer()
            Button("Sign Out", action: authViewModel.signOut)
                .buttonStyle(.borderedProminent)
                .tint(.red)
            Spacer()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    MainTabView()
}
