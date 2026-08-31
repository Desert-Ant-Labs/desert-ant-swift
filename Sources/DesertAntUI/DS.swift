import SwiftUI

/// The Desert Ant Labs brand kit: the mark, the drop loader, the semantic
/// colors, and the attribution lockup. Nothing else; components, fonts,
/// spacing, and the rest of the system live in the private brand repo and
/// on brand.desertant.com.
///
/// Colors are generated from the brand tokens (`DesignTokens.swift`, built by
/// Desert-Ant-Labs/brand). `DS.Color` is the semantic surface on top:
///
///     Text("Ready")
///         .foregroundStyle(DS.Color.textPrimary)
///         .tint(DS.Color.accent)
///
public enum DS {
    public enum Color {
        // MARK: Background
        public static let bgCanvas = DesignTokens.Colors.colorBgCanvas
        public static let bgSurface = DesignTokens.Colors.colorBgSurface
        public static let bgRaised = DesignTokens.Colors.colorBgRaised
        public static let bgSunken = DesignTokens.Colors.colorBgSunken
        public static let bgInverse = DesignTokens.Colors.colorBgInverse
        public static let bgTint = DesignTokens.Colors.colorBgTint

        // MARK: Text
        public static let textPrimary = DesignTokens.Colors.colorTextPrimary
        public static let textSecondary = DesignTokens.Colors.colorTextSecondary
        public static let textMuted = DesignTokens.Colors.colorTextMuted
        public static let textFaint = DesignTokens.Colors.colorTextFaint
        public static let textInverse = DesignTokens.Colors.colorTextInverse
        public static let textOnAccent = DesignTokens.Colors.colorTextOnAccent

        // MARK: Border and accent
        public static let borderSubtle = DesignTokens.Colors.colorBorderSubtle
        public static let borderDefault = DesignTokens.Colors.colorBorderDefault
        public static let borderStrong = DesignTokens.Colors.colorBorderStrong
        public static let accent = DesignTokens.Colors.colorAccentDefault
        public static let accentHover = DesignTokens.Colors.colorAccentHover
        public static let accentPress = DesignTokens.Colors.colorAccentPress
        public static let focusRing = DesignTokens.Colors.colorFocusRing

        // MARK: The palette
        public static let cream = DesignTokens.Colors.colorCream
        public static let ink = DesignTokens.Colors.colorInk
        public static let sage = DesignTokens.Colors.colorSage
        public static let teal = DesignTokens.Colors.colorTeal
        public static let forest = DesignTokens.Colors.colorForest
        public static let terracotta = DesignTokens.Colors.colorTerracotta
        public static let sand = DesignTokens.Colors.colorSand
        public static let warmGrey = DesignTokens.Colors.colorWarmGrey
        public static let clayRed = DesignTokens.Colors.colorClayRed
        public static let eucalyptus = DesignTokens.Colors.colorEucalyptus
        public static let darkTeal = DesignTokens.Colors.colorDarkTeal
    }
}
