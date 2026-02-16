
import Foundation

// Defines the stylistic theme for a greeting card.
enum AppStyle: String, CaseIterable, Identifiable, Codable {
    case modern
    case minimalist
    case vintage
    case playful
    case elegant

    var id: String { self.rawValue }

    var displayName: String {
        self.rawValue.capitalized
    }
}
