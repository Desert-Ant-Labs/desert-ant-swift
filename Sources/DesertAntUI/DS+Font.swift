import SwiftUI

extension DS {
    /// Brand fonts. Values track `design-system/tokens/typography.css`.
    ///
    /// - **Display** — Instrument Serif (editorial, the manifesto voice).
    ///   Falls back to the system serif so the brand still reads if the
    ///   custom face isn't installed.
    /// - **Sans** — Hanken Grotesk (UI + body workhorse). Falls back to the
    ///   platform sans.
    /// - **Mono** — JetBrains Mono (data, coordinate labels). Falls back to
    ///   the platform mono.
    ///
    /// The Google fonts are not bundled in this package: an app embeds the
    /// woff2/ttf files itself or installs them via `UIAppFonts`. The fallbacks
    /// keep layouts intact while the brand face loads.
    public enum Font {

        // MARK: Family names

        public static let displayName = "InstrumentSerif-Regular"
        public static let sansName    = "HankenGrotesk-Regular"
        public static let monoName    = "JetBrainsMono-Regular"

        // MARK: Faces

        /// Instrument Serif at `size`. Used for large titles and "Eye"-style
        /// headlines. Falls back to `.serif`.
        public static func display(_ size: CGFloat) -> SwiftUI.Font {
            .custom(displayName, size: size, relativeTo: .largeTitle)
                .weight(.regular)
        }

        /// Hanken Grotesk. UI default. Falls back to system sans.
        public static func sans(_ size: CGFloat, weight: SwiftUI.Font.Weight = .regular) -> SwiftUI.Font {
            .custom(sansName, size: size, relativeTo: .body).weight(weight)
        }

        /// JetBrains Mono. Used for eyebrows, stats, and coordinate labels.
        public static func mono(_ size: CGFloat, weight: SwiftUI.Font.Weight = .medium) -> SwiftUI.Font {
            .custom(monoName, size: size, relativeTo: .caption).weight(weight)
        }

        // MARK: Type scale (from typography.css, in points)

        public static let text2xs:  CGFloat = 11
        public static let textXs:   CGFloat = 12
        public static let textSm:   CGFloat = 13
        public static let textBase: CGFloat = 15
        public static let textMd:   CGFloat = 16
        public static let textLg:   CGFloat = 18
        public static let textXl:   CGFloat = 22
        public static let text2xl:  CGFloat = 28
        public static let text3xl:  CGFloat = 36
        public static let text4xl:  CGFloat = 48
        public static let text5xl:  CGFloat = 64
        public static let text6xl:  CGFloat = 88
        public static let text7xl:  CGFloat = 120

        // MARK: Tracking (kerning), in points-per-em-ish — SwiftUI's kerning
        // is absolute points, so these are scaled at call time. Use
        // `.kerning(DS.Font.trackingWider * size)` for proportional kerning.

        public static let trackingTighter: CGFloat = -0.030
        public static let trackingTight:   CGFloat = -0.015
        public static let trackingNormal:  CGFloat =  0.000
        public static let trackingWide:    CGFloat =  0.040
        public static let trackingWider:   CGFloat =  0.100
        public static let trackingWidest:  CGFloat =  0.180
    }
}
