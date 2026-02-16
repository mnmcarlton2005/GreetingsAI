
import SwiftUI

// Centralized design system for the GreetingsAI app.
// Contains predefined colors, fonts, and other UI constants.
enum Theme {

    // MARK: - Colors
    // Defines the primary color palette for the app, with support for light and dark modes.
    enum Colors {
        static let background = Color("BackgroundColor")
        static let secondaryBackground = Color("SecondaryBackgroundColor")
        static let accent = Color("AccentColor")
        static let primaryText = Color("PrimaryTextColor")
        static let secondaryText = Color("SecondaryTextColor")
        static let error = Color.red
        static let success = Color.green
    }

    // MARK: - Fonts
    // Defines the typography used throughout the app.
    // These would typically be custom fonts, but we'll use system fonts for this example.
    enum Fonts {
        static func regular(size: CGFloat) -> Font {
            .system(size: size, weight: .regular)
        }
        
        static func bold(size: CGFloat) -> Font {
            .system(size: size, weight: .bold)
        }
        
        static func medium(size: CGFloat) -> Font {
            .system(size: size, weight: .medium)
        }
    }
    
    // MARK: - Spacing
    // Standardized spacing values for consistent layout.
    enum Spacing {
        static let xsmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xlarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    // Standardized corner radius values.
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 20
    }
}
