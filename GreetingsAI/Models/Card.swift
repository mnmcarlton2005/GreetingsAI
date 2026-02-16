
import Foundation
import SwiftUI

// Represents a single greeting card, combining AI-generated content with user customizations.
struct Card: Identifiable, Codable, Hashable {
    // Unique identifier for the card.
    @DocumentID var id: String?
    
    // The user who created or owns the card.
    var userId: String
    
    // The specific occasion for the card (e.g., Birthday, Christmas).
    let occasion: Occasion
    
    // The AI-generated message for the card.
    var message: String
    
    // URL or data for the AI-generated image.
    var imageUrl: String
    
    // Custom text overlays added by the user.
    var textOverlays: [TextOverlay]
    
    // The date the card was created.
    var createdAt: Date
    
    // A simple struct for text overlays
    struct TextOverlay: Codable, Hashable {
        var text: String
        var position: CGPoint
        var fontName: String
        var fontSize: CGFloat
        var color: CodableColor
    }
    
    // A wrapper to make Color codable
    struct CodableColor: Codable, Hashable {
        var red: Double
        var green: Double
        var blue: Double
        var opacity: Double
        
        init(_ color: Color) {
            if let components = color.cgColor?.components, components.count >= 3 {
                self.red = Double(components[0])
                self.green = Double(components[1])
                self.blue = Double(components[2])
                self.opacity = Double(components.count >= 4 ? components[3] : 1.0)
            } else {
                // Default to black if components are not available
                self.red = 0
                self.green = 0
                self.blue = 0
                self.opacity = 1
            }
        }
        
        var color: Color {
            Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
        }
    }
}
