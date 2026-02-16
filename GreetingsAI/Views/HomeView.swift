
import SwiftUI

// The home screen of the app, serving as a dashboard with featured occasions.
struct HomeView: View {
    
    // An array of occasions to feature on the home screen.
    private let featuredOccasions: [Occasion] = [.birthday, .christmas, .thankYou, .congratulations]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                // Header
                Text("Welcome to GreetingsAI")
                    .font(Theme.Fonts.bold(size: 28))
                    .padding(.horizontal)
                
                Text("Start by choosing an occasion.")
                    .font(Theme.Fonts.regular(size: 18))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .padding(.horizontal)

                // Featured Occasions Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.medium) {
                    ForEach(featuredOccasions) { occasion in
                        NavigationLink(value: occasion) {
                            OccasionCard(occasion: occasion)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .background(Theme.Colors.background)
        .navigationTitle("Home")
        .navigationDestination(for: Occasion.self) { occasion in
            // Navigate to the wizard with the selected occasion
            WizardView(viewModel: CreationViewModel(initialOccasion: occasion))
        }
    }
}

// A view for displaying a single occasion card.
struct OccasionCard: View {
    let occasion: Occasion
    
    var body: some View {
        VStack {
            Image(systemName: occasion.sfSymbol)
                .font(.largeTitle)
                .foregroundColor(occasion.defaultColors.first ?? .accentColor)
                .frame(height: 60)
            
            Text(occasion.displayName)
                .font(Theme.Fonts.medium(size: 16))
                .foregroundColor(Theme.Colors.primaryText)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Theme.Colors.secondaryBackground)
        .cornerRadius(Theme.CornerRadius.large)
        .shadow(radius: 2, x: 0, y: 1)
    }
}

// Add a convenience initializer to CreationViewModel for starting with an occasion
extension CreationViewModel {
    convenience init(initialOccasion: Occasion) {
        self.init()
        self.occasion = initialOccasion
    }
}


#Preview {
    NavigationStack {
        HomeView()
    }
}
