import SwiftUI

extension DS {
    /// Semantic + raw brand colors. Values track `design-system/tokens/colors.css`.
    ///
    /// Semantic aliases (`textPrimary`, `bgCanvas`, `accent`, …) are the
    /// preferred API: they resolve light/dark automatically through
    /// `Color(light:dark:)`. Raw ramps (`sand500`, `sky400`, …) are exposed
    /// for cases where a specific stop is wanted.
    public enum Color {

        // MARK: Semantic — Background

        public static let bgCanvas      = SwiftUI.Color(light: sand50,   dark: hex(0x0E1113))
        public static let bgSurface     = SwiftUI.Color(light: paper,    dark: hex(0x15181B))
        public static let bgRaised      = SwiftUI.Color(light: white,    dark: hex(0x1C2023))
        public static let bgSunken      = SwiftUI.Color(light: sand100,  dark: hex(0x090B0C))
        public static let bgInset       = SwiftUI.Color(light: sand200,  dark: hex(0x242A2D))
        public static let bgInverse     = SwiftUI.Color(light: sand950,  dark: sand50)
        public static let bgAccent      = SwiftUI.Color(light: sky500,   dark: sky400)
        public static let bgAccentSoft  = SwiftUI.Color(light: sky50,    dark: hex(0x15203A))

        // MARK: Semantic — Text

        public static let textPrimary   = SwiftUI.Color(light: sand950, dark: sand50)
        public static let textSecondary = SwiftUI.Color(light: sand700, dark: sand300)
        public static let textMuted     = SwiftUI.Color(light: sand500, dark: sand500)
        public static let textFaint     = SwiftUI.Color(light: sand400, dark: sand600)
        public static let textInverse   = SwiftUI.Color(light: sand50,  dark: sand950)
        public static let textAccent    = SwiftUI.Color(light: sky600,  dark: sky300)
        public static let textOnAccent  = white

        // MARK: Semantic — Border

        public static let borderSubtle  = SwiftUI.Color(light: sand200, dark: hex(0x262C30))
        public static let borderDefault = SwiftUI.Color(light: sand300, dark: hex(0x353C40))
        public static let borderStrong  = SwiftUI.Color(light: sand400, dark: hex(0x49514F))
        public static let borderInverse = SwiftUI.Color(light: sand800, dark: sand200)
        public static let borderAccent  = SwiftUI.Color(light: sky500,  dark: sky400)

        // MARK: Semantic — Accent

        public static let accent          = SwiftUI.Color(light: sky500, dark: sky400)
        public static let accentHover     = SwiftUI.Color(light: sky600, dark: sky300)
        public static let accentPress     = SwiftUI.Color(light: sky700, dark: sky200)
        public static let accentContrast  = SwiftUI.Color(light: white,  dark: sand950)

        public static let focusRing       = SwiftUI.Color(light: sky500, dark: sky300)
        public static let selectionBg     = SwiftUI.Color(light: sky200, dark: sky700)
        public static let selectionFg     = SwiftUI.Color(light: sand950, dark: sand50)

        // MARK: Semantic — Signals

        public static let success = SwiftUI.Color(light: moss500, dark: hex(0x5EA873))
        public static let warning = SwiftUI.Color(light: amber500, dark: hex(0xD88B3A))
        public static let danger  = SwiftUI.Color(light: oxide500, dark: hex(0xD55546))
        public static let info    = SwiftUI.Color(light: teal500, dark: hex(0x3FA8A8))

        // MARK: Raw ramps — sand (cool silver → obsidian)

        public static let sand50  = hex(0xF4F5F5)
        public static let sand100 = hex(0xE8EAEB)
        public static let sand200 = hex(0xD7DBDC)
        public static let sand300 = hex(0xBEC4C6)
        public static let sand400 = hex(0x9DA4A8)
        public static let sand500 = hex(0x7A8286)
        public static let sand600 = hex(0x5A6266)
        public static let sand700 = hex(0x41484C)
        public static let sand800 = hex(0x2C3134)
        public static let sand900 = hex(0x1A1E20)
        public static let sand950 = hex(0x0E1113)

        // MARK: Raw ramps — sky (polarized-sky cobalt accent)

        public static let sky50  = hex(0xECF0FC)
        public static let sky100 = hex(0xD6DFFA)
        public static let sky200 = hex(0xAFC1F3)
        public static let sky300 = hex(0x839DEB)
        public static let sky400 = hex(0x5675DC)
        public static let sky500 = hex(0x2D52C8)
        public static let sky600 = hex(0x2241A8)
        public static let sky700 = hex(0x1C3585)
        public static let sky800 = hex(0x182A63)
        public static let sky900 = hex(0x131F45)

        // MARK: Raw ramps — steel (silver-steel secondary)

        public static let steel50  = hex(0xEEF1F2)
        public static let steel100 = hex(0xDCE2E4)
        public static let steel200 = hex(0xBDC9CD)
        public static let steel300 = hex(0x97A8AD)
        public static let steel400 = hex(0x71868C)
        public static let steel500 = hex(0x566D73)
        public static let steel600 = hex(0x42565B)
        public static let steel700 = hex(0x324246)
        public static let steel800 = hex(0x232F32)
        public static let steel900 = hex(0x161E20)

        // MARK: Raw — signal stops

        public static let moss500  = hex(0x3C8A52)
        public static let moss50   = hex(0xE5F1E8)
        public static let amber500 = hex(0xC2691A)
        public static let amber50  = hex(0xFAEBD8)
        public static let oxide500 = hex(0xBE3A2E)
        public static let oxide50  = hex(0xFAE6E3)
        public static let teal500  = hex(0x1E8C8C)
        public static let teal50   = hex(0xDEF1F1)

        // MARK: Pure

        public static let paper = hex(0xFBFCFC)
        public static let black = hex(0x090B0C)
        public static let white = SwiftUI.Color(red: 1, green: 1, blue: 1)

        // MARK: hex helper

        private static func hex(_ value: UInt32) -> SwiftUI.Color {
            let r = Double((value >> 16) & 0xFF) / 255.0
            let g = Double((value >> 8) & 0xFF) / 255.0
            let b = Double(value & 0xFF) / 255.0
            return SwiftUI.Color(red: r, green: g, blue: b)
        }
    }
}

extension SwiftUI.Color {
    /// Resolves to `light` or `dark` based on the current `colorScheme`.
    /// Uses UIKit/AppKit dynamic providers so the result tracks scheme changes
    /// without requiring an `@Environment` lookup at the call site.
    fileprivate init(light: SwiftUI.Color, dark: SwiftUI.Color) {
        #if canImport(UIKit)
        self = SwiftUI.Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #elseif canImport(AppKit)
        self = SwiftUI.Color(NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .vibrantDark]) != nil
            return isDark ? NSColor(dark) : NSColor(light)
        })
        #else
        self = light
        #endif
    }
}
