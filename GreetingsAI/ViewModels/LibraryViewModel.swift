
import Foundation

// Manages the state and logic for the user's library of saved cards.
@Observable
final class LibraryViewModel {
    
    // MARK: - Dependencies
    private let storageService: StorageService
    
    // MARK: - State
    var savedCards: [Card] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    init(storageService: StorageService = StorageService()) {
        self.storageService = storageService
    }
    
    // Fetches the user's saved cards from the storage service.
    func fetchSavedCards(for userId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.savedCards = try await storageService.fetchCards(for: userId)
        } catch {
            self.errorMessage = "Failed to load your saved cards. Please check your connection and try again."
        }
        
        isLoading = false
    }
    
    // Deletes a card from the library.
    func deleteCard(_ card: Card) async {
        guard let cardId = card.id else {
            errorMessage = "Cannot delete a card without an ID."
            return
        }
        
        // Optimistically remove from the local array
        savedCards.removeAll { $0.id == cardId }
        
        do {
            try await storageService.deleteCard(cardId: cardId)
        } catch {
            errorMessage = "Failed to delete the card from the cloud. It may reappear."
            // Optionally, re-fetch the list to revert the change
        }
    }
}
