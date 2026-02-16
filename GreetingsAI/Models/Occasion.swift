
import Foundation
import SwiftUI

// Enum representing the various occasions for greeting cards.
// Each case provides an associated SF Symbol and a default color palette.
enum Occasion: String, CaseIterable, Identifiable, Codable {
    case birthday
    case christmas
    case hanukkah
    case diwali
    case eid
    case lunarNewYear
    case thankYou
    case congratulations
    case sympathy
    case generic

    var id: String { self.rawValue }

    // Provides a user-friendly display name for the occasion.
    var displayName: String {
        switch self {
        case .lunarNewYear:
            return "Lunar New Year"
        case .thankYou:
            return "Thank You"
        default:
            return self.rawValue.capitalized
        }
    }

    // Returns an appropriate SF Symbol for the occasion.
    var sfSymbol: String {
        switch self {
        case .birthday:
            return "gift.fill"
        case .christmas:
            return "tree.fill"
        case .hanukkah:
            return "menorah.fill"
        case .diwali:
            return "light.beacon.max.fill"
        case .eid:
            return "moon.stars.fill"
        case .lunarNewYear:
            return "lantern.fill"
        case .thankYou:
            return "heart.fill"
        case .congratulations:
            return "sparkles"
        case .sympathy:
            return "leaf.fill"
        case .generic:
            return "photo.on.rectangle.angled"
        }
    }

    // Provides a default color palette suitable for the occasion.
    var defaultColors: [Color] {
        switch self {
        case .birthday:
            return [.yellow, .pink, .cyan, .purple]
        case .christmas:
            return [Color(red: 0.8, green: 0, blue: 0.1), Color(red: 0, green: 0.5, blue: 0.2)]
        case .hanukkah:
            return [Color(red: 0, green: 0.3, blue: 0.8), .white, .yellow]
        case .diwali:
            return [.orange, .yellow, .red, .purple]
        case .eid:
            return [Color(red: 0, green: 0.4, blue: 0.2), .yellow, .white]
        case .lunarNewYear:
            return [.red, .yellow, .orange]
        case .thankYou:
            return [.pink, .red, .purple]
        case .congratulations:
            return [.yellow, .orange, .cyan]
        case .sympathy:
            return [.gray, .blue, Color(red: 0.8, green: 0.9, blue: 1.0)]
        case .generic:
            return [.gray, .lightGray]
        }
    }
}
