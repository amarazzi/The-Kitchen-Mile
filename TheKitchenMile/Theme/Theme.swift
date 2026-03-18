import SwiftUI

// MARK: - Design Tokens

enum Theme {
    // MARK: - Spacing
    static let spacing4: CGFloat = 4
    static let spacing8: CGFloat = 8
    static let spacing16: CGFloat = 16
    static let spacing24: CGFloat = 24
    static let spacing32: CGFloat = 32
    static let spacing40: CGFloat = 40

    // MARK: - Corner Radius
    static let cornerRadius: CGFloat = 8

    // MARK: - Card
    static let cardPadding: CGFloat = 16
    static let quickCardBorderWidth: CGFloat = 2
    static let cardBorderWidth: CGFloat = 1

    // MARK: - Window
    static let windowDefaultWidth: CGFloat = 860
    static let windowDefaultHeight: CGFloat = 680
    static let windowMinWidth: CGFloat = 720
    static let windowMinHeight: CGFloat = 560

    // MARK: - Training Type Colors
    static let easyRunColor = Color(hex: 0x4CAF50)
    static let qualityColor = Color(hex: 0xF59E0B)
    static let longRunColor = Color(hex: 0x3B82F6)
    static let restDayColor = Color(hex: 0x4CAF50)
    static let errorColor = Color(hex: 0xEF4444)
}

// MARK: - Appearance Mode

enum AppearanceMode: String, CaseIterable {
    case dark
    case light
}

// MARK: - Theme Colors

struct ThemeColors {
    let background: Color
    let surface: Color
    let border: Color
    let primaryText: Color
    let secondaryText: Color
    let tertiaryText: Color
}

extension Theme {
    static let darkColors = ThemeColors(
        background: Color(hex: 0x0A0A0A),
        surface: Color(hex: 0x111111),
        border: Color(hex: 0x1F1F1F),
        primaryText: Color(hex: 0xF0F0F0),
        secondaryText: Color(hex: 0x555555),
        tertiaryText: Color(hex: 0x333333)
    )

    static let lightColors = ThemeColors(
        background: Color(hex: 0xFFFFFF),
        surface: Color(hex: 0xF5F5F5),
        border: Color(hex: 0xE5E5E5),
        primaryText: Color(hex: 0x1A1A1A),
        secondaryText: Color(hex: 0x888888),
        tertiaryText: Color(hex: 0xCCCCCC)
    )

    static func colors(for mode: AppearanceMode) -> ThemeColors {
        switch mode {
        case .dark: return darkColors
        case .light: return lightColors
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}

// MARK: - Font Definitions

extension Font {
    static let headingLarge = Font.system(size: 24, weight: .semibold, design: .default)
    static let headingMedium = Font.system(size: 18, weight: .semibold, design: .default)
    static let headingSmall = Font.system(size: 15, weight: .semibold, design: .default)
    static let bodyRegular = Font.system(size: 13, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 13, weight: .medium, design: .default)
    static let caption = Font.system(size: 11, weight: .regular, design: .default)
    static let captionMedium = Font.system(size: 11, weight: .medium, design: .default)
}
