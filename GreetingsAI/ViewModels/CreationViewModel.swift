
import SwiftUI
import PhotosUI

// Manages the state and logic for the entire card creation process.
@Observable
final class CreationViewModel {
    
    // MARK: - Dependencies
    private let aiService: AIService
    private let storageService: StorageService
    
    // MARK: - Wizard State
    var recipient: String = ""
    var occasion: Occasion = .birthday
    var style: AppStyle = .modern
    var mood: String = ""
    
    // MARK: - Editor State
    var generatedMessage: String = ""
    var generatedImagePrompt: String = ""
    var generatedImageData: Data?
    var customImage: PhotosPickerItem? {
        didSet {
            Task { await loadImage(from: customImage) }
        }
    }
    
    // MARK: - General State
    var isLoading: Bool = false
    var errorMessage: String?
    var createdCard: Card?

    init(aiService: AIService = AIService(), storageService: StorageService = StorageService()) {
        self.aiService = aiService
        self.storageService = storageService
    }
    
    // MARK: - Wizard Logic
    func generateContent() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let (imagePrompt, message) = try await aiService.generateCardContent(
                occasion: occasion,
                theme: style,
                mood: mood,
                recipient: recipient
            )
            self.generatedImagePrompt = imagePrompt
            self.generatedMessage = message
            
            // Now generate the image based on the new prompt
            await generateImage()
            
        } catch let error as AIError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Editor Logic
    func generateImage() async {
        guard !generatedImagePrompt.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            self.generatedImageData = try await aiService.generateImage(prompt: generatedImagePrompt)
        } catch let error as AIError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "An unexpected error occurred during image generation."
        }
        
        isLoading = false
    }

    // MARK: - Data Persistence
    func saveCard(userId: String) async {
        guard let imageData = generatedImageData else {
            errorMessage = "Cannot save card without an image."
            return
        }
        
        // In a real app, you would upload the image to cloud storage
        // and get a URL. For now, we'll use a placeholder.
        let imageUrl = "placeholder_url_\(UUID().uuidString)"
        
        let newCard = Card(
            userId: userId,
            occasion: occasion,
            message: generatedMessage,
            imageUrl: imageUrl,
            textOverlays: [], // Add text overlays from editor state
            createdAt: Date()
        )
        
        do {
            try await storageService.saveCard(newCard)
            self.createdCard = newCard
        } catch {
            self.errorMessage = "Failed to save the card. Please try again."
        }
    }
    
    // MARK: - Private Helpers
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                self.generatedImageData = data
            }
        } catch {
            errorMessage = "Failed to load the selected image."
        }
    }
    
    func reset() {
        recipient = ""
        occasion = .birthday
        style = .modern
        mood = ""
        generatedMessage = ""
        generatedImagePrompt = ""
        generatedImageData = nil
        customImage = nil
        isLoading = false
        errorMessage = nil
        createdCard = nil
    }
}
