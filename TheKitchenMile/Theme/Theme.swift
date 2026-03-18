import SwiftUI

// MARK: - Font Registration

enum FontLoader {
    static var didRegister = false

    static func registerFonts() {
        guard !didRegister else { return }
        didRegister = true

        let fontNames = [
            "Barlow-Regular",
            "Barlow-SemiBold",
            "Barlow-Bold",
            "Barlow-ExtraBold",
            "BarlowCondensed-Medium",
            "BarlowCondensed-SemiBold",
            "BarlowCondensed-Bold",
        ]

        for name in fontNames {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf", subdirectory: "Fonts") else {
                print("[FontLoader] Missing font file: \(name).ttf")
                continue
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

// MARK: - Design Tokens

enum Theme {
    // MARK: - Spacing
    static let spacing4: CGFloat = 4
    static let spacing8: CGFloat = 8
    static let spacing12: CGFloat = 12
    static let spacing16: CGFloat = 16
    static let spacing24: CGFloat = 24
    static let spacing32: CGFloat = 32
    static let spacing40: CGFloat = 40

    // MARK: - Corner Radius
    static let cornerRadius: CGFloat = 10
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusBadge: CGFloat = 4
    static let cornerRadiusNav: CGFloat = 6

    // MARK: - Card
    static let cardPadding: CGFloat = 16
    static let cardBorderWidth: CGFloat = 1
    static let segmentedPadding: CGFloat = 3
    static let progressBarHeight: CGFloat = 3

    // MARK: - Window
    static let windowDefaultWidth: CGFloat = 860
    static let windowDefaultHeight: CGFloat = 680
    static let windowMinWidth: CGFloat = 720
    static let windowMinHeight: CGFloat = 560

    // MARK: - Dark Colors (default)
    static let bgDark = Color(hex: 0x0A0A0A)
    static let surfaceDark = Color(hex: 0x141414)
    static let surface2Dark = Color(hex: 0x1E1E1E)
    static let surface3Dark = Color(hex: 0x252525)
    static let borderDark = Color(hex: 0x2A2A2A)
    static let textDark = Color.white
    static let text2Dark = Color(hex: 0x888888)
    static let text3Dark = Color(hex: 0x444444)

    // MARK: - Light Colors
    static let bgLight = Color(hex: 0xFFFFFF)
    static let surfaceLight = Color(hex: 0xF5F5F5)
    static let surface2Light = Color(hex: 0xEEEEEE)
    static let surface3Light = Color(hex: 0xE0E0E0)
    static let borderLight = Color(hex: 0xE5E5E5)
    static let textLight = Color(hex: 0x1A1A1A)
    static let text2Light = Color(hex: 0x888888)
    static let text3Light = Color(hex: 0xAAAAAA)

    // MARK: - Accent (same in both themes)
    static let accent = Color(hex: 0xC8F135)
    static let accentDim = Color(red: 200.0/255.0, green: 241.0/255.0, blue: 53.0/255.0).opacity(0.12)
    static let accentBorder = Color(red: 200.0/255.0, green: 241.0/255.0, blue: 53.0/255.0).opacity(0.3)
    static let overTargetColor = Color(hex: 0xF59E0B)
    static let errorColor = Color(hex: 0xEF4444)

    // MARK: - Adaptive Colors (resolved at call site)
    static var bg: Color { bgDark }
    static var surface: Color { surfaceDark }
    static var surface2: Color { surface2Dark }
    static var surface3: Color { surface3Dark }
    static var border: Color { borderDark }
    static var text: Color { textDark }
    static var text2: Color { text2Dark }
    static var text3: Color { text3Dark }

    // MARK: - Light mode color set
    static func colors(for mode: AppearanceMode) -> ThemeColorSet {
        switch mode {
        case .dark:
            return ThemeColorSet(
                bg: bgDark, surface: surfaceDark, surface2: surface2Dark, surface3: surface3Dark,
                border: borderDark, text: textDark, text2: text2Dark, text3: text3Dark
            )
        case .light:
            return ThemeColorSet(
                bg: bgLight, surface: surfaceLight, surface2: surface2Light, surface3: surface3Light,
                border: borderLight, text: textLight, text2: text2Light, text3: text3Light
            )
        }
    }
}

struct ThemeColorSet {
    let bg: Color
    let surface: Color
    let surface2: Color
    let surface3: Color
    let border: Color
    let text: Color
    let text2: Color
    let text3: Color
}

// MARK: - Appearance Mode

enum AppearanceMode: String, CaseIterable {
    case dark
    case light
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

// MARK: - Barlow Font Definitions

extension Font {
    // Screen titles — 44px
    static let displayLarge = Font.custom("BarlowCondensed-Bold", size: 44)
    // Section headings — 36px
    static let displayMedium = Font.custom("BarlowCondensed-Bold", size: 36)
    // Training card names — 22px
    static let displaySmall = Font.custom("BarlowCondensed-Bold", size: 22)
    // Card names, meal plan header — 20px
    static let headingLarge = Font.custom("BarlowCondensed-Bold", size: 20)
    // Section titles (Breakfast, etc.) — 18px
    static let headingMedium = Font.custom("BarlowCondensed-Bold", size: 18)
    // Macro values — 16px
    static let headingSmall = Font.custom("BarlowCondensed-Bold", size: 16)
    // Weight input large number — 48px
    static let numberLarge = Font.custom("BarlowCondensed-Bold", size: 48)
    // Total kcal — 22px
    static let numberMedium = Font.custom("BarlowCondensed-Bold", size: 22)

    // Body text — 13px
    static let bodyRegular = Font.custom("Barlow-Regular", size: 13)
    // Body semibold — 13px
    static let bodyMedium = Font.custom("Barlow-SemiBold", size: 13)
    // Small body — 12px
    static let bodySmall = Font.custom("Barlow-Regular", size: 12)
    // Small body semibold — 12px
    static let bodySmallMedium = Font.custom("Barlow-SemiBold", size: 12)

    // Ingredient text — 11px
    static let ingredientText = Font.custom("Barlow-Regular", size: 11)
    // Ingredient text medium — 11px semibold
    static let ingredientMedium = Font.custom("Barlow-SemiBold", size: 11)

    // Eyebrow labels — 11px Barlow Condensed 600
    static let eyebrow = Font.custom("BarlowCondensed-SemiBold", size: 11)
    // Small eyebrow — 10px Bold
    static let eyebrowSmall = Font.custom("Barlow-Bold", size: 10)
    // Micro eyebrow — 9px Bold
    static let eyebrowMicro = Font.custom("Barlow-Bold", size: 9)

    // CTA buttons — 15px
    static let button = Font.custom("Barlow-Bold", size: 15)
}
