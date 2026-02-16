
import SwiftUI

// Displays a gallery of the user's saved greeting cards.
struct LibraryView: View {
    
    @State private var viewModel = LibraryViewModel()
    @Environment(AuthViewModel.self) private var authViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading your library...")
            } else if viewModel.savedCards.isEmpty {
                ContentUnavailableView("No Saved Cards", systemImage: "rectangle.stack", description: Text("Your saved cards will appear here."))
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.savedCards) { card in
                            CardThumbnail(card: card)
                                .onTapGesture {
                                    // TODO: Implement navigation to a detailed view of the card
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("My Library")
        .task {
            // Fetch cards when the view appears.
            if let userId = authViewModel.user?.id {
                await viewModel.fetchSavedCards(for: userId)
            }
        }
        .refreshable {
            // Allow pull-to-refresh.
            if let userId = authViewModel.user?.id {
                await viewModel.fetchSavedCards(for: userId)
            }
        }
    }
}

// A view for a single card thumbnail in the library.
struct CardThumbnail: View {
    let card: Card
    
    var body: some View {
        VStack {
            // Placeholder for the card image. In a real app, this would use AsyncImage.
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(5/7, contentMode: .fit)
                .overlay(
                    Image(systemName: card.occasion.sfSymbol)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )
            
            Text(card.occasion.displayName)
                .font(.caption)
                .lineLimit(1)
            
            Text(card.createdAt, style: .date)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}


#Preview {
    NavigationStack {
        LibraryView()
            .environment(AuthViewModel())
    }
}
